import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:appointment_booking_app/utils/app_colors.dart';
import 'package:appointment_booking_app/services/theme_service.dart';

class ThemeSettingsScreen extends StatelessWidget {
  const ThemeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              borderRadius: BorderRadius.circular(100),
              child: Container(
                decoration: BoxDecoration(color: AppColors.madiBlue.withValues(alpha: 0.2), shape: BoxShape.circle),
                child: Center(child: Icon(Icons.arrow_back_ios_new, color: AppColors.madiGrey, size: 18)),
              ),
            ),
          ),
          title: Text(
            'Theme Settings',
            style: TextStyle(fontFamily: 'Ubuntu', fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.titleLarge?.color ?? Colors.black),
          ),
          centerTitle: true,
        ),
        body: Consumer<ThemeService>(
          builder: (context, themeService, child) {
            return ListView(
              padding: const EdgeInsets.all(24.0),
              children: [
                _buildThemeOption(context, title: 'Light Mode', mode: AppThemeMode.light, currentMode: themeService.currentThemeMode, onTap: () => themeService.setThemeMode(AppThemeMode.light)),
                const SizedBox(height: 16),
                _buildThemeOption(context, title: 'Dark Mode', mode: AppThemeMode.dark, currentMode: themeService.currentThemeMode, onTap: () => themeService.setThemeMode(AppThemeMode.dark)),
                const SizedBox(height: 32),
                Text(
                  'Color Blindness Modes',
                  style: TextStyle(fontFamily: 'Ubuntu', fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black),
                ),
                const SizedBox(height: 16),
                _buildThemeOption(context, title: 'Protanopia (Red-Blind)', mode: AppThemeMode.protanopia, currentMode: themeService.currentThemeMode, onTap: () => themeService.setThemeMode(AppThemeMode.protanopia)),
                const SizedBox(height: 16),
                _buildThemeOption(context, title: 'Deuteranopia (Green-Blind)', mode: AppThemeMode.deuteranopia, currentMode: themeService.currentThemeMode, onTap: () => themeService.setThemeMode(AppThemeMode.deuteranopia)),
                const SizedBox(height: 16),
                _buildThemeOption(context, title: 'Tritanopia (Blue-Blind)', mode: AppThemeMode.tritanopia, currentMode: themeService.currentThemeMode, onTap: () => themeService.setThemeMode(AppThemeMode.tritanopia)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildThemeOption(BuildContext context, {required String title, required AppThemeMode mode, required AppThemeMode currentMode, required VoidCallback onTap}) {
    final isSelected = mode == currentMode;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.madiBlue.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(15.0),
          border: isSelected ? Border.all(color: AppColors.madiBlue, width: 2) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontFamily: 'Ubuntu', fontSize: 16.0, fontWeight: FontWeight.w600, color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black),
            ),
            if (isSelected) Icon(Icons.check_circle, color: AppColors.madiBlue) else Icon(Icons.circle_outlined, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
