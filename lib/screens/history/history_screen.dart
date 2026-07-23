import 'package:car_dna/screens/history/history_viewmodel.dart';
import 'package:car_dna/screens/history/widgets/history_item.dart';
import 'package:car_dna/screens/history/widgets/history_search_bar.dart';
import 'package:car_dna/theme/app_colors.dart';
import 'package:car_dna/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _viewModel = HistoryViewmodel();

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
        leading: Padding(
          padding: const EdgeInsetsGeometry.only(left: 20),
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
        title: Text('Recent searches', style: AppTypography.textTheme.titleMedium,),
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsetsGeometry.fromLTRB(22, 8, 22, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListenableBuilder(
                listenable: _viewModel,
                  builder: (context, _) => HistorySearchBar(
                    controller: _viewModel.searchController,
                    showClear: _viewModel.hasQuery,
                    onClear: _viewModel.clearQuery,
                  ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListenableBuilder(
                  listenable: _viewModel,
                  builder: (context, _) => _body(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _body() {
    if (_viewModel.isLoading) {
      return const Center(
        child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator()),
      );
    }

    final results = _viewModel.results;
    if (results.isEmpty) {
      return Center(
        child: Text(
          _viewModel.hasQuery
              ? 'No matches for "${_viewModel.query}"'
              : 'No recent searches yet',
          textAlign: TextAlign.center,
          style: AppTypography.textTheme.bodyMedium?.copyWith(color: AppColors.textFaint),
        ),
      );
    }

    return ListView.separated(
      clipBehavior: Clip.hardEdge,
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 28),
      itemCount: results.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final info = results[index];
        return HistoryItem(
          vehicle: info,
          onTap: () {
            // TODO: open vehicle details
          },
        );
      },
    );
  }
}