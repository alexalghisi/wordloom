import 'package:flutter/material.dart';

const Color wordloomPaper = Color(0xFFF6F1E7);
const Color wordloomInk = Color(0xFF1C1915);
const Color wordloomCard = Color(0xFFFFFCF7);
const Color wordloomRule = Color(0xFFD9D1C3);

ThemeData wordloomTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF8E2F2A),
    surface: wordloomPaper,
    onSurface: wordloomInk,
  );
  return ThemeData(
    colorScheme: scheme,
    scaffoldBackgroundColor: wordloomPaper,
    appBarTheme: const AppBarTheme(
      backgroundColor: wordloomPaper,
      foregroundColor: wordloomInk,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: wordloomPaper,
      indicatorColor: Color(0xFFE7D2CF),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: wordloomCard,
      labelStyle: const TextStyle(color: wordloomInk),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    ),
    dividerColor: wordloomRule,
  );
}
