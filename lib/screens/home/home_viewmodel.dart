import 'package:car_dna/models/vehicle_info.dart';
import 'package:car_dna/services/vehicle_database.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({VehicleDatabase? database})
      : _database = database ?? VehicleDatabase.instance {
    _loadRecentSearches();
  }

  static const _recentSearchesLimit = 3;

  final VehicleDatabase _database;

  List<VehicleInfo> _recentSearches = [];
  List<VehicleInfo> get recentSearches => _recentSearches;

  bool _isLoadingRecentSearches = false;
  bool get isLoadingRecentSearches => _isLoadingRecentSearches;

  /// Reloads the recent searches list, e.g. after returning from a decode.
  Future<void> refresh() => _loadRecentSearches();

  Future<void> _loadRecentSearches() async {
    _isLoadingRecentSearches = true;
    notifyListeners();

    _recentSearches =
        await _database.recentSearches(limit: _recentSearchesLimit);

    _isLoadingRecentSearches = false;
    notifyListeners();
  }
}
