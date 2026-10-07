import "package:flutter/material.dart";

abstract final class KingColors {
  static const ink = Color(0xFF29231D);
  static const burgundy = Color(0xFF751F2D);
  static const burgundyDark = Color(0xFF4B121D);
  static const gold = Color(0xFFBD8D3F);
  static const goldLight = Color(0xFFD9B970);
  static const paper = Color(0xFFF3EAD7);
  static const paperDeep = Color(0xFFE7D6B9);
  static const muted = Color(0xFF776854);
  static const green = Color(0xFF59633F);
}

abstract final class KingTheme {
  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: KingColors.burgundy,
      brightness: Brightness.light,
      surface: KingColors.paper,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: KingColors.paper,
      fontFamily: "serif",
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: KingColors.burgundyDark,
          fontSize: 76,
          height: 1,
          fontWeight: FontWeight.w700,
          letterSpacing: -4,
        ),
        headlineLarge: TextStyle(
          color: KingColors.ink,
          fontSize: 25,
          height: 1.45,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: TextStyle(
          color: KingColors.ink,
          fontSize: 20,
          height: 1.45,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: TextStyle(
          color: KingColors.ink,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        bodyMedium: TextStyle(
          color: KingColors.ink,
          fontFamily: "sans-serif",
          fontSize: 13,
          height: 1.65,
        ),
        bodySmall: TextStyle(
          color: KingColors.muted,
          fontFamily: "sans-serif",
          fontSize: 10,
          height: 1.55,
        ),
        labelLarge: TextStyle(
          fontFamily: "sans-serif",
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.35),
        contentPadding: const EdgeInsets.all(15),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: Color(0xFFB8A585)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: KingColors.burgundy, width: 1.5),
        ),
      ),
    );
  }
}
