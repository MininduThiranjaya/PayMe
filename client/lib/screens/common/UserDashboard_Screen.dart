import 'package:client/providers/AuthProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserDashboard_Screen extends StatefulWidget {
  const UserDashboard_Screen({super.key});

  @override
  State<UserDashboard_Screen> createState() =>
      _UserDashboard_ScreenState();
}

class _UserDashboard_ScreenState extends State<UserDashboard_Screen> {
  String? _scheduledRoute;

  @override
  Widget build(BuildContext context) {
    final activeRole = context.select<AuthProvider, String?>(
      (provider) => provider.activeRole,
    );

    final String targetRoute;

    switch (activeRole) {
      case 'CUSTOMER':
        targetRoute = '/customer/dashboard';
        break;

      case 'MERCHANT':
        targetRoute = '/merchant/dashboard';
        break;

      default:
        targetRoute = '/select/role';
    }

    if (_scheduledRoute != targetRoute) {
      _scheduledRoute = targetRoute;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }

        Navigator.pushReplacementNamed(
          context,
          targetRoute,
        );
      });
    }

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}