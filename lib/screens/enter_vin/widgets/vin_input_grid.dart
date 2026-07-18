import '../enter_vin_viewmodel.dart';
import 'package:car_dna/theme/app_colors.dart';
import 'package:car_dna/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class _VinInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = EnterVinViewModel.sanitize(newValue.text);
    return TextEditingValue(text: text, selection: TextSelection.collapsed(offset: text.length));
  }
}

class VinInputGrid extends StatefulWidget {
  const VinInputGrid({super.key, required this.controller, this.enabled = true});

  final TextEditingController controller;
  final bool enabled;

  @override
  State<StatefulWidget> createState() => _VinInputGridState();
}

class _VinInputGridState extends State<VinInputGrid> {
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChanged);
    _focus.addListener(_onChanged);
  }

  void _onChanged() => setState(() {});

  @override
  void didUpdateWidget(covariant VinInputGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.enabled && _focus.hasFocus) {
      _focus.unfocus();
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = widget.controller.text;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _focus.requestFocus,
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0,
              child: TextField(
                controller: widget.controller,
                focusNode: _focus,
                autofocus: true,
                showCursor: false,
                readOnly: !widget.enabled,
                enableInteractiveSelection: false,
                keyboardType: TextInputType.visiblePassword,
                textCapitalization: TextCapitalization.characters,
                inputFormatters: [_VinInputFormatter()],
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),
          ),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 6,
            runSpacing: 6,
            children: [
              for (var i = 0; i< EnterVinViewModel.vinLength; i++)
                _VinCell(
                  char: i < text.length ? text[i] : null,
                  isActive: i == text.length && _focus.hasFocus
                )
            ],
          )
        ],
      ),
    );
  }
}

class _VinCell extends StatelessWidget {
  const _VinCell({this.char, required this.isActive});

  final String? char;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final filled = char != null;
    final Color background = filled || isActive ? AppColors.vinCellFilled : AppColors.vinCellEmpty;
    final Color borderColor = isActive ? AppColors.primary : (filled ? AppColors.borderStrong : AppColors.borderFaint);

    return Container(
      width: 30,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor)
      ),
      child: isActive
        ? const _BlinkingCursor()
        : Text(
          char ?? '·',
          style: AppTypography.vinDigit.copyWith(
            color: filled ? AppColors.neutral50 : AppColors.neutral700,
            fontWeight: filled ? FontWeight.w700 : FontWeight.w400
          ),
        ),
    );
  }
}

class _BlinkingCursor extends StatefulWidget {
  const _BlinkingCursor();

  @override
  State<StatefulWidget> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<_BlinkingCursor> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600)
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: _controller,
    child: Container(width: 2, height: 18, color: AppColors.primary),
  );
}