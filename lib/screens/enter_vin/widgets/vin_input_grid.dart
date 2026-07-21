import '../enter_vin_viewmodel.dart';
import 'package:car_dna/theme/app_colors.dart';
import 'package:car_dna/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Forwards each raw edit to the grid's per-cell model. The real caret is kept
/// pinned to the end of the text (see [_VinInputGridState]), so a keystroke
/// always arrives as an append and a backspace as a trailing delete; [applyEdit]
/// interprets both relative to the active cell and returns the resulting text.
class _VinInputFormatter extends TextInputFormatter {
  _VinInputFormatter(this.applyEdit);

  final String Function(TextEditingValue oldValue, TextEditingValue newValue) applyEdit;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = applyEdit(oldValue, newValue);
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
  static const _length = EnterVinViewModel.vinLength;

  final _focus = FocusNode();

  late List<String?> _slots;
  int _active = 0;

  @override
  void initState() {
    super.initState();
    _slots = List<String?>.filled(_length, null);
    final initial = widget.controller.text;
    for (var i = 0; i < initial.length && i < _length; i++) {
      _slots[i] = initial[i];
    }
    _active = initial.length.clamp(0, _length);
    widget.controller.addListener(_onChanged);
    _focus.addListener(_onChanged);
  }

  String _joined() {
    final buffer = StringBuffer();
    for (final char in _slots) {
      if (char != null) buffer.write(char);
    }
    return buffer.toString();
  }

  void _onChanged() {
    final length = widget.controller.text.length;
    if (widget.controller.selection.baseOffset != length) {
      widget.controller.selection = TextSelection.collapsed(offset: length);
    }
    setState(() {});
  }

  String _applyEdit(TextEditingValue oldValue, TextEditingValue newValue) {
    final oldText = oldValue.text;
    final newText = newValue.text;

    if (newText.length > oldText.length && newText.startsWith(oldText)) {
      final added = EnterVinViewModel.sanitize(newText.substring(oldText.length));
      for (final char in added.split('')) {
        if (_active >= _length) break;
        _slots[_active] = char;
        _active++;
      }
    } else if (newText.length < oldText.length && oldText.startsWith(newText)) {
      _deleteActive();
    } else {
      final text = EnterVinViewModel.sanitize(newText);
      _slots = List<String?>.filled(_length, null);
      for (var i = 0; i < text.length; i++) {
        _slots[i] = text[i];
      }
      _active = text.length;
    }
    return _joined();
  }

  void _deleteActive() {
    if (_active < _length && _slots[_active] != null) {
      _slots[_active] = null;
      return;
    }
    var i = (_active < _length ? _active : _length) - 1;
    while (i >= 0 && _slots[i] == null) {
      i--;
    }
    if (i >= 0) {
      _slots[i] = null;
      _active = i;
    }
  }

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

  void _selectCell(int index) {
    if (!widget.enabled) return;
    _focus.requestFocus();
    setState(() => _active = index.clamp(0, _length - 1));
    widget.controller.selection = TextSelection.collapsed(offset: widget.controller.text.length);
  }

  @override
  Widget build(BuildContext context) {
    final activeIndex = _focus.hasFocus && _active >= 0 && _active < _length ? _active : null;

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
                inputFormatters: [_VinInputFormatter(_applyEdit)],
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),
          ),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 6,
            runSpacing: 6,
            children: [
              for (var i = 0; i < _length; i++)
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _selectCell(i),
                  child: _VinCell(
                    char: _slots[i],
                    isActive: i == activeIndex,
                  ),
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
        ? filled
            ? Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    char!,
                    style: AppTypography.vinDigit.copyWith(
                      color: AppColors.neutral50,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: _BlinkingCursor(),
                    ),
                  ),
                ],
              )
            : const _BlinkingCursor()
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
