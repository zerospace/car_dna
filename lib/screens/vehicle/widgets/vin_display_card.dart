import 'package:car_dna/theme/app_colors.dart';
import 'package:car_dna/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';

class VinDisplayCard extends StatelessWidget {
  const VinDisplayCard({super.key, required this.vin});

  final String vin;

  void _copy(BuildContext context) {
    Clipboard.setData(ClipboardData(text: vin));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.surfaceElevated,
          content: Row(
            children: [
              const Icon(Symbols.check_circle, size: 20, color: AppColors.success),
              const SizedBox(width: 10),
              Text(
                'VIN copied',
                style: AppTypography.helperBody.copyWith(color: AppColors.neutral50),
              ),
            ],
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
      decoration: BoxDecoration(
        color: AppColors.vinCellEmpty,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Text('VIN', style: AppTypography.vinLabel),
          const SizedBox(width: 10),
          Expanded(child: Text(vin, style: AppTypography.vinValue)),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => _copy(context),
            behavior: HitTestBehavior.opaque,
            child: const Icon(
              Symbols.content_copy,
              size: 18,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
