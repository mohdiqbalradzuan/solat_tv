import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DarkTheme {
  ThemeData get theme => ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.amber,
        buttonTheme: ButtonThemeData(),
        fontFamily: GoogleFonts.lato().fontFamily,
        textTheme: TextTheme(),
      );
}
