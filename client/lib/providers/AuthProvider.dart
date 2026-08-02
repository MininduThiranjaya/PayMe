import 'package:client/models/UserProfile.dart';
import 'package:client/services/Login_Service.dart';
import 'package:client/storage/Token_Storage.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {

  final Login_Service loginService;
  final Token_Storage tokenStorage;

  AuthProvider({
    required this.loginService,
    required this.tokenStorage,
  });

  String ? _token;
  UserProfile ? _profile;
  bool _isLoading = false;
  String? _errorMessage;

  String? get token => _token;
  UserProfile? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool get isAuthenticated {
    print(_token);
    print(_profile);
    print("_profile");
    return _token != null && _token!.isNotEmpty && _profile != null;
  }

  Future<bool> login({required String nic, required String password}) async {
    
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try{
      final loginResponse = await loginService.login(nic: nic, password: password);
      _token = loginResponse;
      if(_token != null && _token!.isNotEmpty) {
        await tokenStorage.setToken(_token!);
        getMe();
        return true;
      }
      else {
        return false;
      }
    } catch(error) {
      _token = null;
      _errorMessage = error.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

   Future<void> getMe() async {
    _isLoading = true;
    notifyListeners();

    try {
      _token = await tokenStorage.getToken();
      if (_token != null && _token!.isNotEmpty) {
        final profileResponse = await loginService.getCurrentUserPrrofile(token: _token!);
        _profile = profileResponse;
      }
    } catch (error) {
      _token = null;
      _profile = null;
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await tokenStorage.removeToken();

    _token = null;
    _profile = null;
    _errorMessage = null;

    notifyListeners();
  }

}