import 'package:flutter/material.dart';
import 'package:client/storage/Onboard_Storage.dart';

class Intro_Screen_3 extends StatelessWidget {

  const Intro_Screen_3({super.key});

  Future<void> completeOnboardingStatus() async {
    await Onboard_Storage().completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Intro Screen 3'),
            SizedBox(height: 20),
            Text('Welcome to the app!'),
            SizedBox(height: 20),
            FloatingActionButton(
              onPressed: () {
                completeOnboardingStatus();
                Navigator.pushNamedAndRemoveUntil(context, '/loginScreen', (route) => false);
              },
              child: Text("complete"),
            )
          ],
        ),
      )
    );
  }
}