import 'package:car_dna/screens/enter_vin/enter_vin_screen.dart';
import 'package:car_dna/theme/app_colors.dart';
import 'package:car_dna/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

enum _ScanMode { barcode, vinText }

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  _ScanMode _mode = _ScanMode.barcode;

  void _enterManually() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const EnterVinScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 18),
          child: _IconBadge(
            icon: Symbols.arrow_back,
            filled: true,
            onTap: () => Navigator.of(context).maybePop(),
          ),
        ),
        title: Text('Scan VIN', style: AppTypography.textTheme.titleSmall),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: _IconBadge(
              icon: Symbols.flashlight_on,
              onTap: () {
                // TODO: toggle the camera torch once the feed is wired up.
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: Stack(
              children: [
                const _CameraFeedPlaceholder(),
                const Positioned(
                  top: 18,
                  left: 0,
                  right: 0,
                  child: Center(child: _LiveFeedLabel()),
                ),
                const Align(
                  alignment: Alignment(0, -0.1),
                  child: _ViewfinderFrame(),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: _ScanControls(
                    mode: _mode,
                    onModeChanged: (mode) => setState(() => _mode = mode),
                    onEnterManually: _enterManually,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({required this.icon, required this.onTap, this.filled = false});

  final IconData icon;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: filled ? AppColors.surfaceBadge : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(icon, size: 22, color: AppColors.neutral50, weight: 500),
      ),
    );
  }
}

class _CameraFeedPlaceholder extends StatelessWidget {
  const _CameraFeedPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 0.9,
            colors: [Color(0xFF1C1D22), AppColors.surfaceSunken],
          ),
        ),
      ),
    );
  }
}

class _LiveFeedLabel extends StatelessWidget {
  const _LiveFeedLabel();

  @override
  Widget build(BuildContext context) {
    return Text(
      '// LIVE CAMERA FEED',
      style: AppTypography.monoCaption.copyWith(
        fontSize: 10.5,
        letterSpacing: 1,
        color: AppColors.neutral800,
      ),
    );
  }
}

class _ViewfinderFrame extends StatelessWidget {
  const _ViewfinderFrame();

  static const double _size = 262;
  static const double _corner = 34;
  static const double _stroke = 3;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _size,
      height: _size,
      child: Stack(
        children: const [
          Positioned(top: 0, left: 0, child: _Corner(top: true, left: true)),
          Positioned(top: 0, right: 0, child: _Corner(top: true, left: false)),
          Positioned(bottom: 0, left: 0, child: _Corner(top: false, left: true)),
          Positioned(bottom: 0, right: 0, child: _Corner(top: false, left: false)),
        ],
      ),
    );
  }
}

class _Corner extends StatelessWidget {
  const _Corner({required this.top, required this.left});

  final bool top;
  final bool left;

  @override
  Widget build(BuildContext context) {
    const side = BorderSide(color: AppColors.primary, width: _ViewfinderFrame._stroke);
    const radius = Radius.circular(8);
    return Container(
      width: _ViewfinderFrame._corner,
      height: _ViewfinderFrame._corner,
      decoration: BoxDecoration(
        border: Border(
          top: top ? side : BorderSide.none,
          bottom: top ? BorderSide.none : side,
          left: left ? side : BorderSide.none,
          right: left ? BorderSide.none : side,
        ),
        borderRadius: BorderRadius.only(
          topLeft: top && left ? radius : Radius.zero,
          topRight: top && !left ? radius : Radius.zero,
          bottomLeft: !top && left ? radius : Radius.zero,
          bottomRight: !top && !left ? radius : Radius.zero,
        ),
      ),
    );
  }
}

class _ScanControls extends StatelessWidget {
  const _ScanControls({
    required this.mode,
    required this.onModeChanged,
    required this.onEnterManually,
  });

  final _ScanMode mode;
  final ValueChanged<_ScanMode> onModeChanged;
  final VoidCallback onEnterManually;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x00080808), Color(0xE6080808)],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Center the VIN barcode in the frame',
            style: AppTypography.textTheme.bodySmall?.copyWith(
              fontSize: 13.5,
              color: AppColors.neutral300,
            ),
          ),
          const SizedBox(height: 16),
          _ModeToggle(mode: mode, onModeChanged: onModeChanged),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: onEnterManually,
            child: Text(
              'Enter manually instead',
              style: AppTypography.textTheme.titleSmall?.copyWith(
                fontSize: 13,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeToggle extends StatelessWidget {
  const _ModeToggle({required this.mode, required this.onModeChanged});

  final _ScanMode mode;
  final ValueChanged<_ScanMode> onModeChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0x12FFFFFF), // white @ 7%
        border: Border.all(color: const Color(0x17FFFFFF)), // white @ 9%
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ModeSegment(
            icon: Symbols.barcode,
            label: 'Barcode',
            selected: mode == _ScanMode.barcode,
            onTap: () => onModeChanged(_ScanMode.barcode),
          ),
          _ModeSegment(
            icon: Symbols.text_fields,
            label: 'VIN Text',
            selected: mode == _ScanMode.vinText,
            onTap: () => onModeChanged(_ScanMode.vinText),
          ),
        ],
      ),
    );
  }
}

class _ModeSegment extends StatelessWidget {
  const _ModeSegment({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? AppColors.background : AppColors.textMuted;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 7,
          children: [
            Icon(icon, size: 18, color: foreground, weight: 500),
            Text(
              label,
              style: AppTypography.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: foreground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
