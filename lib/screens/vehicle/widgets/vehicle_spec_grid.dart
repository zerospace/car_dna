import 'package:car_dna/theme/app_colors.dart';
import 'package:car_dna/theme/app_typography.dart';
import 'package:flutter/material.dart';

class SpecCard extends StatelessWidget {
  const SpecCard({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.borderFaint),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: AppTypography.specLabel),
          const SizedBox(height: 7),
          Text(value, style: AppTypography.specValue),
        ],
      ),
    );
  }
}

class VehicleSpecGrid extends StatelessWidget {
  const VehicleSpecGrid({super.key, required this.specs});

  final List<(String, String)> specs;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < specs.length; i += 2) {
      final left = specs[i];
      final right = i + 1 < specs.length ? specs[i + 1] : null;
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: SpecCard(label: left.$1, value: left.$2)),
              const SizedBox(width: 10),
              Expanded(
                child: right == null
                    ? const SizedBox.shrink()
                    : SpecCard(label: right.$1, value: right.$2),
              ),
            ],
          ),
        ),
      );
      if (i + 2 < specs.length) rows.add(const SizedBox(height: 10));
    }
    return Column(children: rows);
  }
}
