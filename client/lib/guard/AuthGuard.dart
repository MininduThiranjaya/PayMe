import 'package:client/enum/AuthStatus.dart';
import 'package:client/providers/AuthProvider.dart';
import 'package:client/screens/common/AccessDenied_Screen.dart';
import 'package:client/screens/common/Login_Screen.dart';
import 'package:client/screens/common/RoleSelection_Screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;

  /// Leave null for pages available to every authenticated user.
  final Set<String>? allowedRoles;

  const AuthGuard({super.key, required this.child, this.allowedRoles});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    switch (authProvider.authStatus) {
      case AuthStatus.initializing:
        return const Scaffold(
          body: SafeArea(child: Center(child: CircularProgressIndicator())),
        );

      case AuthStatus.unauthenticated:
        return const Login_Screen();

      case AuthStatus.roleSelectionRequired:
        return const RoleSelection_Screen();

      case AuthStatus.authenticated:
        return buildAuthenticatedContent(authProvider);
    }
  }

  Widget buildAuthenticatedContent(AuthProvider authProvider) {
    // no role restriction: any authenticated user can enter.
    if (allowedRoles == null || allowedRoles!.isEmpty) {
      return child;
    }

    final activeRole = authProvider.activeRole?.toUpperCase();

    final normalizedAllowedRoles = allowedRoles!
        .map((role) => role.toUpperCase())
        .toSet();

    if (activeRole == null) {
      return const RoleSelection_Screen();
    }

    if (!normalizedAllowedRoles.contains(activeRole)) {
      return const AccessDenied_Screen();
    }

    return child;
  }
}
