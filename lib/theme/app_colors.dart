import 'package:flutter/material.dart';

/// Color palette extracted from the CarDNA Figma design.
///
/// The product is dark-themed by default: near-black surfaces with a
/// blue accent, a green "confirmed/decoded" accent, and white text at
/// varying opacities for hierarchy.
abstract final class AppColors {
  // Brand / accent -----------------------------------------------------
  static const primary = Color(0xFF4D8DFF); // Dodger Blue
  static const primaryLight = Color(0xFF9BC0FF); // Anakiwa
  static const primaryDark = Color(0xFF2B5FD0);

  /// Translucent primary, used for chip/badge backgrounds such as the
  /// "SCAN" button and selected filter chips (EX-L, Sedan, Gasoline).
  static const primaryContainer = Color(0x474D8DFF); // primary @ 28%
  static const primarySubtleContainer = Color(0x244D8DFF); // primary @ 14%

  // Success / confirmation ---------------------------------------------
  static const success = Color(0xFF34D399); // Shamrock
  static const successContainer = Color(0x2634D399); // success @ 15%

  // Surfaces (dark) ------------------------------------------------------
  /// Outermost app background.
  static const background = Color(0xFF0A0A0B); // Woodsmoke

  /// Default card / panel surface (e.g. "Enter VIN manually" row,
  /// feature list panel).
  static const surface = Color(0xFF141417);

  /// Slightly raised surface used for list rows and secondary panels
  /// (recent vehicle rows, history rows).
  static const surfaceElevated = Color(0xFF1A1A1F); // Shark

  /// Recessed / inset surface, e.g. camera viewfinder background.
  static const surfaceSunken = Color(0xFF0C0C0E);

  // Borders & dividers ---------------------------------------------------
  static const border = Color(0x14FFFFFF); // white @ 8%
  static const divider = Color(0x0FFFFFFF); // white @ 6%
  static const borderSubtle = Color(0x0DFFFFFF); // white @ 5%

  // Text on dark surfaces --------------------------------------------------
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0x8CFFFFFF); // white @ 55%
  static const textTertiary = Color(0x59FFFFFF); // white @ 35%
  static const textDisabled = Color(0x47FFFFFF); // white @ 28%

  /// Neutral grey text for muted labels, timestamps, and helper copy
  /// where a flat grey reads better than translucent white.
  static const textMuted = Color(0xFF8C8C95); // Manatee
  static const textFaint = Color(0xFF6A6A72); // Mid Gray

  // Light-mode neutrals (kept for completeness / light surfaces) --------
  static const neutral50 = Color(0xFFF4F4F5); // Athens Gray
  static const neutral100 = Color(0xFFE4E4E7); // Iron
  static const neutral200 = Color(0xFFD4D4D8);
  static const neutral300 = Color(0xFFC8C8CF); // French Gray
  static const neutral700 = Color(0xFF3A3A40); // Tuna
  static const neutral800 = Color(0xFF5A5A62); // Scarpa Flow

  // Card gradient top-left stop (159.77deg gradient), used behind the
  // "Scan VIN" card.
  static const scanCardGradientStart = Color(0xFF1A2A4D); // azure/20
  static const scanCardGradientEnd = Color(0xFF121319); // blue/8

  // Glow shadow behind the camera icon badge on the "Scan VIN" card.
  static const scanIconGlow = Color(0x994D8DFF); // primary @ 60%
}
