import 'package:car_dna/theme/app_colors.dart';
import 'package:car_dna/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class HistorySearchBar extends StatelessWidget {
  const HistorySearchBar({
    super.key,
    required this.controller,
    this.placeholder = 'Search by VIN or vehicle',
    this.showClear = false,
    this.onClear
  });

  final TextEditingController controller;
  final String placeholder;
  final bool showClear;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textInputAction: TextInputAction.search,
      textCapitalization: TextCapitalization.characters,
      cursorColor: AppColors.primary,
      style: AppTypography.textTheme.bodyLarge?.copyWith(color: AppColors.neutral50),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: AppColors.surface,
        hintText: placeholder,
        hintStyle: AppTypography.textTheme.bodyLarge?.copyWith(color: AppColors.textFaint),
        prefixIcon: const Icon(Symbols.search, size: 20, color: AppColors.textMuted),
        prefixIconConstraints: const BoxConstraints(minWidth: 46, minHeight: 46),
        suffixIcon: showClear
          ? IconButton(
              icon: const Icon(Symbols.close, size: 20, color: AppColors.textMuted,),
              onPressed: onClear,
            )
          : null,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: _border(AppColors.border),
        enabledBorder: _border(AppColors.border),
        focusedBorder: _border(AppColors.primary)
      ),
    );
  }

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: BorderSide(color: color)
  );
}