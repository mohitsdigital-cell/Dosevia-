import 'package:flutter/material.dart';

/// Dosevia brand colours - Master Blueprint Part 13.1.
class DoseviaColors {
  static const primary = Color(0xFF2457A7);
  static const teal = Color(0xFF20A99A);
  static const background = Color(0xFFF6F8FC);
  static const textMain = Color(0xFF182230);
  static const textSecondary = Color(0xFF667085);
  static const success = Color(0xFF16865A);
  static const warning = Color(0xFFD98B19);
  static const critical = Color(0xFFC83D4D);

  static const darkSurface = Color(0xFF141B27);
  static const darkBackground = Color(0xFF0F141C);
  static const darkTextMain = Color(0xFFE7ECF3);
}

class DoseviaTheme {
  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: DoseviaColors.primary,
    ).copyWith(
      surface: DoseviaColors.background,
      onSurface: DoseviaColors.textMain,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: DoseviaColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: DoseviaColors.background,
        foregroundColor: DoseviaColors.textMain,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: const CardThemeData(
        elevation: 0,
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: Color(0xFFE6EAF2)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD6DCE8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD6DCE8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: DoseviaColors.primary, width: 1.5),
        ),
      ),
    );
  }

  static ThemeData get dark {
    final scheme = ColorScheme.fromSeed(
      seedColor: DoseviaColors.primary,
      brightness: Brightness.dark,
    ).copyWith(
      surface: DoseviaColors.darkBackground,
      onSurface: DoseviaColors.darkTextMain,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: DoseviaColors.darkBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: DoseviaColors.darkBackground,
        foregroundColor: DoseviaColors.darkTextMain,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: const CardThemeData(
        elevation: 0,
        color: DoseviaColors.darkSurface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: Color(0xFF252E3E)),
        ),
      ),
    );
  }
}
