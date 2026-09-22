import 'dart:convert';

import 'package:client/models/ClaimedOrder.dart';
import 'package:client/services/CustomerOrder_Service.dart';

import 'package:flutter/material.dart';

class CustomerOrderProvider
    extends ChangeNotifier {
  final CustomerOrder_Service
      customerOrderService;

  CustomerOrderProvider({
    required this.customerOrderService,
  });

  bool _isClaiming = false;

  bool _isProcessingScan = false;

  String? _errorMessage;

  ClaimedOrder? _claimedOrder;

  bool get isClaiming =>
      _isClaiming;

  bool get isProcessingScan =>
      _isProcessingScan;

  String? get errorMessage =>
      _errorMessage;

  ClaimedOrder? get claimedOrder =>
      _claimedOrder;

  Future<ClaimedOrder?> scanAndClaimOrder({
    required String token,
    required String qrData,
  }) async {
    // Prevent camera from processing
    // the same QR many times.
    if (_isProcessingScan) {
      return null;
    }

    _isProcessingScan = true;
    _isClaiming = true;
    _errorMessage = null;

    notifyListeners();

    try {
      final decoded =
          jsonDecode(qrData);

      if (decoded
          is! Map<String, dynamic>) {
        throw Exception(
          'Invalid PayMe QR code',
        );
      }

      final orderIdValue =
          decoded['orderId'];

      if (orderIdValue == null) {
        throw Exception(
          'Order id was not found in QR code',
        );
      }

      final int orderId;

      if (orderIdValue is int) {
        orderId = orderIdValue;
      } else if (orderIdValue is num) {
        orderId =
            orderIdValue.toInt();
      } else {
        orderId =
            int.tryParse(
                  orderIdValue.toString(),
                ) ??
                0;
      }

      if (orderId <= 0) {
        throw Exception(
          'Invalid order id in QR code',
        );
      }

      final order =
          await customerOrderService
              .claimOrder(
        token: token,
        orderId: orderId,
      );

      _claimedOrder = order;

      return order;
    } catch (error) {
      _claimedOrder = null;

      _errorMessage =
          error
              .toString()
              .replaceFirst(
                'Exception: ',
                '',
              );

      return null;
    } finally {
      _isClaiming = false;

      notifyListeners();
    }
  }

  void allowNewScan() {
    _isProcessingScan = false;

    notifyListeners();
  }

  void clearClaimedOrder() {
    _claimedOrder = null;
    _errorMessage = null;
    _isProcessingScan = false;

    notifyListeners();
  }
}