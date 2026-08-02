import 'package:client/guard/AuthGuard.dart';
import 'package:client/screens/common/UserDashboard_Screen.dart';
import 'package:client/screens/splash_screen/Splash_Screen.dart';
import 'package:client/screens/common/introScreens/Intro_Screen.dart';
import 'package:client/screens/common/Login_Screen.dart';

class Approutes {

  static final appRoutes = {
    "/": (context) =>  const Splash_Screen(),
    "/introScreen": (context) =>  const Intro_Screen(),
    "/loginScreen": (context) =>  const Login_Screen(),
    // auth
    '/auth': (context) => const AuthGuard(child: UserDashboard_Screen()),
    // auth routes
    // "/dashboard": (context) => const AuthGuard(child: UserDashboard_Screen())
  };
}