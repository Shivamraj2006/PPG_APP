import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors from the Tailwind config
  static const Color surface = Color(0xFF121221);
  static const Color surfaceContainer = Color(0xFF1E1E2E);
  static const Color surfaceContainerHigh = Color(0xFF292839);
  static const Color surfaceVariant = Color(0xFF333344);
  
  static const Color primary = Color(0xFF89DCEB);
  static const Color secondary = Color(0xFF87D5C8);
  static const Color error = Color(0xFFFFB4AB);
  
  static const Color onSurface = Color(0xFFE3E0F7);
  static const Color onSurfaceVariant = Color(0xFFBEC8CB);
  static const Color onPrimaryContainer = Color(0xFF00626D);
  static const Color onSecondaryContainer = Color(0xFF91DFD2);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: surface,
      primaryColor: primary,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        surface: surface,
        error: error,
        onSurface: onSurface,
        onSurfaceVariant: onSurfaceVariant,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.spaceGrotesk(
          fontSize: 48,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.96,
          height: 1.1,
          color: onSurface,
        ),
        headlineLarge: GoogleFonts.spaceGrotesk(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          height: 1.2,
          color: onSurface,
        ),
        headlineMedium: GoogleFonts.spaceGrotesk(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          height: 1.3,
          color: onSurface,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          height: 1.6,
          color: onSurface,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: onSurface,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.7,
          height: 1.2,
          color: onSurface,
        ),
        labelMedium: GoogleFonts.spaceGrotesk(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          height: 1.0,
          color: onSurface,
        ), // used as data-mono
      ),
      iconTheme: const IconThemeData(
        color: onSurface,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceContainer,
        selectedItemColor: primary,
        unselectedItemColor: onSurfaceVariant,
      ),
      useMaterial3: true,
    );
  }
}
