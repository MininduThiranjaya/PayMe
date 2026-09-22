import 'package:client/providers/AuthProvider.dart';
import 'package:client/providers/CustomerOrderProvider.dart';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

class OrderQrScanner_Screen
    extends StatefulWidget {
  const OrderQrScanner_Screen({
    super.key,
  });

  @override
  State<OrderQrScanner_Screen>
      createState() =>
          _OrderQrScanner_ScreenState();
}

class _OrderQrScanner_ScreenState
    extends State<OrderQrScanner_Screen> {
  final MobileScannerController
      _scannerController =
      MobileScannerController();

  bool _handledScan = false;

  Future<void> _handleBarcode(
    BarcodeCapture capture,
  ) async {
    if (_handledScan) {
      return;
    }

    if (capture.barcodes.isEmpty) {
      return;
    }

    final rawValue =
        capture.barcodes.first.rawValue;

    if (rawValue == null ||
        rawValue.isEmpty) {
      return;
    }

    _handledScan = true;

    await _scannerController.stop();

    if (!mounted) return;

    final token =
        context
            .read<AuthProvider>()
            .token;

    if (token == null ||
        token.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Authentication token was not found.',
          ),
        ),
      );

      _handledScan = false;

      await _scannerController.start();

      return;
    }

    final orderProvider =
        context.read<
            CustomerOrderProvider>();

    final order =
        await orderProvider
            .scanAndClaimOrder(
      token: token,
      qrData: rawValue,
    );

    if (!mounted) return;

    if (order == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            orderProvider
                    .errorMessage ??
                'Unable to scan order',
          ),
        ),
      );

      orderProvider.allowNewScan();

      _handledScan = false;

      await _scannerController.start();

      return;
    }

    // Scanner can now close.
    Navigator.of(context).pop(
      order,
    );
  }

  @override
  void dispose() {
    _scannerController.dispose();

    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        title:
            const Text(
          'Scan Order QR',
        ),
      ),

      body: Stack(
        children: [
          MobileScanner(
            controller:
                _scannerController,
            onDetect:
                _handleBarcode,
          ),

          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration:
                  BoxDecoration(
                border:
                    Border.all(
                  color:
                      Colors.white,
                  width: 3,
                ),
                borderRadius:
                    BorderRadius
                        .circular(
                  20,
                ),
              ),
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 40,
            child:
                const Text(
              'Point the camera at the PayMe QR code',
              textAlign:
                  TextAlign.center,
              style:
                  TextStyle(
                color:
                    Colors.white,
                fontSize: 15,
                fontWeight:
                    FontWeight
                        .w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}