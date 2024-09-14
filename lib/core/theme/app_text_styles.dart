import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  static final textTheme = GoogleFonts.nunitoTextTheme();
  static const boldBigGreen = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.appColor,
  );
  static const barButtonGreenTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.appColor,
  );
  static const boldAppBarTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
  static const textFieldTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
  static const infoLabelText = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.normal,
    color: Colors.red,
  );
  static const checkBoxLabelText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );
  // Add any other text styles you want to use in your app
}
