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

  // Vehicle details screen ----------------------------------------------

  /// Vehicle name headline, e.g. "Honda Accord". (ExtraBold 28/-0.5)
  static TextStyle get vehicleTitle => _jakarta(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
    height: 1.1,
    color: AppColors.neutral50,
  );

  /// Model-year eyebrow above the vehicle name, e.g. "2020". (Mono 14)
  static TextStyle get vehicleYear =>
      _mono(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textMuted);

  /// Identity pill label, e.g. "EX-L", "Sedan". (SemiBold 13)
  static TextStyle get chipLabel =>
      _jakarta(fontSize: 13, fontWeight: FontWeight.w600);

  /// Uppercase spec-card label, e.g. "ENGINE". (Bold 11/0.5)
  static TextStyle get specLabel => _jakarta(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
    color: AppColors.textFaint,
  );

  /// Spec-card value, e.g. "1.5L Turbo I4". (Bold 15.5/-0.2)
  static TextStyle get specValue => _jakarta(
    fontSize: 15.5,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
    color: AppColors.neutral50,
  );

  /// Collapsible section header, e.g. "Features & options". (Bold 15)
  static TextStyle get sectionTitle =>
      _jakarta(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.neutral50);

  /// "VIN" caption on the VIN readout card. (Mono 9/1)
  static TextStyle get vinLabel => _mono(
    fontSize: 9,
    fontWeight: FontWeight.w400,
    letterSpacing: 1,
    color: AppColors.textFaint,
  );

  /// The VIN value on the readout card. (Mono 13/0.5)
  static TextStyle get vinValue => _mono(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    color: AppColors.neutral200,
  );

  /// Left-hand label in a detail-section row. (Regular 14, muted)
  static TextStyle get detailLabel =>
      _jakarta(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textMuted);

  /// Right-hand value in a detail-section row. (Medium 14)
  static TextStyle get detailValue =>
      _jakarta(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.neutral100);

  static TextStyle get monoEyebrowAccent => _mono(
      fontSize: 11,
      fontWeight: FontWeight.w400,
      letterSpacing: 1.5,
      color: AppColors.primary
  );

  /// Screen subtitle paragraph, e.g. the VIN "Found on the driver's-side…"
  /// helper copy. (14 / Regular, 21px line-height, muted grey.)
  static TextStyle get helperBody => _jakarta(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textMuted,
  );

  /// Small helper caption below an input, e.g. "Letters I, O, Q aren't
  /// used in a VIN".
  static TextStyle get helperCaption => _jakarta(
    fontSize: 12.5,
    fontWeight: FontWeight.w400,
    color: AppColors.textFaint,
  );

  /// Mono field counter, e.g. "8/17".
  static TextStyle get monoCounter => _mono(
    fontSize: 12.5,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
  );
}
