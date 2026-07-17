import 'package:car_dna/theme/app_colors.dart';
import 'package:car_dna/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class EnterVinManuallyButton extends StatelessWidget {
  const EnterVinManuallyButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border)
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 23, vertical: 19),
            child: Row(
              spacing: 14,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(11)
                  ),
                  child: Icon(
                    Symbols.keyboard,
                    size: 22,
                    color: AppColors.neutral50,
                    weight: 500,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Enter VIN manually', style: AppTypography.textTheme.titleSmall?.copyWith(color: AppColors.neutral50)),
                      Text('Type the 17-character code', style: AppTypography.textTheme.bodyMedium?.copyWith(color: AppColors.textMuted))
                    ],
                  ),
                ),
                Icon(
                  Symbols.chevron_right,
                  size: 22,
                  color: AppColors.textFaint,
                  weight: 500,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}