// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:client/services/Register_Service.dart';

// class CustomerReg_Screen extends StatefulWidget {
//   const CustomerReg_Screen({super.key});

//   @override
//   State<CustomerReg_Screen> createState() =>
//       _CustomerReg_Screen_State();
// }

// class _CustomerReg_Screen_State extends State<CustomerReg_Screen> {
//   final _formKey = GlobalKey<FormState>();
//   final userNameController = TextEditingController();
//   final nicController = TextEditingController();
//   final passwordController = TextEditingController();
//   final confirmPasswordController = TextEditingController();

//   @override
//   void dispose() {
//     userNameController.dispose();
//     nicController.dispose();
//     passwordController.dispose();
//     confirmPasswordController.dispose();
//     super.dispose();
//   }

//   String? _validateNic(String? value) {
//     if (value == null || value.trim().isEmpty) return 'NIC is required';
//     final nic = value.trim();
//     final oldFormat = RegExp(r'^\d{9}[vVxX]$');
//     final newFormat = RegExp(r'^\d{12}$');
//     if (!oldFormat.hasMatch(nic) && !newFormat.hasMatch(nic)) {
//       return 'Enter a valid NIC number';
//     }
//     return null;
//   }

//   Future<void> _submit() async {
//     FocusScope.of(context).unfocus();
//     if (!_formKey.currentState!.validate()) return;

//     final registerProvider = context.read<RegisterProvider>();
//     final result = await registerProvider.registerCustomer(
//       userName: userNameController.text.trim(),
//       nic: nicController.text.trim(),
//       password: passwordController.text,
//     );

//     if (!mounted) return;

//     if (result == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content:
//               Text(registerProvider.errorMessage ?? 'Registration failed'),
//         ),
//       );
//       return;
//     }

//     // status == true and resData had nic/userName/roles -> back to login.
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Account created. Please log in.')),
//     );
//     Navigator.popUntil(context, (route) => route.isFirst);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isRegistering = context.watch<RegisterProvider>().isRegistering;

//     return Scaffold(
//       appBar: AppBar(title: const Text('Customer Registration')),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(20),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 TextFormField(
//                   controller: userNameController,
//                   textInputAction: TextInputAction.next,
//                   decoration: const InputDecoration(
//                     labelText: 'User Name',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (v) => (v == null || v.trim().isEmpty)
//                       ? 'User name is required'
//                       : null,
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: nicController,
//                   textInputAction: TextInputAction.next,
//                   decoration: const InputDecoration(
//                     labelText: 'NIC Number',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: _validateNic,
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: passwordController,
//                   obscureText: true,
//                   textInputAction: TextInputAction.next,
//                   decoration: const InputDecoration(
//                     labelText: 'Password',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (v) {
//                     if (v == null || v.isEmpty) return 'Password is required';
//                     if (v.length < 6) return 'At least 6 characters';
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: confirmPasswordController,
//                   obscureText: true,
//                   textInputAction: TextInputAction.done,
//                   decoration: const InputDecoration(
//                     labelText: 'Confirm Password',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (v) {
//                     if (v != passwordController.text) {
//                       return 'Passwords do not match';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 24),
//                 ElevatedButton(
//                   onPressed: isRegistering ? null : _submit,
//                   child: isRegistering
//                       ? const SizedBox(
//                           width: 20,
//                           height: 20,
//                           child: CircularProgressIndicator(strokeWidth: 2),
//                         )
//                       : const Padding(
//                           padding: EdgeInsets.symmetric(vertical: 12),
//                           child: Text('Register'),
//                         ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:client/providers/RegistrationProvider.dart';

class CustomerReg_Screen extends StatefulWidget {
  const CustomerReg_Screen({super.key});

  @override
  State<CustomerReg_Screen> createState() => _CustomerReg_Screen_State();
}

class _CustomerReg_Screen_State extends State<CustomerReg_Screen> {
  final _formKey = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final nicController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    userNameController.dispose();
    nicController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateNic(String? value) {
    if (value == null || value.trim().isEmpty) return 'NIC is required';
    final nic = value.trim();
    final oldFormat = RegExp(r'^\d{9}[vVxX]$');
    final newFormat = RegExp(r'^\d{12}$');
    if (!oldFormat.hasMatch(nic) && !newFormat.hasMatch(nic)) {
      return 'Enter a valid NIC number';
    }
    return null;
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final registrationProvider = context.read<RegistrationProvider>();

    final result = await registrationProvider.registerCustomer(
      userName: userNameController.text.trim(),
      nic: nicController.text.trim(),
      password: passwordController.text,
    );

    if (!mounted) {
      return;
    }

    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            registrationProvider.errorMessage ?? 'Registration failed',
          ),
        ),
      );

      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account created. Please log in.')),
    );

    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final isRegistering = context.watch<RegistrationProvider>().isRegistering;
    return Scaffold(
      appBar: AppBar(title: const Text('Customer Registration')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: userNameController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'User Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'User name is required'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: nicController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'NIC Number',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateNic,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Password is required';
                    if (v.length < 6) return 'At least 6 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    if (v != passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: isRegistering ? null : _submit,

                  child: isRegistering
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text('Register'),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
