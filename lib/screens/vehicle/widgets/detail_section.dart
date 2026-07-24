import 'package:car_dna/theme/app_colors.dart';
import 'package:car_dna/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class DetailSection extends StatefulWidget {
  const DetailSection({
    super.key,
    required this.title,
    required this.rows,
    this.initiallyExpanded = false,
  });

  final String title;
  final List<(String, String)> rows;
  final bool initiallyExpanded;

  @override
  State<DetailSection> createState() => _DetailSectionState();
}

class _DetailSectionState extends State<DetailSection> {
  late bool _expanded = widget.initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.vinCellEmpty,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
              child: Row(
                children: [
                  Expanded(
                    child: Text(widget.title, style: AppTypography.sectionTitle),
                  ),
                  Icon(
                    _expanded ? Symbols.expand_less : Symbols.expand_more,
                    size: 22,
                    color: AppColors.textMuted,
                    weight: 500,
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 180),
            crossFadeState:
                _expanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            firstChild: Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 6),
              child: Column(
                children: [
                  for (final row in widget.rows)
                    _DetailRow(label: row.$1, value: row.$2),
                ],
              ),
            ),
            secondChild: const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.borderSubtle)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.detailLabel),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTypography.detailValue,
            ),
          ),
        ],
      ),
    );
  }
}
