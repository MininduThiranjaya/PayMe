import 'package:flutter/material.dart';

class StripeRegRefresh_Screen extends StatelessWidget {
  const StripeRegRefresh_Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stripe Setup'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Your Stripe onboarding link has expired.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Please generate a new onboarding link and continue the setup.',
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () {
                  // Call backend here
                  // Generate a new Stripe onboarding URL
                },
                child: const Text('Continue Stripe Setup'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}