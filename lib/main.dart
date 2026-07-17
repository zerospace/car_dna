import 'package:car_dna/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'theme/app_theme.dart';

void main() {
  runApp(const CarDNA());
}

class CarDNA extends StatelessWidget {
  const CarDNA({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CarDNA',
      theme: AppTheme.dark,
      home: const HomeScreen(),
    );
  }
}
