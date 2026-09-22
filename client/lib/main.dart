import 'package:client/config/DioClient.dart';
import 'package:client/providers/AuthProvider.dart';
import 'package:client/providers/RegistrationProvider.dart';
import 'package:client/providers/SellProductProvider.dart';
import 'package:client/providers/CustomerOrderProvider.dart';
import 'package:client/services/Login_Service.dart';
import 'package:client/services/Register_Service.dart';
import 'package:client/services/CustomerOrder_Service.dart';
import 'package:client/services/SellProduct_Service.dart';
import 'package:client/storage/Role_Storage.dart';
import 'package:client/storage/Token_Storage.dart';
import 'package:flutter/material.dart';
import 'package:client/routes/AppRoutes.dart';
import 'package:provider/provider.dart';

void main() {

  final dio = DioClient();
  final loginService = Login_Service(dioClient: dio);
  final registerService = Register_Service(dioClient: dio);
  final sellProductService = SellProduct_Service(dioClient: dio);
  final customerOrderService = CustomerOrder_Service(dioClient: dio);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          lazy: false,
          create: (_) => AuthProvider(
            loginService: loginService,
            tokenStorage: Token_Storage(),
            roleStorage: Role_Storage(),
          )..getMe(),
        ),

        ChangeNotifierProvider(
          create: (_) => RegistrationProvider(
            registerService: registerService,
          ),
        ),

        ChangeNotifierProvider(
          create: (_) =>
              SellProductProvider(
            sellProductService:
                sellProductService,
          ),
        ),

        ChangeNotifierProvider(
          create: (_) =>
              CustomerOrderProvider(
            customerOrderService:
                customerOrderService,
          ),
        ),
      ],
      child: const MyApp(),
    ),
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
      // initialRoute: '/',
      routes: Approutes.appRoutes,
    );
  }
}