import 'package:car_dna/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:car_dna/theme/app_typography.dart';
import 'package:material_symbols_icons/symbols.dart';

class ScanVinButton extends StatelessWidget {
  const ScanVinButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment(-1.5, 0),
              end: Alignment(1, 1),
              colors: [AppColors.scanCardGradientStart, AppColors.scanCardGradientEnd],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.primary)
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsetsGeometry.fromLTRB(25, 30, 25, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('SCAN', style: AppTypography.monoEyebrowAccent,),
                    const SizedBox(height: 56,),
                    Text('Scan VIN', style: AppTypography.textTheme.headlineMedium?.copyWith(
                      color: AppColors.neutral50
                    )),
                    Text(
                      'Point your camera at the barcode or plate',
                      style: AppTypography.textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textMuted
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                top: 24,
                right: 24,
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.scanIconGlow,
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                        spreadRadius: -6
                      )
                    ]
                  ),
                  child: Icon(
                    Symbols.photo_camera,
                    size: 28,
                    color: AppColors.background,
                    fill: 1,
                    weight: 500,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}