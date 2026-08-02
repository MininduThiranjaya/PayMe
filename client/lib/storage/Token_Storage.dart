import 'package:shared_preferences/shared_preferences.dart';

class Token_Storage {

  final String authToken = "authToken";
  final SharedPreferencesAsync preferences = SharedPreferencesAsync();
  
  Future<void> setToken(String token) async {
    await preferences.setString(authToken, token);
  }

  Future<String?> getToken() async {
    return await preferences.getString(authToken);
  }

  Future<void> removeToken() async {
    await preferences.remove(authToken);
  }
}