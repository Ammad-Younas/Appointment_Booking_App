import 'package:flutter/material.dart';
import 'package:appointment_booking_app/utils/app_colors.dart';

enum AppThemeMode {
  light,
  dark,
  protanopia, // Red-blind
  deuteranopia, // Green-blind
  tritanopia, // Blue-blind
}

class ThemeService extends ChangeNotifier {
  AppThemeMode _currentThemeMode = AppThemeMode.light;

  AppThemeMode get currentThemeMode => _currentThemeMode;

  void setThemeMode(AppThemeMode mode) {
    _currentThemeMode = mode;
    notifyListeners();
  }

  ThemeData get currentThemeData {
    switch (_currentThemeMode) {
      case AppThemeMode.dark:
        return _darkTheme;
      case AppThemeMode.protanopia:
        return _protanopiaTheme;
      case AppThemeMode.deuteranopia:
        return _deuteranopiaTheme;
      case AppThemeMode.tritanopia:
        return _tritanopiaTheme;
      case AppThemeMode.light:
      default:
        return _lightTheme;
    }
  }

  // --- Light Theme ---
  static final ThemeData _lightTheme = ThemeData(
    primaryColor: AppColors.madiBlue,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Ubuntu',
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.madiBlue, brightness: Brightness.light),
    useMaterial3: true,
  );

  // --- Dark Theme ---
  static final ThemeData _darkTheme = ThemeData(
    primaryColor: AppColors.madiBlue,
    scaffoldBackgroundColor: const Color(0xFF121212),
    fontFamily: 'Ubuntu',
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.madiBlue, brightness: Brightness.dark, surface: const Color(0xFF1E1E1E)),
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
  );

  // --- Protanopia (Red-Blind) ---
  // Avoids red/green confusion. Uses blues and yellows.
  static final ThemeData _protanopiaTheme = ThemeData(
    primaryColor: const Color(0xFF0072B2), // Blue
    scaffoldBackgroundColor: const Color(0xFFF0F0F0),
    fontFamily: 'Ubuntu',
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF0072B2),
      brightness: Brightness.light,
      error: const Color(0xFFD55E00), // Vermilion
    ),
    useMaterial3: true,
  );

  // --- Deuteranopia (Green-Blind) ---
  // Similar to Protanopia, avoids red/green.
  static final ThemeData _deuteranopiaTheme = ThemeData(
    primaryColor: const Color(0xFF0072B2), // Blue
    scaffoldBackgroundColor: const Color(0xFFF0F0F0),
    fontFamily: 'Ubuntu',
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF0072B2),
      brightness: Brightness.light,
      error: const Color(0xFFD55E00), // Vermilion
    ),
    useMaterial3: true,
  );

  // --- Tritanopia (Blue-Blind) ---
  // Avoids blue/yellow confusion. Uses reds and teals.
  static final ThemeData _tritanopiaTheme = ThemeData(
    primaryColor: const Color(0xFFD55E00), // Vermilion (Red-Orange)
    scaffoldBackgroundColor: const Color(0xFFF0F0F0),
    fontFamily: 'Ubuntu',
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFD55E00),
      brightness: Brightness.light,
      secondary: const Color(0xFF009E73), // Bluish Green
    ),
    useMaterial3: true,
  );
}
