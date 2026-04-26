// -------  Nama Program : Login dan Register -------
//------- Author : Refan Rustoni Putra ------
//------- Versi : 10  ------
//------- Ownership : Pribadi------
//------- Deskripsi : Pembuatan halaman Login, Dashboard dan Profile ------

//------- Library ---------
import 'package:flutter/material.dart';

// ─── Design tokens (mirrors index.css @theme) ───────────────────────────────

class AppColors {
  AppColors._();

  static const brandPrimary    = Color(0xFF3A6287);
  static const brandPrimaryDim = Color(0xFF2D567A);
  static const brandBg         = Color(0xFFF8F9FE);
  static const brandSurface    = Color(0xFFFFFFFF);
  static const brandTextMain   = Color(0xFF2D333A);
  static const brandTextSubtle = Color(0xFF5A6067);

  // Semantic
  static const statusPresent  = Color(0xFF16A34A); // green-600
  static const statusAbsent   = Color(0xFFDC2626); // red-600
  static const statusOnline   = Color(0xFF2563EB); // blue-600
}

class AppTextStyles {
  AppTextStyles._();

  static const String fontFamily = 'PlusJakartaSans';

  static const TextStyle display = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: AppColors.brandTextMain,
    letterSpacing: -1.0,
  );

  static const TextStyle headline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: AppColors.brandTextMain,
    letterSpacing: -0.5,
  );

  static const TextStyle title = TextStyle(
    fontFamily: fontFamily,
    fontSize: 17,
    fontWeight: FontWeight.w700,
    color: AppColors.brandTextMain,
  );

  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.brandTextMain,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w700,
    color: AppColors.brandTextSubtle,
    letterSpacing: 1.2,
  );

  static const TextStyle label = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: AppColors.brandPrimary,
    letterSpacing: 1.0,
  );
}

class AppDecorations {
  AppDecorations._();

  /// White card with soft shadow — mirrors `.editorial-card` and `.card-shadow`
  static BoxDecoration editorialCard({
    double radius = 24,
    Color? color,
  }) =>
      BoxDecoration(
        color: color ?? AppColors.brandSurface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: Colors.white.withOpacity(0.4), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A2D333A),
            blurRadius: 32,
            offset: Offset(0, 12),
          ),
        ],
      );

  /// Gradient background blob used on auth screens
  static Decoration authBackground() => const BoxDecoration(
        color: AppColors.brandBg,
      );
}

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.brandBg,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.brandPrimary,
      surface: AppColors.brandSurface,
    ),
    fontFamily: AppTextStyles.fontFamily,
    textTheme: const TextTheme(
      displayLarge: AppTextStyles.display,
      headlineMedium: AppTextStyles.headline,
      titleMedium: AppTextStyles.title,
      bodyMedium: AppTextStyles.body,
      labelSmall: AppTextStyles.caption,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF9FAFB),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: AppColors.brandPrimary.withOpacity(0.3),
          width: 2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.brandPrimary,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 56),
        shape: const StadiumBorder(),
        textStyle: const TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontWeight: FontWeight.w700,
          fontSize: 15,
        ),
        elevation: 0,
      ),
    ),
  );
}
