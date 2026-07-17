import 'package:car_dna/models/recent_search.dart';
import 'package:flutter/material.dart';

const _mockRecentSearches = [
  RecentSearch(vin: '1HGCV1F34LA802145', title: '2020 Honda Accord'),
  RecentSearch(vin: '3TMCZ5AN8KM234517', title: '2019 Toyota Tacoma'),
  RecentSearch(vin: 'JM1GL1VM9J1318842', title: '2018 Mazda Mazda6'),
];

class HomeViewModel extends ChangeNotifier {
  HomeViewModel() {
    _loadRecentSearches();
  }

  List<RecentSearch> _recentSearches = [];
  List<RecentSearch> get recentSearches => _recentSearches;

  bool _isLoadingRecentSearches = false;
  bool get isLoadingRecentSearches => _isLoadingRecentSearches;

  Future<void> _loadRecentSearches() async {
    _isLoadingRecentSearches = true;
    notifyListeners();

    // TODO: replace with a real query once persistence is added.
    await Future.delayed(const Duration(milliseconds: 300));
    _recentSearches = _mockRecentSearches;

    _isLoadingRecentSearches = false;
    notifyListeners();
  }
}
