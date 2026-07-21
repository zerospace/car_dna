import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/vehicle_info.dart';

/// Categories of failure that [VehicleInfoService.fetchByVin] can throw.
enum VehicleInfoErrorType {
  /// The VIN failed client-side validation or the API rejected its format (400).
  invalidVin,

  /// Missing / invalid API key (401 / 403).
  unauthorized,

  /// No vehicle data for this VIN (404).
  notFound,

  /// Too many requests (429).
  rateLimited,

  /// The server returned a 5xx response.
  server,

  /// The request never completed — no connectivity, timeout, DNS, etc.
  network,

  /// A 2xx response arrived but its body could not be parsed as expected.
  parsing,

  /// Anything not covered above.
  unknown,
}

/// Thrown by [VehicleInfoService] on any failure. Carries a machine-readable
/// [type] for branching plus a human-readable [message] for display.
///
/// Handle it in a view model:
/// ```dart
/// try {
///   final info = await service.fetchByVin(vin);
///   // update state with info
/// } on VehicleInfoException catch (e) {
///   // show e.message, branch on e.type
/// }
/// ```
class VehicleInfoException implements Exception {
  const VehicleInfoException(this.type, this.message, {this.statusCode});

  final VehicleInfoErrorType type;
  final String message;
  final int? statusCode;

  @override
  String toString() => 'VehicleInfoException($type, $statusCode): $message';
}

/// Decodes a VIN via the auto.dev VIN Decode API.
///
/// `GET https://api.auto.dev/vin/{vin}` with a Bearer token.
/// Docs: https://docs.auto.dev/v2/products/vin-decode
class VehicleInfoService {
  VehicleInfoService({
    required String apiKey,
    http.Client? client,
    Uri? baseUrl,
    Duration timeout = const Duration(seconds: 15),
  })  : _apiKey = apiKey,
        _client = client ?? http.Client(),
        _ownsClient = client == null,
        _baseUrl = baseUrl ?? Uri.parse('https://api.auto.dev'),
        _timeout = timeout;

  final String _apiKey;
  final http.Client _client;
  final bool _ownsClient;
  final Uri _baseUrl;
  final Duration _timeout;

  /// Decodes [vin] and returns the parsed [VehicleInfo].
  ///
  /// Throws [VehicleInfoException] on any failure (bad VIN, auth, network,
  /// server, parsing, …). Callers should wrap this in try/catch.
  Future<VehicleInfo> fetchByVin(String vin) async {
    final normalized = vin.trim().toUpperCase();
    if (normalized.length != 17) {
      throw const VehicleInfoException(
        VehicleInfoErrorType.invalidVin,
        'VIN must be 17 characters long.',
      );
    }

    final uri = _baseUrl.replace(pathSegments: [
      ..._baseUrl.pathSegments.where((s) => s.isNotEmpty),
      'vin',
      normalized,
    ]);

    final http.Response response;
    try {
      response = await _client.get(
        uri,
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Accept': 'application/json',
        },
      ).timeout(_timeout);
    } on VehicleInfoException {
      rethrow;
    } on SocketException catch (e) {
      throw VehicleInfoException(
        VehicleInfoErrorType.network,
        'No internet connection. Please try again. (${e.message})',
      );
    } on http.ClientException catch (e) {
      throw VehicleInfoException(
        VehicleInfoErrorType.network,
        'Network request failed: ${e.message}',
      );
    } on Exception catch (e) {
      throw VehicleInfoException(
        VehicleInfoErrorType.unknown,
        'Unexpected error: $e',
      );
    }

    return _parseResponse(response);
  }

  VehicleInfo _parseResponse(http.Response response) {
    final status = response.statusCode;

    if (status >= 200 && status < 300) {
      try {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        return VehicleInfo.fromJson(decoded);
      } catch (_) {
        throw const VehicleInfoException(
          VehicleInfoErrorType.parsing,
          'Received an unexpected response from the server.',
        );
      }
    }

    final (type, fallback) = switch (status) {
      400 => (VehicleInfoErrorType.invalidVin, 'The VIN format is invalid.'),
      401 || 403 => (
          VehicleInfoErrorType.unauthorized,
          'Not authorized. Check your API key.',
        ),
      404 => (
          VehicleInfoErrorType.notFound,
          'No vehicle data found for this VIN.',
        ),
      429 => (
          VehicleInfoErrorType.rateLimited,
          'Too many requests. Please try again shortly.',
        ),
      >= 500 => (
          VehicleInfoErrorType.server,
          'The server is having trouble. Please try again later.',
        ),
      _ => (VehicleInfoErrorType.unknown, 'Request failed (HTTP $status).'),
    };

    throw VehicleInfoException(
      type,
      _messageFromBody(response.body) ?? fallback,
      statusCode: status,
    );
  }

  /// Pulls the API's `error` field out of a JSON error body, if present.
  String? _messageFromBody(String body) {
    if (body.isEmpty) return null;
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map && decoded['error'] is String) {
        return decoded['error'] as String;
      }
    } catch (_) {
      // Non-JSON body — ignore and fall back to a generic message.
    }
    return null;
  }

  /// Releases the underlying HTTP client if this service created it.
  void dispose() {
    if (_ownsClient) _client.close();
  }
}
