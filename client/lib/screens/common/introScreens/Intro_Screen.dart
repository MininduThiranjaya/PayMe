import 'package:flutter/material.dart';
import 'Intro_Screen_1.dart';
import 'Intro_Screen_2.dart';
import 'Intro_Screen_3.dart';

class Intro_Screen extends StatelessWidget {

  const Intro_Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          children: const [
            Intro_Screen_1(),
            Intro_Screen_2(),
            Intro_Screen_3(),
          ],
        ),
      )
    );
  }
}