import 'package:car_dna/models/vehicle_info.dart';
import 'package:car_dna/screens/vehicle/widgets/detail_section.dart';
import 'package:car_dna/screens/vehicle/widgets/vehicle_chip.dart';
import 'package:car_dna/screens/vehicle/widgets/vehicle_spec_grid.dart';
import 'package:car_dna/screens/vehicle/widgets/vin_display_card.dart';
import 'package:car_dna/theme/app_colors.dart';
import 'package:car_dna/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class VehicleDetailsScreen extends StatelessWidget {
  const VehicleDetailsScreen({super.key, required this.vehicle});

  final VehicleInfo vehicle;

  static const _hPad = EdgeInsets.symmetric(horizontal: 22);

  List<VehicleChip> _chips() {
    final List<String> tags = [?vehicle.trim, ?vehicle.body, ?vehicle.type];
    return tags.map((label) => VehicleChip(label: label)).toList();
  }

  List<(String, String)> _specs() => [
    if (vehicle.engine case final v?) ('Engine', v),
    if (vehicle.transmission case final v?) ('Transmission', v),
    if (vehicle.drive case final v?) ('Drivetrain', v),
    if (vehicle.style case final v?) ('Style', v),
    if (vehicle.vehicle?.manufacturer case final v?) ('Manufacturer', v),
    if (vehicle.origin case final v?) ('Origin', v),
  ];

  List<(String, String)> _breakdown() => [
    if (vehicle.wmi case final v?) ('WMI', v),
    if (vehicle.squishVin case final v?) ('Squish VIN', v),
    if (vehicle.checkDigit case final v?) ('Check digit', v),
    if (vehicle.checksum case final b?) ('Checksum', b ? 'Valid' : 'Invalid'),
    if (vehicle.vinValid case final b?) ('VIN valid', b ? 'Yes' : 'No'),
    if (vehicle.ambiguous case final b?) ('Ambiguous match', b ? 'Yes' : 'No'),
  ];

  @override
  Widget build(BuildContext context) {
    final name = [?vehicle.make, ?vehicle.model]
        .whereType<String>()
        .join(' ');
    final displayName = name.isEmpty ? vehicle.vin : name;

    final chips = _chips();
    final specs = _specs();
    final breakdown = _breakdown();

    // Extend the scroll to the physical bottom edge, but pad the content past
    // the Android nav bar / iOS home indicator so the last card stays clear.
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.surfaceBadge,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(
                Symbols.arrow_back,
                size: 22,
                color: AppColors.neutral50,
                weight: 500,
              ),
            ),
          ),
        ),
        title: Text('Vehicle details', style: AppTypography.textTheme.titleMedium),
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: 8, bottom: 28 + bottomInset),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: _hPad,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (vehicle.year != null) ...[
                      Text('${vehicle.year}', style: AppTypography.vehicleYear),
                      const SizedBox(height: 4),
                    ],
                    Text(displayName, style: AppTypography.vehicleTitle),
                  ],
                ),
              ),
              if (chips.isNotEmpty) ...[
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: _hPad,
                  child: Row(
                    children: [
                      for (var i = 0; i < chips.length; i++) ...[
                        if (i > 0) const SizedBox(width: 8),
                        chips[i],
                      ],
                    ],
                  ),
                ),
              ],
              Padding(
                padding: _hPad,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    VinDisplayCard(vin: vehicle.vin),
                    if (specs.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      VehicleSpecGrid(specs: specs),
                    ],
                    if (breakdown.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      DetailSection(title: 'VIN breakdown', rows: breakdown),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
