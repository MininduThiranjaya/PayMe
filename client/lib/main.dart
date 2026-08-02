import 'package:flutter/material.dart';
import 'package:client/screens/splash_screen/Splash_Screen.dart';
import 'package:client/routes/AppRoutes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      routes: Approutes.appRoutes,
    );
  }
}