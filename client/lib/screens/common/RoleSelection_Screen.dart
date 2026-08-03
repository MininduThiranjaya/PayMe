import 'package:client/providers/AuthProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoleSelection_Screen extends StatelessWidget {
  const RoleSelection_Screen({super.key});

  Future<void> selectRole(BuildContext context, String role) async {
    final authProvider = context.read<AuthProvider>();
    try {
      await authProvider.selectRole(role);
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/dashboard',
        (route) => false,
      );
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final hasCustomerRole = authProvider.hasRole('CUSTOMER');
    final hasMerchantRole = authProvider.hasRole('MERCHANT');
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // white page background
            const Positioned.fill(child: ColoredBox(color: Colors.white)),
            // dark overlay behind the section card
            Positioned.fill(
              child: Container(color: Colors.black.withValues(alpha: 0.20)),
            ),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Card(
                    elevation: 12,
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.primaryContainer,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.switch_account_outlined,
                              size: 34,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),

                          const SizedBox(height: 20),

                          const Text(
                            'Continue with a profile',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          const Text(
                            'Select which profile you want to use. '
                            'You can switch profiles later.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                              height: 1.4,
                            ),
                          ),

                          const SizedBox(height: 28),

                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: OutlinedButton.icon(
                              onPressed: hasCustomerRole
                                  ? () => selectRole(context, 'CUSTOMER')
                                  : null,
                              icon: const Icon(Icons.person_outline),
                              label: const Text('Continue as Customer'),
                            ),
                          ),

                          const SizedBox(height: 12),

                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton.icon(
                              onPressed: hasMerchantRole
                                  ? () => selectRole(context, 'MERCHANT')
                                  : null,
                              icon: const Icon(Icons.storefront_outlined),
                              label: const Text('Continue as Merchant'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
