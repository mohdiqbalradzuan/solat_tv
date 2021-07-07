import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        //mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            child: Container(
              child: new Image.asset(
                'assets/images/mosque_icon.png',
                height: 200,
                width: 200,
              ),
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 30),
            ),
          ),
          Align(
            child: Text(
              'Solat TV',
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
