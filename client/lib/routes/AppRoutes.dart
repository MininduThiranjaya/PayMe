import 'package:client/screens/splash_screen/Splash_Screen.dart';
import 'package:client/screens/common/introScreens/Intro_Screen.dart';
import 'package:client/screens/common/Login_Screen.dart';

class Approutes {

  static final appRoutes = {
    "/": (context) =>  const Splash_Screen(),
    "/introScreen": (context) =>  const Intro_Screen(),
    "/loginScreen": (context) =>  const Login_Screen(),
  };
}