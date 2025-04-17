import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_ambulance_system/gen/colors.gen.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    // Scaffold background color
    scaffoldBackgroundColor: ColorName.white,

    // Color scheme
    colorScheme: ColorScheme.fromSeed(seedColor: ColorName.primary),

    // Text theme
    textTheme: GoogleFonts.kumbhSansTextTheme(),
  );
}
