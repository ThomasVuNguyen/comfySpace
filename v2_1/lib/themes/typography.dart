import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextTheme ComfyTextTheme = TextTheme(
  displayLarge: GoogleFonts.ubuntu(fontWeight: FontWeight.w500, fontSize: 32),
  displayMedium: GoogleFonts.ubuntu(fontWeight: FontWeight.w500, fontSize: 28),
  displaySmall: GoogleFonts.ubuntu(fontWeight: FontWeight.w500, fontSize: 24),

  headlineLarge: GoogleFonts.ubuntu(fontWeight: FontWeight.w500, fontSize: 22),
  headlineMedium: GoogleFonts.ubuntu(fontWeight: FontWeight.w500, fontSize: 18),
  headlineSmall: GoogleFonts.ubuntu(fontWeight: FontWeight.w500, fontSize: 16),

  titleLarge: GoogleFonts.manrope(fontWeight: FontWeight.w600, fontSize: 16),
  titleMedium: GoogleFonts.manrope(fontWeight: FontWeight.w600, fontSize: 14),
  titleSmall: GoogleFonts.manrope(fontWeight: FontWeight.w600, fontSize: 12),

  bodyLarge: GoogleFonts.manrope(fontWeight: FontWeight.w500, fontSize: 16),
  bodyMedium: GoogleFonts.manrope(fontWeight: FontWeight.w500, fontSize: 14),
  bodySmall: GoogleFonts.manrope(fontWeight: FontWeight.w500, fontSize: 12),

  labelLarge: GoogleFonts.ubuntu(fontWeight: FontWeight.w500, fontSize: 16), //could be medium 500
  labelMedium: GoogleFonts.ubuntu(fontWeight: FontWeight.w500, fontSize: 14), //could be medium 500
  labelSmall: GoogleFonts.ubuntu(fontWeight: FontWeight.w500, fontSize: 12),

);

TextStyle labelMediumProminent = GoogleFonts.montserrat(fontWeight: FontWeight.w700, fontSize: 12);