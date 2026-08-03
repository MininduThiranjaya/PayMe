import 'package:client/guard/AuthGuard.dart';
import 'package:client/screens/common/RoleSelection_Screen.dart';
import 'package:client/screens/common/UserDashboard_Screen.dart';
import 'package:client/screens/customer/CustomerDashboard_Screen.dart';
import 'package:client/screens/merchant/MerchantDashboard_Screen.dart';
import 'package:client/screens/splash_screen/Splash_Screen.dart';
import 'package:client/screens/common/introScreens/Intro_Screen.dart';
import 'package:client/screens/common/Login_Screen.dart';

class Approutes {

  static final appRoutes = {
    "/": (context) =>  const Splash_Screen(),
    "/introScreen": (context) =>  const Intro_Screen(),
    "/loginScreen": (context) =>  const Login_Screen(),
    // role selection
    '/select/role': (context) => const AuthGuard(child: RoleSelection_Screen()),
    // auth
    '/auth': (context) => const AuthGuard(child: UserDashboard_Screen()),
    // customer auth route
    "/customer/dashboard": (context) => const AuthGuard(allowedRoles: {'CUSTOMER'}, child: CustomerDashboard_Screen()),
    // merchant auth route
    "/merchant/dashboard": (context) => const AuthGuard(allowedRoles: {'MERCHANT'}, child: MerchantDashboard_Screen())
  };
}