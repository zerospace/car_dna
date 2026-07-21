import 'package:car_dna/screens/enter_vin/enter_vin_screen.dart';
import 'package:car_dna/screens/home/home_viewmodel.dart';
import 'package:car_dna/screens/home/widgets/enter_vin_manually_button.dart';
import 'package:car_dna/screens/home/widgets/recent_searches_section.dart';
import 'package:car_dna/screens/home/widgets/scan_vin_button.dart';
import 'package:car_dna/theme/app_colors.dart';
import 'package:car_dna/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _viewModel = HomeViewModel();

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          children: [
            Icon(Symbols.genetics, size: 32, color: AppColors.primary,),
            Text('CarDNA', style: AppTypography.logo)
          ],
        ),
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsetsGeometry.symmetric(horizontal: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24,),
              Text(
                'Decode any vehicle in seconds.',
                style: AppTypography.textTheme.headlineLarge?.copyWith(
                  color: AppColors.neutral50,
                ),
              ),
              Text('Scan or enter a VIN to instantly pull specs, trim, and factory features.', style: AppTypography.textTheme.bodyLarge?.copyWith(
                color: AppColors.textMuted
              )),
              const SizedBox(height: 24,),
              ScanVinButton(
                onTap: () {
                  // open scan view
                },
              ),
              const SizedBox(height: 12),
              EnterVinManuallyButton(
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const EnterVinScreen(initialVin: 'LJCPCBLCX11000237'))
                  );
                  await _viewModel.refresh();
                },
              ),
              const SizedBox(height: 34),
              Expanded(
                child: ListenableBuilder(
                  listenable: _viewModel,
                  builder: (context, _) {
                    return RecentSearchesSection(
                      recentSearches: _viewModel.recentSearches,
                      isLoading: _viewModel.isLoadingRecentSearches,
                      onSeeAll: () {
                        // TODO: open full recent searches history
                      },
                      onTapItem: (recentSearch) {
                        // TODO: open vehicle details
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}