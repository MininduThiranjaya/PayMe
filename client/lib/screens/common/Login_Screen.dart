import 'package:flutter/material.dart';
import 'package:client/services/Onboard_Storage_Service.dart';

class Login_Screen extends StatefulWidget{

  const Login_Screen({super.key});

  @override
  State<Login_Screen> createState() => _Login_Screen_State();
}

class _Login_Screen_State extends State<Login_Screen>{

  Future<void> resetOnboardingStatus() async {
    await OnboardStorageService().resetOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
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
                Expanded(
                  flex:2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextField(
                        decoration: 
                          InputDecoration(
                            labelText: 'Nic Number',
                            hintText: 'Enter your nic number',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))
                          ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        decoration: 
                          InputDecoration(
                            labelText: 'Password',
                            hintText: 'Enter your password',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))
                          ),
                          obscureText: true,
                      ),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: InkWell(
                          onTap: () {
                            // 
                          },
                          overlayColor: WidgetStateProperty.resolveWith<Color?>(
                            (states) => Colors.transparent,
                          ),
                          child: Text('Forget password ?', style: TextStyle(color: Colors.blue)),
                        ),
                      ),
                      SizedBox(height: 20),
                      FloatingActionButton(
                        onPressed: () {
                          // 
                        },
                        child: Text('Login')
                      ),
                      SizedBox(height: 20),
                      FloatingActionButton(
                        onPressed: () {
                          resetOnboardingStatus();
                        },
                        child: Text('reset onboarding')
                      ),
                      Spacer(),
                      Align(
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: () {
                            // 
                          },
                          overlayColor: WidgetStateProperty.resolveWith<Color?>(
                            (state) => Colors.transparent
                          ),
                          child: Text('Do not have an account ? Sign up', style: TextStyle(color: Colors.blue))
                        )
                      )
                    ]
                  )
                )
              ],
            ),
          )
        )
      )
    );
  }
}