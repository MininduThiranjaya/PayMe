import 'package:shared_preferences/shared_preferences.dart';

class Onboard_Storage {

  final String onboardedKey = "onboarded";
  final SharedPreferencesAsync preferences = SharedPreferencesAsync();

  Future<bool> hasSeenOnboarding() async {
    return await preferences.getBool(onboardedKey) ?? false;
  }

  Future<void> completeOnboarding() async {
    return await preferences.setBool(onboardedKey, true);
  }

  Future<void> resetOnboarding() async {
    return await preferences.setBool(onboardedKey, false);
  }
}