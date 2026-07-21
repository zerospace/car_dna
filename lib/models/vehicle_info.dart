import 'dart:convert';

import 'package:flutter/foundation.dart';

/// Vehicle identification decoded from the auto.dev VIN Decode API.
///
/// Response shape: https://docs.auto.dev/v2/products/vin-decode
/// (`GET https://api.auto.dev/vin/{vin}`).
///
/// The class is designed for two jobs:
///  * parse the API payload via [VehicleInfo.fromJson];
///  * persist it via [toDbMap] / [VehicleInfo.fromDbMap]. The DB row keeps a
///    few flat, queryable columns (vin/year/make/model) plus the complete
///    payload as a JSON `data` blob, so no detail is lost on round-trip.
@immutable
class VehicleInfo {
  const VehicleInfo({
    required this.vin,
    this.vinValid,
    this.wmi,
    this.origin,
    this.squishVin,
    this.checkDigit,
    this.checksum,
    this.type,
    this.make,
    this.model,
    this.trim,
    this.style,
    this.body,
    this.engine,
    this.drive,
    this.transmission,
    this.vehicle,
    this.ambiguous,
  });

  /// The 17-character VIN that was decoded.
  final String vin;

  /// Whether the VIN passed the API's validity checks.
  final bool? vinValid;

  /// World Manufacturer Identifier (first three VIN characters).
  final String? wmi;

  /// Country / region where the vehicle originated.
  final String? origin;

  /// Compressed VIN used for spec lookups.
  final String? squishVin;

  /// The VIN check-digit character.
  final String? checkDigit;

  /// Whether the check-digit validation passed.
  final bool? checksum;

  final String? type;
  final String? make;
  final String? model;
  final String? trim;
  final String? style;
  final String? body;
  final String? engine;
  final String? drive;
  final String? transmission;

  /// Normalized identity block.
  final Vehicle? vehicle;

  /// Whether the VIN matched more than one possible vehicle.
  final bool? ambiguous;

  factory VehicleInfo.fromJson(Map<String, dynamic> json) {
    return VehicleInfo(
      vin: (json['vin'] ?? '') as String,
      vinValid: json['vinValid'] as bool?,
      wmi: json['wmi'] as String?,
      origin: json['origin'] as String?,
      squishVin: json['squishVin'] as String?,
      checkDigit: json['checkDigit'] as String?,
      checksum: json['checksum'] as bool?,
      type: json['type'] as String?,
      make: json['make'] as String?,
      model: json['model'] as String?,
      trim: json['trim'] as String?,
      style: json['style'] as String?,
      body: json['body'] as String?,
      engine: json['engine'] as String?,
      drive: json['drive'] as String?,
      transmission: json['transmission'] as String?,
      vehicle: json['vehicle'] == null
          ? null
          : Vehicle.fromJson(_asMap(json['vehicle'])),
      ambiguous: json['ambiguous'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
        'vin': vin,
        'vinValid': vinValid,
        'wmi': wmi,
        'origin': origin,
        'squishVin': squishVin,
        'checkDigit': checkDigit,
        'checksum': checksum,
        'type': type,
        'make': make,
        'model': model,
        'trim': trim,
        'style': style,
        'body': body,
        'engine': engine,
        'drive': drive,
        'transmission': transmission,
        if (vehicle != null) 'vehicle': vehicle!.toJson(),
        'ambiguous': ambiguous,
      };

  // --- Database persistence -------------------------------------------------

  /// Model year, taken from the nested [vehicle] block when present.
  int? get year => vehicle?.year;

  /// Human-readable "year make model" label, falling back to the raw [vin]
  /// when no identity fields are available.
  String get title {
    final label = [year, make, model]
        .where((v) => v != null && '$v'.isNotEmpty)
        .join(' ');
    return label.isEmpty ? vin : label;
  }

  Map<String, dynamic> toDbMap() => {
        'vin': vin,
        'year': year,
        'make': make,
        'model': model,
        'data': jsonEncode(toJson()),
      };

  factory VehicleInfo.fromDbMap(Map<String, dynamic> row) {
    return VehicleInfo.fromJson(
      jsonDecode(row['data'] as String) as Map<String, dynamic>,
    );
  }
}

/// Normalized identity block: `json['vehicle']`.
@immutable
class Vehicle {
  const Vehicle({
    required this.vin,
    this.year,
    this.make,
    this.model,
    this.manufacturer,
  });

  final String vin;
  final int? year;
  final String? make;
  final String? model;
  final String? manufacturer;

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
        vin: (json['vin'] ?? '') as String,
        year: _asInt(json['year']),
        make: json['make'] as String?,
        model: json['model'] as String?,
        manufacturer: json['manufacturer'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'vin': vin,
        'year': year,
        'make': make,
        'model': model,
        'manufacturer': manufacturer,
      };
}

// --- Parsing helpers --------------------------------------------------------

Map<String, dynamic> _asMap(dynamic value) =>
    value is Map ? Map<String, dynamic>.from(value) : const {};

int? _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}
