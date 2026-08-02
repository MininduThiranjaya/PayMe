import 'package:flutter/material.dart';
import 'package:client/services/Onboard_Storage_Service.dart';

class Splash_Screen extends StatefulWidget {

  const Splash_Screen({super.key});

  @override
  State<Splash_Screen> createState() => _Splash_Screen_State();
}

class _Splash_Screen_State extends State<Splash_Screen> {

  @override
  initState() {
    super.initState();
    checkOnboardingStatus();
  }

  Future<void> checkOnboardingStatus() async {
    final bool hasSeenOnboarding = await OnboardStorageService().hasSeenOnboarding();
    if (!mounted) return;
    if (hasSeenOnboarding) {
      Navigator.pushReplacementNamed(context, '/loginScreen');
    } else {
      Navigator.pushReplacementNamed(context, '/introScreen');
    }
  }

  @override
  Widget build(BuildContext buildContext) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('PayMe'),
            ],
          ),
        )
      )
    );
  }
}