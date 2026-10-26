import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      cardColor: AppColors.cardLight,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.backgroundLight,
      ),
      textTheme: _textTheme(AppColors.textPrimaryLight, AppColors.textSecondaryLight),
      useMaterial3: true,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      cardColor: AppColors.cardDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.backgroundDark,
      ),
      textTheme: _textTheme(AppColors.textPrimaryDark, AppColors.textSecondaryDark),
      useMaterial3: true,
    );
  }

  static TextTheme _textTheme(Color primaryColor, Color secondaryColor) {
    return TextTheme(
      displayLarge: GoogleFonts.poppins(fontSize: 56, fontWeight: FontWeight.w700, color: primaryColor),
      displayMedium: GoogleFonts.poppins(fontSize: 48, fontWeight: FontWeight.w700, color: primaryColor),
      displaySmall: GoogleFonts.poppins(fontSize: 36, fontWeight: FontWeight.w700, color: primaryColor),
      headlineLarge: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.w700, color: primaryColor),
      headlineMedium: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.w600, color: primaryColor),
      headlineSmall: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600, color: primaryColor),
      titleLarge: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: primaryColor),
      titleMedium: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w600, color: primaryColor),
      titleSmall: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w600, color: primaryColor),
      bodyLarge: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w400, color: secondaryColor),
      bodyMedium: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w400, color: secondaryColor),
      bodySmall: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w400, color: secondaryColor),
      labelLarge: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.primary),
    );
  }
}
