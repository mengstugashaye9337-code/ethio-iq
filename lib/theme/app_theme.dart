import 'package:flutter/material.dart';

/// Ethio IQ Design System - Soft Blue Theme
/// Centralized theme for consistent UI across all screens
class AppTheme {
  // ==================== SOFT BLUE COLOR PALETTE ====================
  
  /// Primary soft blue color for Ethio IQ
  static const Color primaryBlue = Color(0xFF6C8DFF);
  
  /// Light accent blue for backgrounds and highlights
  static const Color lightAccent = Color(0xFFB6C7FF);
  
  /// Very light grey-blue background
  static const Color backgroundLight = Color(0xFFF7F9FC);
  
  /// White background
  static const Color backgroundWhite = Colors.white;
  
  /// Dark grey text color
  static const Color textDark = Color(0xFF2B2B2B);
  
  /// Secondary text color
  static const Color textSecondary = Color(0xFF6B7280);
  
  /// Light blue for card backgrounds
  static const Color lightBlueCard = Color(0xFFE8EEFF);
  
  /// Amber color for ratings
  static const Color ratingColor = Color(0xFFFBBF24);
  
  /// Success green
  static const Color successColor = Color(0xFF10B981);
  
  /// Warning amber
  static const Color warningColor = Color(0xFFF59E0B);
  
  /// Error red
  static const Color errorColor = Color(0xFFEF4444);

  // ==================== SOFT GRADIENT ====================
  
  /// Soft blue gradient for headers and backgrounds
  static const LinearGradient softBlueGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBlue, lightAccent],
  );
  
  /// Light gradient for subtle backgrounds
  static const LinearGradient lightGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFF7F9FC), Color(0xFFE8EEFF)],
  );

  // ==================== TEXT STYLES ====================
  
  /// Large title style (screen headers)
  static const TextStyle titleLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: textDark,
  );
  
  /// Medium title style (section headers)
  static const TextStyle titleMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: textDark,
  );
  
  /// Small title style (card titles)
  static const TextStyle titleSmall = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textDark,
  );
  
  /// Body text style
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: textDark,
  );
  
  /// Body text style (secondary)
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: textSecondary,
  );
  
  /// Small text style
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: textSecondary,
  );
  
  /// Button text style
  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  // ==================== DECORATIONS ====================
  
  /// Card decoration with light blue background
  static BoxDecoration cardDecoration = BoxDecoration(
    color: lightBlueCard,
    borderRadius: BorderRadius.circular(12),
  );
  
  /// Card decoration with white background
  static BoxDecoration whiteCardDecoration = BoxDecoration(
    color: backgroundWhite,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: Colors.grey[300]!),
  );
  
  /// Gray card decoration for price boxes
  static BoxDecoration grayCardDecoration = BoxDecoration(
    color: backgroundLight,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: Colors.grey[300]!),
  );
  
  /// Info box decoration (amber warning style)
  static BoxDecoration infoBoxDecoration = BoxDecoration(
    color: Colors.amber[50],
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: Colors.amber[200]!),
  );

  // ==================== SPACING ====================
  
  /// Standard padding
  static const double paddingStandard = 16.0;
  
  /// Large padding
  static const double paddingLarge = 24.0;
  
  /// Small padding
  static const double paddingSmall = 8.0;
  
  /// Extra small spacing
  static const double spacingXS = 4.0;
  
  /// Small spacing
  static const double spacingS = 8.0;
  
  /// Medium spacing
  static const double spacingM = 12.0;
  
  /// Large spacing
  static const double spacingL = 16.0;
  
  /// Extra large spacing
  static const double spacingXL = 24.0;
  
  /// Extra extra large spacing
  static const double spacingXXL = 32.0;

  // ==================== BORDER RADIUS ====================
  
  /// Small border radius
  static const double radiusS = 8.0;
  
  /// Medium border radius
  static const double radiusM = 12.0;
  
  /// Large border radius
  static const double radiusL = 14.0;
  
  /// Extra large border radius
  static const double radiusXL = 30.0;

  // ==================== ELEVATED BUTTON ====================
  
  /// Standard elevated button style
  static ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryBlue,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusM),
    ),
    elevation: 0,
  );
  
  /// Full width elevated button style
  static ButtonStyle fullWidthButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryBlue,
    foregroundColor: Colors.white,
    minimumSize: const Size(double.infinity, 52),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusM),
    ),
    elevation: 0,
  );

  // ==================== APP BAR ====================
  
  /// Standard app bar theme
  static AppBarTheme appBarTheme = const AppBarTheme(
    backgroundColor: primaryBlue,
    foregroundColor: Colors.white,
    centerTitle: true,
    elevation: 0,
    titleTextStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  );

  // ==================== ICON STYLES ====================
  
  /// Large icon size
  static const double iconL = 32.0;
  
  /// Medium icon size
  static const double iconM = 24.0;
  
  /// Small icon size
  static const double iconS = 18.0;

  // ==================== AVATAR STYLES ====================
  
  /// Large avatar radius
  static const double avatarL = 30.0;
  
  /// Medium avatar radius
  static const double avatarM = 24.0;
  
  /// Small avatar radius
  static const double avatarS = 16.0;

  // ==================== THEME DATA ====================

  /// App-wide Material theme using the soft blue design system.
  static ThemeData themeData = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: backgroundLight,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryBlue,
      primary: primaryBlue,
      secondary: lightAccent,
      surface: backgroundWhite,
    ),
    appBarTheme: appBarTheme,
    textTheme: const TextTheme(
      titleLarge: titleLarge,
      titleMedium: titleMedium,
      titleSmall: titleSmall,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,
      labelLarge: buttonText,
    ),
    cardTheme: CardThemeData(
      color: backgroundWhite,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusM),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: backgroundWhite,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusXL),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusM),
        ),
        elevation: 0,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: primaryBlue,
      unselectedItemColor: textSecondary,
      backgroundColor: backgroundWhite,
    ),
  );
}