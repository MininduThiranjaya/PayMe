import 'package:client/providers/AuthProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class SwitchRoleButton_Widget extends StatelessWidget {

  const SwitchRoleButton_Widget({super.key});
  @override
  Widget build(BuildContext context) {

    final authProvider = context.read<AuthProvider>();
    final roleCount = authProvider.roles.length;
    if (roleCount != 2) {
      return const SizedBox.shrink();
    }
    return ElevatedButton.icon(
      onPressed: () async {
        await authProvider.clearActiveRole();

        if (!context.mounted) return;

        Navigator.pushNamedAndRemoveUntil(
          context,
          '/select/role',
          (route) => false,
        );
      },
      icon: const Icon(Icons.switch_account_outlined),
      label: const Text('Switch Profile'),
    );
  }
}
