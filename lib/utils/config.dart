import 'package:flutter/material.dart';

class SConfig {
  static MediaQueryData? mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;

  static final String baseUrl = 'http://192.168.54.238:5001';

  // ----------- INIT ------------
 static void init(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    screenWidth = mediaQueryData!.size.width;
    screenHeight = mediaQueryData!.size.height;
  }

  static double? get widthSize => screenWidth;
  static double? get heightSize => screenHeight;

  static String getImageUrlForID(String id) {
    return "${SConfig.baseUrl}/$id";
  }

  // ----------- SPACING ----------
  static const spaceSmall = SizedBox(height: 25);
  static final spaceMedium = SizedBox(height: screenHeight! * 0.05);
  static final spaceBig = SizedBox(height: screenHeight! * 0.08);

  // ----------- NEW COLORS -----------
  static const Color primaryColor = Color(0xFF0F4FA3); // deep blue
  static const Color accentColor = Color(0xFFF29327); // orange

  static const Color backgroundLight = Color(0xFFF5F7FA);
  static const Color surfaceLight = Colors.white;

  static const Color backgroundDark = Color(0xFF0D1117);
  static const Color surfaceDark = Color(0xFF161B22);

  static const Color textDark = Color(0xFF1C1C1C);
  static const Color textLight = Colors.white70;
  static const Color errorColor = Color(0xFFE57373);

  // ---------- BORDER FACTORY ----------
  static OutlineInputBorder _border(Color color, {double width = 1.2}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: color, width: width),
      );

  // 🌞 ----------- LIGHT THEME -----------
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: accentColor,
      surface: surfaceLight,
      background: backgroundLight,
      error: Colors.redAccent,
    ),

    scaffoldBackgroundColor: backgroundLight,

    appBarTheme: const AppBarTheme(
      backgroundColor: surfaceLight,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: textDark,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: primaryColor),
    ),

    cardTheme: CardThemeData(
      color: surfaceLight,
      elevation: 4,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.all(8),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      hintStyle: const TextStyle(color: Colors.black45),
      border: _border(Colors.grey),
      enabledBorder: _border(Colors.grey),
      focusedBorder: _border(primaryColor, width: 1.5),
      errorBorder: _border(errorColor),
      focusedErrorBorder: _border(errorColor, width: 1.5),
      floatingLabelStyle: const TextStyle(
        color: primaryColor,
        fontWeight: FontWeight.w600,
      ),
      prefixIconColor: Colors.black54,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceLight,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey.shade500,
      elevation: 16,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
    ),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: textDark, fontSize: 16),
      bodyMedium: TextStyle(color: Colors.black87, fontSize: 14),
      labelLarge: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),
      headlineSmall: TextStyle(
        color: textDark,
        fontWeight: FontWeight.bold,
        fontSize: 22,
      ),
    ),

    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primaryColor,
    ),
  );

  // 🌙 ----------- DARK THEME -----------
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: accentColor,
      surface: surfaceDark,
      background: backgroundDark,
      error: Colors.redAccent,
    ),

    scaffoldBackgroundColor: backgroundDark,

    appBarTheme: const AppBarTheme(
      backgroundColor: surfaceDark,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: textLight,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: accentColor),
    ),

    cardTheme: CardThemeData(
      color: surfaceDark,
      elevation: 6,
      shadowColor: Colors.black87,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.all(8),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1E2228),
      hintStyle: const TextStyle(color: Colors.white54),
      border: _border(Colors.white24),
      enabledBorder: _border(Colors.white24),
      focusedBorder: _border(accentColor, width: 1.5),
      errorBorder: _border(errorColor),
      focusedErrorBorder: _border(errorColor, width: 1.5),
      floatingLabelStyle: const TextStyle(
        color: accentColor,
        fontWeight: FontWeight.w600,
      ),
      prefixIconColor: Colors.white70,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceDark,
      selectedItemColor: accentColor,
      unselectedItemColor: Colors.grey.shade600,
      elevation: 12,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
    ),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: textLight, fontSize: 16),
      bodyMedium: TextStyle(color: Colors.white70, fontSize: 14),
      labelLarge: TextStyle(color: accentColor, fontWeight: FontWeight.w600),
      headlineSmall: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 22,
      ),
    ),

    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: accentColor,
    ),
  );

  // ---------------------------------------
  // 📱 DEVICE TYPE HELPERS
  // ---------------------------------------

  static bool isMobile() => screenWidth != null && screenWidth! < 600;

  static bool isTablet() =>
      screenWidth != null && screenWidth! >= 600 && screenWidth! < 1100;

  static bool isDesktop() => screenWidth != null && screenWidth! >= 1100;

  static String deviceType() {
    if (isMobile()) return "Mobile";
    if (isTablet()) return "Tablet";
    return "Desktop";
  }
}