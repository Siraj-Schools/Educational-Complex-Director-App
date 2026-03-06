import 'package:educational_complex_director_app/l10n/app_localizations.dart';
import 'package:educational_complex_director_app/utils/enums/screen_names.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SConfig {
  static MediaQueryData? mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;
  const SConfig._();
  static const String baseUrl = 'http://192.168.54.238:5001';
  static String getTitle(BuildContext context, ScreenNames page) {
    final loc = AppLocalizations.of(context)!;

    switch (page) {
      case ScreenNames.home:
        return loc.home;
      case ScreenNames.schools:
        return loc.schools;
      case ScreenNames.applications:
        return loc.applications;
      case ScreenNames.settings:
        return loc.settings;
      case ScreenNames.addSchool:
        return loc.addSchool;
      case ScreenNames.schoolDetails:
        return loc.schoolDetails;
    }
  }

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

  // ============================================================
  // 🎨 SIRAJ OFFICIAL COLOR SYSTEM
  // ============================================================

  // 🔵 PRIMARY BRAND COLOR
  // Main identity color – use for:
  // - Main buttons
  // - App primary actions
  // - Active navigation
  // - Important headers
  static const Color primaryColor = Color(0xFF0F7C82); // Teal Blue

  // 🟠 SECONDARY ACCENT (Energy / Action)
  // Use for:
  // - CTA buttons (Start / Submit / Continue)
  // - Highlights
  // - Important icons
  static const Color accentColor = Color(0xFFF47B20); // Bright Orange

  // 🟡 LIGHT ACCENT (Knowledge / Light)
  // Use for:
  // - Hover states
  // - Badges
  // - Decorative highlights
  static const Color highlightColor = Color(0xFFF5C518); // Golden Yellow

  // 🟢 SUCCESS COLOR
  // Use for:
  // - Success messages
  // - Completed lessons
  // - Approved status
  static const Color successColor = Color(0xFF7AC943); // Fresh Green

  // 🔷 SUPPORTING BLUE
  // Use for:
  // - Section backgrounds
  // - Cards background tint
  // - Secondary surfaces
  static const Color secondaryBackground = Color(0xFF2CA6A4); // Soft Blue

  // ⚪ LIGHT BACKGROUND (Main App Background)
  static const Color backgroundLight = Color(0xFFF4F6F8);

  // ⚫ DARK TEXT (Primary readable text)
  static const Color textDark = Color(0xFF1F2933);

  // ⚪ LIGHT TEXT (Dark mode)
  static const Color textLight = Colors.white;

  // 🔴 ERROR COLOR
  static const Color errorColor = Color(0xFFD64545);

  // ============================================================
  // 📏 SPACING
  // ============================================================

  static const spaceSmall = SizedBox(height: 16);
  static const spaceMedium = SizedBox(height: 24);
  static const spaceBig = SizedBox(height: 40);

  // ============================================================
  // 🧱 BORDER FACTORY
  // ============================================================

  static OutlineInputBorder _border(Color color, {double width = 1.2}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: color, width: width),
      );

  // ============================================================
  // 🌞 LIGHT THEME (Arabic Optimized)
  // ============================================================

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: WidgetStatePropertyAll(primaryColor.withAlpha(200)),
      thickness: const WidgetStatePropertyAll(5),
      mainAxisMargin: 5,
    ),
    fontFamily: GoogleFonts.cairo().fontFamily, // Clean Arabic font

    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: accentColor,
      surface: Colors.white,
      error: errorColor,
    ),

    scaffoldBackgroundColor: backgroundLight,

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: primaryColor),
      titleTextStyle: TextStyle(
        color: textDark,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),

    // 🪪 CARDS (Used for: Student info, Lessons, Dashboard widgets)
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 3,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
    ),

    // ✏️ INPUT FIELDS (Login / Forms / Search)
    inputDecorationTheme: InputDecorationTheme(
      filled: true,

      fillColor: Colors.white,
      hintStyle: const TextStyle(color: Colors.black45),
      border: _border(Colors.grey.shade300),

      enabledBorder: _border(secondaryBackground),
      disabledBorder: _border(secondaryBackground),
      focusedBorder: _border(primaryColor, width: 1.5),
      errorBorder: _border(errorColor),
      focusedErrorBorder: _border(errorColor, width: 1.5),
      floatingLabelStyle: const TextStyle(
        color: primaryColor,
        fontWeight: FontWeight.w600,
      ),

      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey.shade500,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
    ),

    // ============================================================
    // 📝 TEXT THEME (Where to Use Each)
    // ============================================================
    textTheme: const TextTheme(
      // 🔹 Main page titles
      // Example: "لوحة التحكم", "المقررات"
      headlineSmall: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: textDark,
      ),

      // 🔹 Section titles inside pages
      // Example: "الطلاب المسجلين"
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textDark,
      ),

      // 🔹 Main content text
      // Example: lesson descriptions, student details
      bodyLarge: TextStyle(
        fontSize: 16,
        color: textDark,
      ),

      // 🔹 Secondary content
      // Example: dates, metadata, hints
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Colors.black87,
      ),

      // 🔹 Buttons text
      // Example: "ابدأ", "حفظ", "التالي"
      labelLarge: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),

    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primaryColor,
    ),
  );

  // ============================================================
  // 🌙 DARK THEME (Professional Government Look)
  // ============================================================

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: GoogleFonts.cairo().fontFamily,

    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: accentColor,
      surface: Color(0xFF1E2A2F),
      error: errorColor,
    ),

    scaffoldBackgroundColor: const Color(0xFF121A1F),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E2A2F),
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: accentColor),
    ),

    cardTheme: CardThemeData(
      color: const Color(0xFF1E2A2F),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
    ),

    textTheme: const TextTheme(
      headlineSmall: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Colors.white70,
      ),
      labelLarge: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),

    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: accentColor,
    ),
  );

  // ============================================================
  // 📱 DEVICE TYPE HELPERS
  // ============================================================

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
