import 'dart:convert';

import 'package:client/services/SellProduct_Service.dart';
import 'package:flutter/material.dart';

class SellProductProvider
    extends ChangeNotifier {

  final SellProduct_Service sellProductService;

  SellProductProvider({
    required this.sellProductService,
  });

  bool _isGeneratingQr = false;

  String? _errorMessage;
  int? _orderId;
  String? _qrData;
  DateTime? _generatedAt;

  bool get isGeneratingQr =>
      _isGeneratingQr;

  String? get errorMessage =>
      _errorMessage;

  int? get orderId =>
      _orderId;

  String? get qrData =>
      _qrData;

  DateTime? get generatedAt =>
      _generatedAt;

  Future<String?> generateOrderQr({
    required String token,
    required List<Map<String, dynamic>>
        orderItems,
  }) async {
    _isGeneratingQr = true;
    _errorMessage = null;

    notifyListeners();

    try {
      // 1. Create order in backend first
      final orderId =
          await sellProductService
              .createNewOrder(
        token: token,
        orderItems: orderItems,
      );

      // 2. Backend successfully returned order id
      final generatedAt =
          DateTime.now().toUtc();

      // 3. Create QR content
      final qrPayload = {
        'orderId': orderId,
        'createdAt':
            generatedAt.toIso8601String(),
      };

      final qrData =
          jsonEncode(qrPayload);

      _orderId = orderId;
      _generatedAt = generatedAt;
      _qrData = qrData;

      return qrData;
    } catch (error) {
      _errorMessage = error
          .toString()
          .replaceFirst(
            'Exception: ',
            '',
          );

      return null;
    } finally {
      _isGeneratingQr = false;

      notifyListeners();
    }
  }

  void clearOrder() {
    _orderId = null;
    _qrData = null;
    _generatedAt = null;
    _errorMessage = null;

    notifyListeners();
  }
}