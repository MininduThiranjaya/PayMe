import 'package:client/providers/AuthProvider.dart';
import 'package:client/screens/common/Login_Screen.dart';
import 'package:client/screens/common/UserDashboard_Screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthGuard extends StatelessWidget{

  final Widget child;
  const AuthGuard({
    super.key,
    required this.child
  });
  
  @override
  Widget build(BuildContext context) {
    
    final authProvider = context.watch<AuthProvider>();
    if(authProvider.isLoading) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: CircularProgressIndicator(),
          )
        ),
      );
    }
    
    if(!authProvider.isAuthenticated) {
      return const Login_Screen();
    }

    return child;
  }
}