import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Dark {
  ThemeData get theme => ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.amber,
        primaryColor: Colors.amber,
        buttonTheme: ButtonThemeData(),
        fontFamily: GoogleFonts.lato().fontFamily,
        textTheme: TextTheme(
          headline2: TextStyle(fontWeight: FontWeight.w900),
        ),
      );
}
