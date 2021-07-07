import 'package:flutter/material.dart';
import 'dashboard.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        //mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            child: new Image.asset(
              'assets/images/mosque_icon.png',
              height: 200,
              width: 200,
            ),
          ),
          Align(
            child: SizedBox(
              height: 30,
            ),
          ),
          Align(
            child: Text(
              'Solat TV',
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          Align(
            child: SizedBox(
              height: 20,
            ),
          ),
          Align(
            child: ElevatedButton(
              child: Text('Go to dashboard'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Dashboard()));
              },
            ),
          ),
        ],
      ),
    );
  }
}
