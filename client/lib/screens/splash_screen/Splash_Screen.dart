// import 'package:flutter/material.dart';
// import 'package:client/storage/Onboard_Storage.dart';

// class Splash_Screen extends StatefulWidget {

//   const Splash_Screen({super.key});

//   @override
//   State<Splash_Screen> createState() => _Splash_Screen_State();
// }

// class _Splash_Screen_State extends State<Splash_Screen> {

//   @override
//   initState() {
//     super.initState();
//     checkOnboardingStatus();
//   }

//   Future<void> checkOnboardingStatus() async {
//     final bool hasSeenOnboarding = await Onboard_Storage().hasSeenOnboarding();
//     if (!mounted) return;
//     if (hasSeenOnboarding) {
//       Navigator.pushNamedAndRemoveUntil(context, '/auth', (route) => false);
//     } else {
//       Navigator.pushNamedAndRemoveUntil(context, '/introScreen', (route) => false);
//     }
//   }

//   @override
//   Widget build(BuildContext buildContext) {
//     return Scaffold(
//       body: SafeArea(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: const [
//               CircularProgressIndicator(),
//               SizedBox(height: 20),
//               Text('PayMe'),
//             ],
//           ),
//         )
//       )
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:client/storage/Onboard_Storage.dart';

class Splash_Screen extends StatefulWidget {
  const Splash_Screen({super.key});

  @override
  State<Splash_Screen> createState() =>
      _Splash_Screen_State();
}

class _Splash_Screen_State
    extends State<Splash_Screen> {

  @override
  void initState() {
    super.initState();

    checkOnboardingStatus();
  }

  Future<void> checkOnboardingStatus() async {

    // Current Flutter Web hash route
    final currentRoute = Uri.base.fragment;

    debugPrint(
      'Current browser route: $currentRoute',
    );

    // Stripe callback pages should NOT be
    // redirected by the splash screen.
    if (currentRoute.startsWith(
          '/merchant/stripe/reg/success',
        ) ||
        currentRoute.startsWith(
          '/merchant/stripe/reg/refresh',
        )) {

      debugPrint(
        'Stripe callback detected - '
        'skipping splash redirect',
      );

      return;
    }

    final bool hasSeenOnboarding =
        await Onboard_Storage()
            .hasSeenOnboarding();

    if (!mounted) {
      return;
    }

    if (hasSeenOnboarding) {

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/auth',
        (route) => false,
      );

    } else {

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/introScreen',
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),

              SizedBox(
                height: 20,
              ),

              Text('PayMe'),
            ],
          ),
        ),
      ),
    );
  }
}