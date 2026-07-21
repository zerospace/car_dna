import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../models/vehicle_info.dart';
import '../../services/vehicle_database.dart';
import '../../services/vehicle_info_service.dart';

class EnterVinViewModel extends ChangeNotifier {
  EnterVinViewModel({
    String? initialVin,
    required VehicleInfoService service,
    required VehicleDatabase database,
  })  : controller = TextEditingController(text: sanitize(initialVin ?? '')),
        _service = service,
        _database = database {
    controller.addListener(_onVinChanged);
  }

  String get vin => controller.text;
  int get length => vin.length;
  bool get isComplete => length == vinLength;

  bool _isDecoding = false;
  bool get isDecoding => _isDecoding;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _disposed = false;

  static const vinLength = 17;

  // Letters I, O, Q are never used in a VIN.
  static final allowedChar = RegExp(r'[A-HJ-NPR-Z0-9]');

  final TextEditingController controller;
  final VehicleInfoService _service;
  final VehicleDatabase _database;

  static String sanitize(String raw) => raw
      .toUpperCase()
      .split('')
      .where(allowedChar.hasMatch)
      .take(vinLength)
      .join();

  void _onVinChanged() {
    // Editing the VIN clears any stale error before notifying listeners.
    if (_errorMessage != null) _errorMessage = null;
    notifyListeners();
  }

  Future<void> decode() async {
    if (!isComplete || _isDecoding) return;
    _isDecoding = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final info = await _decodeVin(vin);
      if (_disposed) return; // Screen left mid-request — drop the result.
      _printVehicleInfo(info);
    } on VehicleInfoException catch (e) {
      if (_disposed) return; // Request was aborted by dispose(); ignore.
      _errorMessage = e.message;
    } catch (e) {
      if (_disposed) return;
      _errorMessage = 'Something went wrong. Please try again.';
      debugPrint('Unexpected decode error: $e');
    } finally {
      if (!_disposed) {
        _isDecoding = false;
        notifyListeners();
      }
    }
  }

  Future<VehicleInfo> _decodeVin(String vin) async {
    final cached = await _database.findByVin(vin);
    if (cached != null) return cached;

    final info = await _service.fetchByVin(vin);
    await _database.save(info);
    return info;
  }

  void _printVehicleInfo(VehicleInfo info) {
    const encoder = JsonEncoder.withIndent('  ');
    debugPrint('Decoded VehicleInfo for ${info.vin}:');
    debugPrint(encoder.convert(info.toJson()));
  }

  void cancel() {
    _disposed = true;
    _service.dispose();
  }

  @override
  void dispose() {
    _disposed = true;
    controller.removeListener(_onVinChanged);
    controller.dispose();
    // The database is shared app-wide, so it is intentionally left open.
    _service.dispose();
    super.dispose();
  }
}
