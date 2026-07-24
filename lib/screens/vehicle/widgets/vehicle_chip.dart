import 'package:car_dna/theme/app_colors.dart';
import 'package:car_dna/theme/app_typography.dart';
import 'package:flutter/material.dart';

class VehicleChip extends StatelessWidget {
  const VehicleChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Text(
        label,
        style: AppTypography.chipLabel.copyWith(
          color: AppColors.neutral300,
        ),
      ),
    );
  }
}
