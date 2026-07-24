import 'package:car_dna/screens/enter_vin/widgets/decode_vin_button.dart';
import 'package:car_dna/screens/vehicle/vehicle_details_screen.dart';

import 'enter_vin_viewmodel.dart';
// import 'widgets/decode_vin_button.dart';
import 'widgets/vin_input_grid.dart';
import 'package:car_dna/config/api_config.dart';
import 'package:car_dna/services/vehicle_database.dart';
import 'package:car_dna/services/vehicle_info_service.dart';
import 'package:car_dna/theme/app_colors.dart';
import 'package:car_dna/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class EnterVinScreen extends StatefulWidget {
  const EnterVinScreen({super.key, this.initialVin});

  final String? initialVin;

  @override
  State<StatefulWidget> createState() => _EnterVinScreenState();
}

class _EnterVinScreenState extends State<EnterVinScreen> {
  late final _viewModel = EnterVinViewModel(
    initialVin: widget.initialVin,
    service: VehicleInfoService(apiKey: ApiConfig.autoDevApiKey),
    database: VehicleDatabase.instance,
  );

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.surfaceElevated,
          content: Row(
            children: [
              const Icon(Symbols.error, size: 20, color: AppColors.error),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: AppTypography.helperBody.copyWith(color: AppColors.neutral50),
                ),
              ),
            ],
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) _viewModel.cancel();
      },
      child: Scaffold(
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
                    border: Border.all(color: AppColors.border)
                ),
                child: const Icon(Symbols.arrow_back, size: 22, color: AppColors.neutral50, weight: 500,),
              ),
            ),
          ),
          title: Text('Enter VIN', style: AppTypography.textTheme.titleMedium,),
        ),
        body: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 14, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Type the 17-character VIN', style: AppTypography.textTheme.headlineMedium?.copyWith(color: AppColors.neutral50)),
                const SizedBox(height: 6),
                Text('Found on the driver\'s-side door jamb, dashboard, or your registration.', style: AppTypography.helperBody),
                const SizedBox(height: 20),
                VinInputGrid(controller: _viewModel.controller),
                const SizedBox(height: 8),
                ListenableBuilder(
                  listenable: _viewModel,
                  builder: (context, _) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Letters I, O, Q aren't used in a VIN", style: AppTypography.helperCaption),
                      Text('${_viewModel.length}/${EnterVinViewModel.vinLength}', style: AppTypography.monoCounter)
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ListenableBuilder(
                  listenable: _viewModel,
                  builder: (context, _) => DecodeVinButton(
                    enabled: _viewModel.isComplete && !_viewModel.isDecoding,
                    isLoading: _viewModel.isDecoding,
                    onTap: () async {
                      await _viewModel.decode();
                      if (!context.mounted) return;
                      final error = _viewModel.errorMessage;
                      final result = _viewModel.result;
                      if (error != null) {
                        _showError(context, error);
                      } else if (result != null) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => VehicleDetailsScreen(vehicle: result),
                          ),
                        );
                      }
                    },
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