import 'package:flutter/material.dart';
import 'package:client/services/Onboard_Storage_Service.dart';

class Intro_Screen_3 extends StatelessWidget {

  const Intro_Screen_3({super.key});

  Future<void> completeOnboardingStatus() async {
    await OnboardStorageService().completeOnboarding();
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
                Navigator.pushReplacementNamed(context, '/loginScreen');
              },
              child: Text("complete"),
            )
          ],
        ),
      )
    );
  }
}