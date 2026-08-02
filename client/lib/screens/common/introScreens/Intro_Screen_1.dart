import 'package:flutter/material.dart';

class Intro_Screen_1 extends StatelessWidget {

  const Intro_Screen_1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Intro Screen 1'),
            SizedBox(height: 20),
            Text('Welcome to the app!'),
          ],
        ),
      )
    );
  }
}