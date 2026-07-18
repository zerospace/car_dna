import 'package:flutter/material.dart';

class EnterVinViewModel extends ChangeNotifier {
  EnterVinViewModel({String? initialVin}) : controller = TextEditingController(text: sanitize(initialVin ?? '')) {
    controller.addListener(notifyListeners);
  }

  String get vin => controller.text;
  int get length => vin.length;
  bool get isComplete => length == vinLength;

  bool _isDecoding = false;
  bool get isDecoding => _isDecoding;

  static const vinLength = 17;

  // Letters I, O, Q are never used in a VIN.
  static final allowedChar = RegExp(r'[A-HJ-NPR-Z0-9]');

  final TextEditingController controller;

  static String sanitize(String raw) => raw
      .toUpperCase()
      .split('')
      .where(allowedChar.hasMatch)
      .take(vinLength)
      .join();

  Future<void> decode() async {
    if (!isComplete || _isDecoding) return;
    _isDecoding = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _isDecoding = false;
    notifyListeners();
  }

  void cancel() {
    //
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}