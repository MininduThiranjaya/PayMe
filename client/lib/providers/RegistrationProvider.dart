import 'package:client/models/UserRegister.dart';
import 'package:client/services/Register_Service.dart';
import 'package:flutter/material.dart';

class RegistrationProvider extends ChangeNotifier {
  final Register_Service registerService;

  RegistrationProvider({
    required this.registerService,
  });

  bool _isRegistering = false;
  String? _errorMessage;

  bool get isRegistering => _isRegistering;
  String? get errorMessage => _errorMessage;

  Future<RegisterResponseData?> registerCustomer({
    required String userName,
    required String nic,
    required String password,
  }) async {
    _startRegistration();

    try {
      final result = await registerService.registerCustomer(
        userName: userName,
        nic: nic,
        password: password,
      );

      return result;
    } catch (error) {
      _errorMessage = _cleanError(error);
      return null;
    } finally {
      _finishRegistration();
    }
  }

  Future<MerchantRegisterResponseData?> registerMerchant({
  required String userName,
  required String nic,
  required String password,
  required List<String> shopNames,
  required List<String> addresses,
}) async {
  _isRegistering = true;
  _errorMessage = null;
  notifyListeners();

  try {
    final response = await registerService.registerMerchant(
      userName: userName,
      nic: nic,
      password: password,
      shopNames: shopNames,
      addresses: addresses,
    );

    return response;
  } catch (error) {
    _errorMessage =
        error.toString().replaceFirst('Exception: ', '');

    return null;
  } finally {
    _isRegistering = false;
    notifyListeners();
  }
}

  void _startRegistration() {
    _isRegistering = true;
    _errorMessage = null;
    notifyListeners();
  }

  void _finishRegistration() {
    _isRegistering = false;
    notifyListeners();
  }

  String _cleanError(Object error) {
    return error
        .toString()
        .replaceFirst('Exception: ', '');
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}