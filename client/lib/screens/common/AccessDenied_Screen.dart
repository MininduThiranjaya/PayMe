import 'package:client/providers/AuthProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccessDenied_Screen extends StatelessWidget {
  const AccessDenied_Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Access Denied'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.lock_outline,
                  size: 64,
                ),

                const SizedBox(height: 16),

                const Text(
                  'This page is not available for your active profile.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 20),

                ElevatedButton.icon(
                  onPressed: () async {
                    await authProvider.clearActiveRole();

                    if (!context.mounted) return;

                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/select/role',
                      (route) => false,
                    );
                  },
                  icon: const Icon(
                    Icons.switch_account_outlined,
                  ),
                  label: const Text('Switch Profile'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}