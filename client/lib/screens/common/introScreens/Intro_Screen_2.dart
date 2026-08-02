import 'package:flutter/material.dart';

class Intro_Screen_2 extends StatelessWidget {

  const Intro_Screen_2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Intro Screen 2'),
            SizedBox(height: 20),
            Text('Welcome to the app!'),
          ],
        ),
      )
    );
  }
}