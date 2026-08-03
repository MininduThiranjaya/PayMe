import 'package:client/enum/AuthStatus.dart';
import 'package:client/models/UserProfile.dart';
import 'package:client/services/Login_Service.dart';
import 'package:client/storage/Role_Storage.dart';
import 'package:client/storage/Token_Storage.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {

  final Login_Service loginService;
  final Token_Storage tokenStorage;
  final Role_Storage roleStorage;

  AuthProvider({
    required this.loginService,
    required this.tokenStorage,
    required this.roleStorage
  });

  String ? _token;
  UserProfile ? _profile;
  bool _isLoging = false;
  String? _errorMessage;
  String? _activeRole;
  AuthStatus _authStatus = AuthStatus.initializing;

  String? get token => _token;
  UserProfile? get profile => _profile;
  bool get isLoging => _isLoging;
  String? get errorMessage => _errorMessage;
  String? get activeRole => _activeRole;
  AuthStatus get authStatus => _authStatus;

  bool get isLoading {
    return _authStatus == AuthStatus.initializing;
  }

  bool get isAuthenticated {
    return _authStatus == AuthStatus.authenticated;
  }

   bool get needsRoleSelection {
    return _authStatus == AuthStatus.roleSelectionRequired;
  }

  List<String> get roles {
    final profileRoles = _profile?.roles ?? <String>[];
    return profileRoles
      .map((role) => role.toString().toUpperCase())
      .toSet()
      .toList();
  }

  bool hasRole(String role) {
    return roles.contains(role.toUpperCase());
  }

  bool isWorkingAs(String role) {
    return _activeRole == role.toUpperCase();
  }

  Future<void> resolveActiveRole() async {

    // no role
    if(roles.isEmpty) {
      _activeRole = null;
      _errorMessage = 'Account role fetching error';
      _authStatus = AuthStatus.unauthenticated;
      return;
    }
    // single role 
    if(roles.length == 1) {
      _activeRole = roles.first;
      await roleStorage.setActiveRole(_activeRole!);
      _authStatus = AuthStatus.authenticated;
      return;
    }
    // multiple roles
    final savedRole = await roleStorage.getActiveRole();
    final normalizedSavedRole = savedRole?.toUpperCase();
    if(normalizedSavedRole != null && roles.contains(normalizedSavedRole)) {
      _activeRole =normalizedSavedRole;
      _authStatus = AuthStatus.authenticated;
      return;
    }
    // have multiple roles but do not have valid role
    _activeRole = null;
    _authStatus = AuthStatus.roleSelectionRequired;
  }

  Future<void> clearActiveRole() async {

    _activeRole = null;
    _authStatus = AuthStatus.roleSelectionRequired;
    await roleStorage.removeActiveRole();
    notifyListeners();
  }

  Future<bool> login({required String nic, required String password}) async {
    _isLoging = true;
    _authStatus = AuthStatus.initializing;
    _errorMessage = null;
    notifyListeners();
    try{

      final loginResponse = await loginService.login(nic: nic, password: password);
      if (loginResponse.isEmpty) {

        _authStatus = AuthStatus.unauthenticated;
        return false;
      }
      _token = loginResponse;
      await tokenStorage.setToken(_token!);
      // Load the profile before returning.
      _profile = await loginService.getCurrentUserPrrofile(token: _token!);
      await resolveActiveRole();
      return _authStatus == AuthStatus.authenticated ||
          _authStatus == AuthStatus.roleSelectionRequired;
    } catch(error) {

      _token = null;
      _profile = null;
      _activeRole = null;
      _errorMessage = error.toString();
      _authStatus = AuthStatus.unauthenticated;
      return false;
    } finally {

      _isLoging = false;
      notifyListeners();
    }
  }

   Future<void> getMe() async {

    _authStatus = AuthStatus.initializing;
    _errorMessage = null;
    notifyListeners();
    try {

      _token = await tokenStorage.getToken();
      if (_token == null || _token!.isEmpty) {
        clearSession();
        return;
      }
      _profile = await loginService.getCurrentUserPrrofile(token: _token!);
      
      await resolveActiveRole();
    } catch (error) {

      await tokenStorage.removeToken();
      clearSession();
      _errorMessage = error.toString();
    } finally {

      notifyListeners();
    }
  }

  void clearSession() {

    _token = null;
    _profile = null;
    _activeRole = null;
    _authStatus = AuthStatus.unauthenticated;
  }

  Future<void> selectRole(String role) async {

    final normalizedRole = role.toUpperCase();
    if(!roles.contains(normalizedRole)) {

      throw StateError(
        'This user does not have the $normalizedRole role.',
      );
    }
    _activeRole = normalizedRole;
    await roleStorage.setActiveRole(normalizedRole);
    _authStatus = AuthStatus.authenticated;
    notifyListeners();
  }

  Future<void> logout() async {

    await tokenStorage.removeToken();
     _token = null;
    _profile = null;
    _activeRole = null;
    _errorMessage = null;
    _authStatus = AuthStatus.unauthenticated;
    notifyListeners();
  }

}