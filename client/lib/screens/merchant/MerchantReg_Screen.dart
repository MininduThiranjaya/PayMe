// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import 'package:url_launcher/url_launcher.dart';
// // import 'package:client/services/Register_Service.dart';
// // import 'package:client/models/UserRegister.dart';

// // class _ShopFormEntry {
// //   final TextEditingController shopNameController = TextEditingController();
// //   final TextEditingController addressController = TextEditingController();

// //   void dispose() {
// //     shopNameController.dispose();
// //     addressController.dispose();
// //   }
// // }

// // class MerchantReg_Screen extends StatefulWidget {
// //   const MerchantReg_Screen({super.key});

// //   @override
// //   State<MerchantReg_Screen> createState() => _MerchantReg_Screen_State();
// // }

// // class _MerchantReg_Screen_State extends State<MerchantReg_Screen> {
// //   final _formKey = GlobalKey<FormState>();
// //   final userNameController = TextEditingController();
// //   final nicController = TextEditingController();
// //   final passwordController = TextEditingController();
// //   final confirmPasswordController = TextEditingController();

// //   // Always start with one shop - at least one is required.
// //   final List<_ShopFormEntry> _shopEntries = [_ShopFormEntry()];

// //   @override
// //   void dispose() {
// //     userNameController.dispose();
// //     nicController.dispose();
// //     passwordController.dispose();
// //     confirmPasswordController.dispose();
// //     for (final entry in _shopEntries) {
// //       entry.dispose();
// //     }
// //     super.dispose();
// //   }

// //   String? _validateNic(String? value) {
// //     if (value == null || value.trim().isEmpty) return 'NIC is required';
// //     final nic = value.trim();
// //     final oldFormat = RegExp(r'^\d{9}[vVxX]$');
// //     final newFormat = RegExp(r'^\d{12}$');
// //     if (!oldFormat.hasMatch(nic) && !newFormat.hasMatch(nic)) {
// //       return 'Enter a valid NIC number';
// //     }
// //     return null;
// //   }

// //   void _addShopEntry() {
// //     setState(() {
// //       _shopEntries.add(_ShopFormEntry());
// //     });
// //   }

// //   void _removeShopEntry(int index) {
// //     if (_shopEntries.length == 1) return; // must keep at least one shop
// //     setState(() {
// //       _shopEntries[index].dispose();
// //       _shopEntries.removeAt(index);
// //     });
// //   }

// //   Future<void> _launchStripeOnboarding(String url) async {
// //     final uri = Uri.tryParse(url);
// //     if (uri == null) return;
// //     if (await canLaunchUrl(uri)) {
// //       await launchUrl(uri, mode: LaunchMode.externalApplication);
// //     }
// //   }

// //   Future<void> _submit() async {
// //     FocusScope.of(context).unfocus();
// //     if (!_formKey.currentState!.validate()) return;

// //     final shops = _shopEntries
// //         .map((e) => ShopRequestDto(
// //               shopName: e.shopNameController.text.trim(),
// //               address: e.addressController.text.trim(),
// //             ))
// //         .toList();

// //     final registerProvider = context.read<RegisterProvider>();
// //     final result = await registerProvider.registerMerchant(
// //       userName: userNameController.text.trim(),
// //       nic: nicController.text.trim(),
// //       password: passwordController.text,
// //       shops: shops,
// //     );

// //     if (!mounted) return;

// //     if (result == null) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content:
// //               Text(registerProvider.errorMessage ?? 'Registration failed'),
// //         ),
// //       );
// //       return;
// //     }

// //     // resData had stripeAccountId/stripeOnboardingURL/merchantStatus/shops
// //     // -> send the merchant to Stripe onboarding instead of back to login.
// //     if (result.stripeOnboardingURL != null &&
// //         result.stripeOnboardingURL!.isNotEmpty) {
// //       await _launchStripeOnboarding(result.stripeOnboardingURL!);
// //     }

// //     if (!mounted) return;
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       const SnackBar(content: Text('Merchant account created.')),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final isRegistering = context.watch<RegisterProvider>().isRegistering;

// //     return Scaffold(
// //       appBar: AppBar(title: const Text('Merchant Registration')),
// //       body: SafeArea(
// //         child: SingleChildScrollView(
// //           padding: const EdgeInsets.all(20),
// //           child: Form(
// //             key: _formKey,
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.stretch,
// //               children: [
// //                 TextFormField(
// //                   controller: userNameController,
// //                   textInputAction: TextInputAction.next,
// //                   decoration: const InputDecoration(
// //                     labelText: 'User Name',
// //                     border: OutlineInputBorder(),
// //                   ),
// //                   validator: (v) => (v == null || v.trim().isEmpty)
// //                       ? 'User name is required'
// //                       : null,
// //                 ),
// //                 const SizedBox(height: 16),
// //                 TextFormField(
// //                   controller: nicController,
// //                   textInputAction: TextInputAction.next,
// //                   decoration: const InputDecoration(
// //                     labelText: 'NIC Number',
// //                     border: OutlineInputBorder(),
// //                   ),
// //                   validator: _validateNic,
// //                 ),
// //                 const SizedBox(height: 16),
// //                 TextFormField(
// //                   controller: passwordController,
// //                   obscureText: true,
// //                   textInputAction: TextInputAction.next,
// //                   decoration: const InputDecoration(
// //                     labelText: 'Password',
// //                     border: OutlineInputBorder(),
// //                   ),
// //                   validator: (v) {
// //                     if (v == null || v.isEmpty) return 'Password is required';
// //                     if (v.length < 6) return 'At least 6 characters';
// //                     return null;
// //                   },
// //                 ),
// //                 const SizedBox(height: 16),
// //                 TextFormField(
// //                   controller: confirmPasswordController,
// //                   obscureText: true,
// //                   textInputAction: TextInputAction.next,
// //                   decoration: const InputDecoration(
// //                     labelText: 'Confirm Password',
// //                     border: OutlineInputBorder(),
// //                   ),
// //                   validator: (v) {
// //                     if (v != passwordController.text) {
// //                       return 'Passwords do not match';
// //                     }
// //                     return null;
// //                   },
// //                 ),
// //                 const SizedBox(height: 24),
// //                 const Align(
// //                   alignment: Alignment.centerLeft,
// //                   child: Text(
// //                     'Shops',
// //                     style:
// //                         TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// //                   ),
// //                 ),
// //                 const SizedBox(height: 8),
// //                 ListView.builder(
// //                   shrinkWrap: true,
// //                   physics: const NeverScrollableScrollPhysics(),
// //                   itemCount: _shopEntries.length,
// //                   itemBuilder: (context, index) {
// //                     final entry = _shopEntries[index];
// //                     return Padding(
// //                       padding: const EdgeInsets.only(bottom: 16),
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.stretch,
// //                         children: [
// //                           Row(
// //                             children: [
// //                               Expanded(
// //                                 child: Text(
// //                                   'Shop ${index + 1}',
// //                                   style: const TextStyle(
// //                                       fontWeight: FontWeight.w600),
// //                                 ),
// //                               ),
// //                               if (_shopEntries.length > 1)
// //                                 IconButton(
// //                                   icon:
// //                                       const Icon(Icons.remove_circle_outline),
// //                                   onPressed: () => _removeShopEntry(index),
// //                                 ),
// //                             ],
// //                           ),
// //                           TextFormField(
// //                             controller: entry.shopNameController,
// //                             textInputAction: TextInputAction.next,
// //                             decoration: const InputDecoration(
// //                               labelText: 'Shop Name',
// //                               border: OutlineInputBorder(),
// //                             ),
// //                             validator: (v) => (v == null || v.trim().isEmpty)
// //                                 ? 'Shop name is required'
// //                                 : null,
// //                           ),
// //                           const SizedBox(height: 12),
// //                           TextFormField(
// //                             controller: entry.addressController,
// //                             textInputAction: TextInputAction.next,
// //                             decoration: const InputDecoration(
// //                               labelText: 'Shop Address',
// //                               border: OutlineInputBorder(),
// //                             ),
// //                             validator: (v) => (v == null || v.trim().isEmpty)
// //                                 ? 'Address is required'
// //                                 : null,
// //                           ),
// //                         ],
// //                       ),
// //                     );
// //                   },
// //                 ),
// //                 Align(
// //                   alignment: Alignment.centerLeft,
// //                   child: TextButton.icon(
// //                     onPressed: _addShopEntry,
// //                     icon: const Icon(Icons.add),
// //                     label: const Text('Add another shop'),
// //                   ),
// //                 ),
// //                 const SizedBox(height: 16),
// //                 ElevatedButton(
// //                   onPressed: isRegistering ? null : _submit,
// //                   child: isRegistering
// //                       ? const SizedBox(
// //                           width: 20,
// //                           height: 20,
// //                           child: CircularProgressIndicator(strokeWidth: 2),
// //                         )
// //                       : const Padding(
// //                           padding: EdgeInsets.symmetric(vertical: 12),
// //                           child: Text('Register'),
// //                         ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:client/config/DioClient.dart';
// import 'package:client/services/Register_Service.dart';
// import 'package:client/models/UserRegister.dart';

// class _ShopFormEntry {
//   final TextEditingController shopNameController = TextEditingController();
//   final TextEditingController addressController = TextEditingController();

//   void dispose() {
//     shopNameController.dispose();
//     addressController.dispose();
//   }
// }

// class MerchantReg_Screen extends StatefulWidget {
//   const MerchantReg_Screen({super.key});

//   @override
//   State<MerchantReg_Screen> createState() => _MerchantReg_Screen_State();
// }

// class _MerchantReg_Screen_State extends State<MerchantReg_Screen> {
//   final _formKey = GlobalKey<FormState>();
//   final userNameController = TextEditingController();
//   final nicController = TextEditingController();
//   final passwordController = TextEditingController();
//   final confirmPasswordController = TextEditingController();

//   // Always start with one shop - at least one is required.
//   final List<_ShopFormEntry> _shopEntries = [_ShopFormEntry()];

//   late final Register_Service _registerService;

//   bool _isRegistering = false;
//   String? _errorMessage;

//   @override
//   void initState() {
//     super.initState();
//     _registerService = Register_Service(dioClient: context.read<DioClient>());
//   }

//   @override
//   void dispose() {
//     userNameController.dispose();
//     nicController.dispose();
//     passwordController.dispose();
//     confirmPasswordController.dispose();
//     for (final entry in _shopEntries) {
//       entry.dispose();
//     }
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

//   void _addShopEntry() {
//     setState(() {
//       _shopEntries.add(_ShopFormEntry());
//     });
//   }

//   void _removeShopEntry(int index) {
//     if (_shopEntries.length == 1) return; // must keep at least one shop
//     setState(() {
//       _shopEntries[index].dispose();
//       _shopEntries.removeAt(index);
//     });
//   }

//   Future<void> _launchStripeOnboarding(String url) async {
//     final uri = Uri.tryParse(url);
//     if (uri == null) return;
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     }
//   }

//   Future<void> _submit() async {
//     FocusScope.of(context).unfocus();
//     if (!_formKey.currentState!.validate()) return;

//     final shops = _shopEntries
//         .map((e) => ShopRequestDto(
//               shopName: e.shopNameController.text.trim(),
//               address: e.addressController.text.trim(),
//             ))
//         .toList();

//     setState(() {
//       _isRegistering = true;
//       _errorMessage = null;
//     });

//     try {
//       final result = await _registerService.registerMerchant(
//         userName: userNameController.text.trim(),
//         nic: nicController.text.trim(),
//         password: passwordController.text,
//         shops: shops,
//       );

//       if (!mounted) return;

//       // resData had stripeAccountId/stripeOnboardingURL/shops
//       // -> send the merchant to Stripe onboarding instead of back to login.
//       if (result.stripeOnboardingURL != null &&
//           result.stripeOnboardingURL!.isNotEmpty) {
//         await _launchStripeOnboarding(result.stripeOnboardingURL!);
//       }

//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Merchant account created.')),
//       );
//     } catch (e) {
//       if (!mounted) return;
//       setState(() {
//         _errorMessage = e.toString().replaceFirst('Exception: ', '');
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(_errorMessage ?? 'Registration failed')),
//       );
//     } finally {
//       if (mounted) {
//         setState(() => _isRegistering = false);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Merchant Registration')),
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
//                   textInputAction: TextInputAction.next,
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
//                 const Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text(
//                     'Shops',
//                     style:
//                         TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 ListView.builder(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: _shopEntries.length,
//                   itemBuilder: (context, index) {
//                     final entry = _shopEntries[index];
//                     return Padding(
//                       padding: const EdgeInsets.only(bottom: 16),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   'Shop ${index + 1}',
//                                   style: const TextStyle(
//                                       fontWeight: FontWeight.w600),
//                                 ),
//                               ),
//                               if (_shopEntries.length > 1)
//                                 IconButton(
//                                   icon:
//                                       const Icon(Icons.remove_circle_outline),
//                                   onPressed: () => _removeShopEntry(index),
//                                 ),
//                             ],
//                           ),
//                           TextFormField(
//                             controller: entry.shopNameController,
//                             textInputAction: TextInputAction.next,
//                             decoration: const InputDecoration(
//                               labelText: 'Shop Name',
//                               border: OutlineInputBorder(),
//                             ),
//                             validator: (v) => (v == null || v.trim().isEmpty)
//                                 ? 'Shop name is required'
//                                 : null,
//                           ),
//                           const SizedBox(height: 12),
//                           TextFormField(
//                             controller: entry.addressController,
//                             textInputAction: TextInputAction.next,
//                             decoration: const InputDecoration(
//                               labelText: 'Shop Address',
//                               border: OutlineInputBorder(),
//                             ),
//                             validator: (v) => (v == null || v.trim().isEmpty)
//                                 ? 'Address is required'
//                                 : null,
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: TextButton.icon(
//                     onPressed: _addShopEntry,
//                     icon: const Icon(Icons.add),
//                     label: const Text('Add another shop'),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: _isRegistering ? null : _submit,
//                   child: _isRegistering
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
import 'package:url_launcher/url_launcher.dart';
import 'package:client/providers/RegistrationProvider.dart';

class _ShopFormEntry {
  final TextEditingController shopNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  void dispose() {
    shopNameController.dispose();
    addressController.dispose();
  }
}

class MerchantReg_Screen extends StatefulWidget {
  const MerchantReg_Screen({super.key});

  @override
  State<MerchantReg_Screen> createState() => _MerchantReg_Screen_State();
}

class _MerchantReg_Screen_State extends State<MerchantReg_Screen> {
  final _formKey = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final nicController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Always start with one shop - at least one is required.
  final List<_ShopFormEntry> _shopEntries = [_ShopFormEntry()];

  @override
  void dispose() {
    userNameController.dispose();
    nicController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    for (final entry in _shopEntries) {
      entry.dispose();
    }

    super.dispose();
  }

  String? _validateNic(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'NIC is required';
    }

    final nic = value.trim();

    final oldFormat = RegExp(r'^\d{9}[vVxX]$');
    final newFormat = RegExp(r'^\d{12}$');

    if (!oldFormat.hasMatch(nic) &&
        !newFormat.hasMatch(nic)) {
      return 'Enter a valid NIC number';
    }

    return null;
  }

  void _addShopEntry() {
    setState(() {
      _shopEntries.add(_ShopFormEntry());
    });
  }

  void _removeShopEntry(int index) {
    if (_shopEntries.length == 1) {
      return;
    }

    setState(() {
      _shopEntries[index].dispose();
      _shopEntries.removeAt(index);
    });
  }

  Future<void> _launchStripeOnboarding(
    String url,
  ) async {
    final uri = Uri.tryParse(url);

    if (uri == null) {
      return;
    }

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    // ==============================
    // Build shop names separately
    // ==============================

    final List<String> shopNames =
        _shopEntries
            .map(
              (entry) =>
                  entry.shopNameController.text.trim(),
            )
            .toList();

    // ==============================
    // Build addresses separately
    // ==============================

    final List<String> addresses =
        _shopEntries
            .map(
              (entry) =>
                  entry.addressController.text.trim(),
            )
            .toList();

    final registrationProvider =
        context.read<RegistrationProvider>();

    final result =
        await registrationProvider.registerMerchant(
      userName:
          userNameController.text.trim(),

      nic:
          nicController.text.trim(),

      password:
          passwordController.text,

      shopNames:
          shopNames,

      addresses:
          addresses,
    );

    if (!mounted) {
      return;
    }

    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            registrationProvider.errorMessage ??
                'Merchant registration failed',
          ),
        ),
      );

      return;
    }

    final onboardingUrl =
        result.stripeOnboardingURL;

    if (onboardingUrl != null &&
        onboardingUrl.isNotEmpty) {
      await _launchStripeOnboarding(
        onboardingUrl,
      );
    }

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Merchant account created.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isRegistering =
        context
            .watch<RegistrationProvider>()
            .isRegistering;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Merchant Registration',
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.stretch,

              children: [
                TextFormField(
                  controller:
                      userNameController,

                  textInputAction:
                      TextInputAction.next,

                  decoration:
                      const InputDecoration(
                    labelText: 'User Name',
                    border:
                        OutlineInputBorder(),
                  ),

                  validator: (v) =>
                      (v == null ||
                              v.trim().isEmpty)
                          ? 'User name is required'
                          : null,
                ),

                const SizedBox(
                  height: 16,
                ),

                TextFormField(
                  controller:
                      nicController,

                  textInputAction:
                      TextInputAction.next,

                  decoration:
                      const InputDecoration(
                    labelText: 'NIC Number',
                    border:
                        OutlineInputBorder(),
                  ),

                  validator:
                      _validateNic,
                ),

                const SizedBox(
                  height: 16,
                ),

                TextFormField(
                  controller:
                      passwordController,

                  obscureText: true,

                  textInputAction:
                      TextInputAction.next,

                  decoration:
                      const InputDecoration(
                    labelText: 'Password',
                    border:
                        OutlineInputBorder(),
                  ),

                  validator: (v) {
                    if (v == null ||
                        v.isEmpty) {
                      return 'Password is required';
                    }

                    if (v.length < 6) {
                      return 'At least 6 characters';
                    }

                    return null;
                  },
                ),

                const SizedBox(
                  height: 16,
                ),

                TextFormField(
                  controller:
                      confirmPasswordController,

                  obscureText: true,

                  textInputAction:
                      TextInputAction.next,

                  decoration:
                      const InputDecoration(
                    labelText:
                        'Confirm Password',
                    border:
                        OutlineInputBorder(),
                  ),

                  validator: (v) {
                    if (v !=
                        passwordController.text) {
                      return 'Passwords do not match';
                    }

                    return null;
                  },
                ),

                const SizedBox(
                  height: 24,
                ),

                const Align(
                  alignment:
                      Alignment.centerLeft,

                  child: Text(
                    'Shops',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),

                ListView.builder(
                  shrinkWrap: true,

                  physics:
                      const NeverScrollableScrollPhysics(),

                  itemCount:
                      _shopEntries.length,

                  itemBuilder:
                      (context, index) {
                    final entry =
                        _shopEntries[index];

                    return Padding(
                      padding:
                          const EdgeInsets.only(
                        bottom: 16,
                      ),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .stretch,

                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Shop ${index + 1}',
                                  style:
                                      const TextStyle(
                                    fontWeight:
                                        FontWeight
                                            .w600,
                                  ),
                                ),
                              ),

                              if (_shopEntries
                                      .length >
                                  1)
                                IconButton(
                                  icon: const Icon(
                                    Icons
                                        .remove_circle_outline,
                                  ),

                                  onPressed: () =>
                                      _removeShopEntry(
                                    index,
                                  ),
                                ),
                            ],
                          ),

                          TextFormField(
                            controller:
                                entry
                                    .shopNameController,

                            textInputAction:
                                TextInputAction
                                    .next,

                            decoration:
                                const InputDecoration(
                              labelText:
                                  'Shop Name',

                              border:
                                  OutlineInputBorder(),
                            ),

                            validator: (v) =>
                                (v == null ||
                                        v
                                            .trim()
                                            .isEmpty)
                                    ? 'Shop name is required'
                                    : null,
                          ),

                          const SizedBox(
                            height: 12,
                          ),

                          TextFormField(
                            controller:
                                entry
                                    .addressController,

                            textInputAction:
                                TextInputAction
                                    .next,

                            decoration:
                                const InputDecoration(
                              labelText:
                                  'Shop Address',

                              border:
                                  OutlineInputBorder(),
                            ),

                            validator: (v) =>
                                (v == null ||
                                        v
                                            .trim()
                                            .isEmpty)
                                    ? 'Address is required'
                                    : null,
                          ),
                        ],
                      ),
                    );
                  },
                ),

                Align(
                  alignment:
                      Alignment.centerLeft,

                  child: TextButton.icon(
                    onPressed:
                        _addShopEntry,

                    icon:
                        const Icon(
                      Icons.add,
                    ),

                    label:
                        const Text(
                      'Add another shop',
                    ),
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),

                ElevatedButton(
                  onPressed:
                      isRegistering
                          ? null
                          : _submit,

                  child: isRegistering
                      ? const SizedBox(
                          width: 20,
                          height: 20,

                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Padding(
                          padding:
                              EdgeInsets
                                  .symmetric(
                            vertical: 12,
                          ),

                          child:
                              Text(
                            'Register',
                          ),
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
