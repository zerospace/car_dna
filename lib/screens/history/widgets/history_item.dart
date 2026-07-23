import 'package:car_dna/models/vehicle_info.dart';
import 'package:car_dna/theme/app_colors.dart';
import 'package:car_dna/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:car_dna/utils/relative_time.dart';

class HistoryItem extends StatelessWidget {
  const HistoryItem({super.key, required this.vehicle, required this.onTap});

  final VehicleInfo vehicle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.vinCellEmpty,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider)
      ),
      child: Material(
        type: MaterialType.transparency,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              spacing: 14,
              children: [
                _thumbnail(),
                Expanded(child: _details()),
                _trailing()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _thumbnail() {
    return Container(
      width: 58,
      height: 46,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(11),
          gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.iconTileGradientStart, AppColors.iconTileGradientEnd]
          )
      ),
      child: const Icon(
        Symbols.directions_car,
        size: 26,
        color: AppColors.neutral800,
      ),
    );
  }

  Widget _details() {
    final trim = vehicle.trim;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          vehicle.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.textTheme.titleSmall?.copyWith(color: AppColors.neutral50),
        ),
        if (trim != null && trim.isNotEmpty)
          Text(
            trim,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
          ),
        const SizedBox(height: 4),
        Text(
          vehicle.vin,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.monoCaption.copyWith(color: AppColors.neutral800),
        )
      ],
    );
  }

  Widget _trailing() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          formatRelativeTime(vehicle.searchedAt),
          style: AppTypography.textTheme.labelSmall?.copyWith(color: AppColors.textFaint),
        ),
        const SizedBox(height: 8),
        const Icon(
          Symbols.chevron_right,
          size: 20,
          color: AppColors.neutral800,
        ),
        const SizedBox(height: 4)
      ],
    );
  }
}