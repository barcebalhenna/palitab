import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PalitabTheme {
  static const Color accentWarm = Color(0xFFFFB703);
  static const Color accentHot = Color(0xFFFB8500);
  static const Color purple = Color(0xFF673AB7);
  static const Color teal = Color(0xFF219EBC);
  static const Color softCream = Color(0xFFFFFAF0);
  static const Color pureWhite = Color(0xFFFFFFFF);

  static ThemeData get theme => ThemeData(
    primaryColor: accentWarm,
    scaffoldBackgroundColor: softCream,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: accentHot,
      primary: accentWarm,
    ),
    textTheme: GoogleFonts.patrickHandTextTheme(  // 👈 playful rounded font globally
      ThemeData.light().textTheme,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: accentWarm,
      foregroundColor: Colors.black,
      titleTextStyle: GoogleFonts.patrickHand(   // 👈 app bar text playful too
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentWarm,
        foregroundColor: Colors.black,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        textStyle: GoogleFonts.patrickHand(       // 👈 button text matches
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    ),
  );
}
