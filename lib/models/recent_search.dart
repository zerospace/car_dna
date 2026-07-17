import 'package:flutter/foundation.dart';

/// A previously decoded vehicle shown in the Home screen's "Recent" list.
@immutable
class RecentSearch {
  const RecentSearch({required this.vin, required this.title});

  final String vin;
  final String title;
}
