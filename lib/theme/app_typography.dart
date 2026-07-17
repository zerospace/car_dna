import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Typography extracted from the CarDNA Figma design.
///
/// Two families are used throughout the product:
/// - Plus Jakarta Sans — all UI copy (headings, body, labels).
/// - JetBrains Mono — VIN codes and other fixed-width data, so
///   characters line up (e.g. the 17-digit VIN entry keypad).
abstract final class AppTypography {
  static TextStyle _jakarta({
    required double fontSize,
    required FontWeight fontWeight,
    double letterSpacing = 0,
    Color color = AppColors.textPrimary,
    double? height,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      color: color,
      height: height,
    );
  }

  static TextStyle _mono({
    required double fontSize,
    required FontWeight fontWeight,
    double letterSpacing = 0,
    Color color = AppColors.textPrimary,
  }) {
    return GoogleFonts.jetBrainsMono(
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      color: color,
    );
  }

  /// Material [TextTheme] built from Plus Jakarta Sans, matching the
  /// weights/sizes/tracking found in the design (e.g. "Heading 1" =
  /// ExtraBold 28/-0.5, "Heading 2" = Bold 22/-0.3).
  static TextTheme get textTheme {
    return TextTheme(
      displayLarge: _jakarta(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
      ),
      // "Decode any vehicle in seconds." — Heading 1
      headlineLarge: _jakarta(
        fontSize: 30,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
        height: 1.12, // Figma: 33.6px line-height on 30px type
      ),
      // "Honda Accord" vehicle title — Heading 2
      headlineMedium: _jakarta(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
      headlineSmall: _jakarta(fontSize: 20, fontWeight: FontWeight.w700),
      // "Scan VIN", "Enter VIN" app bar / card titles
      titleLarge: _jakarta(fontSize: 18, fontWeight: FontWeight.w600),
      titleMedium: _jakarta(fontSize: 16, fontWeight: FontWeight.w600),
      // "2020 Honda Accord" list row titles, "Features & options"
      titleSmall: _jakarta(fontSize: 15, fontWeight: FontWeight.w600),
      bodyLarge: _jakarta(fontSize: 15, fontWeight: FontWeight.w400),
      // "Scan or enter a VIN to instantly pull specs..."
      bodyMedium: _jakarta(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      ),
      bodySmall: _jakarta(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      ),
      // Buttons, e.g. "Decode VIN"
      labelLarge: _jakarta(fontSize: 15, fontWeight: FontWeight.w700),
      // Uppercase eyebrow/badge labels, e.g. "SCAN", "DECODED"
      labelMedium: _jakarta(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
      ),
      // Timestamps, helper hints, e.g. "Just now", "2h ago"
      labelSmall: _jakarta(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: AppColors.textMuted,
      ),
    );
  }

  // Monospace styles for VIN / code display -----------------------------

  /// Full VIN readout, e.g. "1HGCV1F34LA802145" shown as flowing text.
  static TextStyle get vinReadout =>
      _mono(fontSize: 13, fontWeight: FontWeight.w500);

  /// A single character cell in the manual VIN-entry keypad.
  static TextStyle get vinDigit =>
      _mono(fontSize: 16, fontWeight: FontWeight.w700);

  /// Small mono caption, e.g. status clock or "// LIVE CAMERA FEED".
  static TextStyle get monoCaption => _mono(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
  );

  static TextStyle get logo =>
      _jakarta(fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: -0.3, color: AppColors.textPrimary);

  static TextStyle get monoEyebrowAccent => _mono(
      fontSize: 11,
      fontWeight: FontWeight.w400,
      letterSpacing: 1.5,
      color: AppColors.primary
  );
}
