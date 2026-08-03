import 'package:shared_preferences/shared_preferences.dart';

class Role_Storage {

  final String activeRole = 'activeRole';
  final SharedPreferencesAsync preferences = SharedPreferencesAsync();

  Future<void> setActiveRole(String role) async {
    await preferences.setString(activeRole, role);
  }

  Future<String?> getActiveRole() async {
    return await preferences.getString(activeRole);
  }

  Future<void> removeActiveRole() async {
    return await preferences.remove(activeRole);
  }
}