import 'package:flutter/material.dart';
import 'package:client/services/Onboard_Storage_Service.dart';

class Login_Screen extends StatefulWidget {
  const Login_Screen({super.key});

  @override
  State<Login_Screen> createState() => _Login_Screen_State();
}

class _Login_Screen_State extends State<Login_Screen> {
  Future<void> resetOnboardingStatus() async {
    await OnboardStorageService().resetOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {

            const pagePadding = EdgeInsets.all(20);
            final availableHeight = constraints.maxHeight - pagePadding.vertical;

            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Padding(
                padding: pagePadding,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: availableHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        // Title section: 1/3
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text('Welcome to the app!'),
                              SizedBox(height: 20),
                              Text('Login Screen'),
                            ],
                          ),
                        ),

                        // Form section: 2/3
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'NIC Number',
                                  hintText: 'Enter your NIC number',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              TextField(
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  hintText: 'Enter your password',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 10),

                              Align(
                                alignment: Alignment.centerLeft,
                                child: GestureDetector(
                                  onTap: () {
                                    // Go to forgot-password page
                                  },
                                  child: const Text(
                                    'Forgot password?',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Login
                                  },
                                  child: const Text('Login'),
                                ),
                              ),

                              const SizedBox(height: 20),

                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    resetOnboardingStatus();
                                  },
                                  child: const Text('Reset onboarding'),
                                ),
                              ),

                              const Spacer(),

                              Align(
                                alignment: Alignment.center,
                                child: GestureDetector(
                                  onTap: () {
                                    // Go to registration page
                                  },
                                  child: const Text(
                                    'Do not have an account? Sign up',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
