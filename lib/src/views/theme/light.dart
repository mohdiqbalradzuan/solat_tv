import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Light {
  ThemeData get theme => ThemeData(
        brightness: Brightness.light,
        buttonTheme: ButtonThemeData(),
        fontFamily: GoogleFonts.lato().fontFamily,
        primaryColor: Color(0xff0F360F),
        textTheme: TextTheme(
          headline2: TextStyle(fontWeight: FontWeight.w900),
        ),
        colorScheme: ColorScheme.light(
          primary: Color(0xff0F360F),
          secondary: Colors.red[900],
        ),
      );
}
