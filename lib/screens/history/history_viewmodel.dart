import 'package:car_dna/models/vehicle_info.dart';
import 'package:car_dna/services/vehicle_database.dart';
import 'package:flutter/material.dart';

class HistoryViewmodel extends ChangeNotifier {
  HistoryViewmodel({VehicleDatabase? db}) : _db = db ?? VehicleDatabase.instance {
    searchController.addListener(_onQueryChanged);
    _load();
  }

  final VehicleDatabase _db;
  final TextEditingController searchController = TextEditingController();

  List<VehicleInfo> _all = [];
  List<VehicleInfo> _results = [];
  List<VehicleInfo> get results => _results;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String get query => searchController.text.trim();
  bool get hasQuery => query.isNotEmpty;

  Future<void> refresh() => _load();

  Future<void> _load() async {
    _isLoading = true;
    notifyListeners();

    _all = await _db.recentSearches();
    _applyFilter();

    _isLoading = false;
    notifyListeners();
  }

  void _onQueryChanged() {
    _applyFilter();
    notifyListeners();
  }

  void _applyFilter() {
    final q = query.toLowerCase();
    if (q.isEmpty) {
      _results = _all;
      return;
    }
    _results = _all.where((search) {
      final fields = [search.vin, search.title, search.make, search.model, search.trim];
      return fields.any((f) => f != null && f.toLowerCase().contains(q));
    }).toList();
  }

  void clearQuery() => searchController.clear();

  @override
  void dispose() {
    searchController.removeListener(_onQueryChanged);
    searchController.dispose();
    super.dispose();
  }
}