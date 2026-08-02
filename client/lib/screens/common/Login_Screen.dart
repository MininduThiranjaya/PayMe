import 'package:flutter/material.dart';
import 'package:client/storage/Onboard_Storage.dart';
import 'package:client/providers/AuthProvider.dart';
import 'package:provider/provider.dart';

class Login_Screen extends StatefulWidget {
  const Login_Screen({super.key});

  @override
  State<Login_Screen> createState() => _Login_Screen_State();
}

class _Login_Screen_State extends State<Login_Screen> {
  final TextEditingController nicController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  Future<void> login() async {
    FocusScope.of(context).unfocus();

    final String nic = nicController.text.trim();

    final String password = passwordController.text;

    if (nic.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('All fields are required')));

      return;
    }

    final authProvider = context.read<AuthProvider>();

    final success = await authProvider.login(nic: nic, password: password);

    if (!mounted) return;

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authProvider.errorMessage ?? 'Login failed')),
      );
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/dashboard',
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    nicController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  Future<void> resetOnboardingStatus() async {
    await Onboard_Storage().resetOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            const pagePadding = EdgeInsets.all(20);
            final availableHeight =constraints.maxHeight - pagePadding.vertical;
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
                                controller: nicController,
                                textInputAction: TextInputAction.next,
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
                                controller: passwordController,
                                textInputAction: TextInputAction.done,
                                onSubmitted: (_) {
                                  if (!isLoading) {
                                    login();
                                  }
                                },
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
                                    isLoading ? null : login();
                                  },
                                  child: isLoading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text('Login'),
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
