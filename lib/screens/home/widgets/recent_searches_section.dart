import 'package:car_dna/models/vehicle_info.dart';
import 'package:car_dna/screens/home/widgets/recent_search_tile.dart';
import 'package:car_dna/theme/app_colors.dart';
import 'package:car_dna/theme/app_typography.dart';
import 'package:flutter/material.dart';

class RecentSearchesSection extends StatelessWidget {
  const RecentSearchesSection({
    super.key,
    required this.recentSearches,
    required this.isLoading,
    required this.onSeeAll,
    required this.onTapItem,
  });

  final List<VehicleInfo> recentSearches;
  final bool isLoading;
  final VoidCallback onSeeAll;
  final ValueChanged<VehicleInfo> onTapItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'RECENT',
              style: AppTypography.textTheme.labelMedium?.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: AppColors.textMuted,
              ),
            ),
            if (recentSearches.isNotEmpty)
              Material(
                type: MaterialType.transparency,
                clipBehavior: Clip.antiAlias,
                shape: const StadiumBorder(),
                child: InkWell(
                  onTap: onSeeAll,
                  customBorder: const StadiumBorder(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    child: Text(
                      'See all',
                      style: AppTypography.textTheme.bodyMedium?.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 17),
        Expanded(child: _buildBody()),
      ],
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    if (recentSearches.isEmpty) {
      return Center(
        child: Text(
          'No recent searches yet',
          style: AppTypography.textTheme.bodyMedium?.copyWith(
            color: AppColors.textFaint,
          ),
        ),
      );
    }

    return ListView.separated(
      clipBehavior: Clip.hardEdge,
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: recentSearches.length,
      separatorBuilder: (context, index) => const SizedBox(height: 9),
      itemBuilder: (context, index) {
        final recentSearch = recentSearches[index];
        return RecentSearchTile(
          vehicle: recentSearch,
          onTap: () => onTapItem(recentSearch),
        );
      },
    );
  }
}
