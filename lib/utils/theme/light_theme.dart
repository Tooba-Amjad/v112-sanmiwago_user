import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';

ThemeData lightTheme = ThemeData(
  // scaffoldBackgroundColor: kSeoulColor2,
  scaffoldBackgroundColor: Colors.white,
  useMaterial3: false,
  fontFamily: GoogleFonts.poppins().fontFamily,
  appBarTheme: const AppBarTheme(
    elevation: 3,
    backgroundColor: AppColors.kPrimaryColor,
  ),
  splashColor: AppColors.kPrimaryColor.withOpacity(0.10),
  highlightColor: AppColors.kPrimaryColor.withOpacity(0.10),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    secondary: AppColors.kSecondaryColor.withOpacity(0.1),
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: AppColors.kSecondaryColor,
  ),
);
