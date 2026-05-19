import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ============================================================
//  ASTREA CORRECT — BROWN THEME DESIGN SYSTEM
// ============================================================

// --- Core Palette ---
const Color kPrimaryBrown   = Color(0xFF6B4F3A); // Rich coffee brown
const Color kSecondaryBrown = Color(0xFF8B6B4A); // Soft brown
const Color kAccentTan      = Color(0xFFC19A6B); // Tan for hover/highlights
const Color kMainBg         = Color(0xFFF5F1EB); // Light cream background
const Color kCardBg         = Color(0xFFE8DCCB); // Muted tan for cards

const Color kErrorRed       = Color(0xFFD32F2F);
const Color kSuccessGreen   = Color(0xFF388E3C);

// --- Text Colors ---
const Color kTextPrimary    = Color(0xFF2D241E);
const Color kTextSecondary  = Color(0xFF5D4D42);

// ===================== TEXT STYLES =====================
class AppTextStyles {
  static TextStyle get headline1 => GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: kTextPrimary,
      );

  static TextStyle get headline2 => GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: kTextPrimary,
      );

  static TextStyle get bodyText => GoogleFonts.inter(
        fontSize: 16,
        color: kTextPrimary,
      );

  static TextStyle get subtitle1 => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: kTextSecondary,
      );

  static TextStyle get labelText => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: kTextSecondary,
      );

  static TextStyle get buttonText => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      );
}

// ===================== THEME DATA =====================

ThemeData buildBrownTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: kPrimaryBrown,
    scaffoldBackgroundColor: kMainBg,
    colorScheme: const ColorScheme.light(
      primary: kPrimaryBrown,
      secondary: kSecondaryBrown,
      tertiary: kAccentTan,
      surface: kCardBg,
      error: kErrorRed,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: kTextPrimary,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: kPrimaryBrown,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTextStyles.headline2.copyWith(color: Colors.white),
    ),
    cardTheme: CardThemeData(
      color: kCardBg,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: kSecondaryBrown.withOpacity(0.1)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryBrown,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: AppTextStyles.buttonText,
      ).copyWith(
        overlayColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.hovered)) return kAccentTan.withOpacity(0.2);
          return null;
        }),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withOpacity(0.5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: kSecondaryBrown.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: kPrimaryBrown, width: 2),
      ),
      contentPadding: const EdgeInsets.all(20),
    ),
    textTheme: TextTheme(
      headlineLarge: AppTextStyles.headline1,
      headlineMedium: AppTextStyles.headline2,
      bodyLarge: AppTextStyles.bodyText,
      bodyMedium: AppTextStyles.bodyText.copyWith(color: kTextSecondary, fontSize: 14),
    ),
  );
}

// Keep aliases for backward compatibility where necessary
const Color kBackgroundColor = kMainBg;
const Color kPrimaryColor = kPrimaryBrown;
const Color kCardColor = kCardBg;
const Color kTextColorPrimary = kTextPrimary;
const Color kTextColorSecondary = kTextSecondary;

// --- Legacy & Compatibility Aliases ---
const Color kAstreaPrimary   = kPrimaryBrown;
const Color kAstreaSecondary = kSecondaryBrown;
const Color kAstreaAccent    = kAccentTan;
const Color kAstreaSuccess   = kSuccessGreen;
const Color kAstreaError     = kErrorRed;

const Color kDarkBg          = Color(0xFF1E1A17);
const Color kLightBg         = kMainBg;
const Color kDarkCard        = Color(0xFF2D2621);
const Color kLightCard       = kCardBg;
const Color kDarkTextPrimary = Colors.white;
const Color kLightTextPrimary = kTextPrimary;
const Color kDarkTextSecondary = Colors.white70;
const Color kLightTextSecondary = kTextSecondary;

// --- Decorations & UI Elements ---
BoxDecoration kGlassDecoration({double radius = 12, bool isDark = false}) {
  return BoxDecoration(
    color: isDark ? Colors.white.withOpacity(0.05) : Colors.white.withOpacity(0.7),
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(
      color: isDark ? Colors.white.withOpacity(0.1) : kSecondaryBrown.withOpacity(0.2),
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );
}

const LinearGradient kButtonGradient = LinearGradient(
  colors: [kPrimaryBrown, kSecondaryBrown],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);
