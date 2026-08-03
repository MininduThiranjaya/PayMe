import 'package:client/config/DioClient.dart';
import 'package:client/providers/AuthProvider.dart';
import 'package:client/services/Login_Service.dart';
import 'package:client/storage/Role_Storage.dart';
import 'package:client/storage/Token_Storage.dart';
import 'package:flutter/material.dart';
import 'package:client/routes/AppRoutes.dart';
import 'package:provider/provider.dart';

void main() {

  final dio = DioClient();
  runApp(
    ChangeNotifierProvider(
      lazy: false,
      create: (_) => AuthProvider(
        loginService: Login_Service(dioClient: dio),
        tokenStorage: Token_Storage(),
        roleStorage: Role_Storage()
      )..getMe(),
      child: const MyApp()
    )  
  );
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