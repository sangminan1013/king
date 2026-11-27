import "package:flutter/material.dart";

abstract final class KingColors {
  static const ink = Color(0xFF292621);
  static const burgundy = Color(0xFF862E32);
  static const burgundyDark = Color(0xFF622428);
  static const gold = Color(0xFFB99A5B);
  static const goldLight = Color(0xFFDFC68D);
  static const paper = Color(0xFFF4ECD8);
  static const paperLight = Color(0xFFFFFAEC);
  static const paperDeep = Color(0xFFEADBB8);
  static const muted = Color(0xFF665647);
  static const green = Color(0xFF35584A);
  static const brown = Color(0xFF49382C);
  static const border = Color(0xFFB7A27B);
  static const subtleBorder = Color(0x537B6248);
  static const wash = Color(0x15B99A5B);
  static const mist = Color(0xFFD8D1BA);
  static const portraitSkin = Color(0xFFE6BC8C);
}

abstract final class KingTheme {
  static const serif = "CourtSerif";
  static const sans = "CourtSans";

  static const decisionSummary = TextStyle(
    fontFamily: serif,
    fontSize: 19,
    fontWeight: FontWeight.w700,
    height: 1.6,
    color: KingColors.burgundyDark,
  );

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: KingColors.burgundy,
      brightness: Brightness.light,
      primary: KingColors.burgundy,
      onPrimary: KingColors.paperLight,
      secondary: KingColors.green,
      onSecondary: KingColors.paperLight,
      surface: KingColors.paper,
      onSurface: KingColors.ink,
      error: KingColors.burgundyDark,
      outline: KingColors.border,
    );
    const heading = TextStyle(
      color: KingColors.ink,
      fontFamily: serif,
      height: 1.35,
      fontWeight: FontWeight.w700,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: KingColors.paper,
      fontFamily: sans,
      textTheme: TextTheme(
        displayLarge: heading.copyWith(
          color: KingColors.burgundyDark,
          fontSize: 66,
          height: 1.05,
          letterSpacing: 3,
        ),
        headlineLarge: heading.copyWith(fontSize: 28),
        headlineMedium: heading.copyWith(fontSize: 22),
        titleMedium: heading.copyWith(fontSize: 17),
        bodyMedium:
            const TextStyle(color: KingColors.ink, fontSize: 14, height: 1.6),
        bodySmall:
            const TextStyle(color: KingColors.muted, fontSize: 12, height: 1.5),
        labelLarge: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: KingColors.paperLight,
        contentPadding: EdgeInsets.all(14),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4))),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(color: KingColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(color: KingColors.burgundy, width: 1.5),
        ),
      ),
    );
  }
}
