import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextTheme ComfyTextTheme = TextTheme(
  displayLarge: GoogleFonts.montserrat(fontWeight: FontWeight.w500, fontSize: 57),
  displayMedium: GoogleFonts.montserrat(fontWeight: FontWeight.w500, fontSize: 45),
  displaySmall: GoogleFonts.montserrat(fontWeight: FontWeight.w500, fontSize: 36),

  headlineLarge: GoogleFonts.ubuntu(fontWeight: FontWeight.w500, fontSize: 32),
  headlineMedium: GoogleFonts.ubuntu(fontWeight: FontWeight.w500, fontSize: 28),
  headlineSmall: GoogleFonts.ubuntu(fontWeight: FontWeight.w500, fontSize: 24),

  titleLarge: GoogleFonts.ubuntu(fontWeight: FontWeight.w500, fontSize: 20),
  titleMedium: GoogleFonts.ubuntu(fontWeight: FontWeight.w500, fontSize: 16),
  titleSmall: GoogleFonts.ubuntu(fontWeight: FontWeight.w500, fontSize: 16),

  bodyLarge: GoogleFonts.montserrat(fontWeight: FontWeight.normal, fontSize: 16),
  bodyMedium: GoogleFonts.montserrat(fontWeight: FontWeight.normal, fontSize: 14),
  bodySmall: GoogleFonts.montserrat(fontWeight: FontWeight.normal, fontSize: 12),

  labelLarge: GoogleFonts.montserrat(fontWeight: FontWeight.w500, fontSize: 16), //could be medium 500
  labelMedium: GoogleFonts.montserrat(fontWeight: FontWeight.w500, fontSize: 12), //could be medium 500
  labelSmall: GoogleFonts.montserrat(fontWeight: FontWeight.w500, fontSize: 11),

);

TextStyle labelMediumProminent = GoogleFonts.montserrat(fontWeight: FontWeight.w700, fontSize: 12);