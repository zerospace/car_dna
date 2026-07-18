import 'package:car_dna/theme/app_colors.dart';
import 'package:car_dna/theme/app_typography.dart';
import 'package:flutter/material.dart';

class DecodeVinButton extends StatelessWidget {
  const DecodeVinButton({super.key, required this.enabled, required this.isLoading, required this.onTap});

  final bool enabled;
  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: enabled ? onTap : null,
        child: Ink(
          decoration: BoxDecoration(
            color: enabled ? AppColors.primary : AppColors.surfaceDisabled,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: enabled ? AppColors.primary : AppColors.divider)
          ),
          child: Container(
            height: 56,
            alignment: Alignment.center,
            child: isLoading
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.textPrimary))
              : Text('Decode VIN', style: AppTypography.textTheme.labelLarge?.copyWith(color: enabled ? AppColors.textPrimary : AppColors.neutral800))  
          ),
        ),
      ),
    );
  }
}