import 'package:car_dna/models/recent_search.dart';
import 'package:car_dna/theme/app_colors.dart';
import 'package:car_dna/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class RecentSearchTile extends StatelessWidget {
  const RecentSearchTile({
    super.key,
    required this.recentSearch,
    required this.onTap,
  });

  final RecentSearch recentSearch;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Material(
        type: MaterialType.transparency,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(13),
            child: Row(
              spacing: 13,
              children: [
                Container(
                  width: 52,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Symbols.directions_car,
                    size: 24,
                    color: AppColors.neutral800,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recentSearch.title,
                        style: AppTypography.textTheme.titleSmall?.copyWith(
                          color: AppColors.neutral50,
                        ),
                      ),
                      Text(
                        recentSearch.vin,
                        style: AppTypography.monoCaption.copyWith(
                          color: AppColors.textFaint,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Symbols.chevron_right,
                  size: 20,
                  color: AppColors.neutral800,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
