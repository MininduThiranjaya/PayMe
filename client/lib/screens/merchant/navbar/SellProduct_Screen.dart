import 'package:client/providers/AuthProvider.dart';
import 'package:client/providers/SellProductProvider.dart';
import 'package:client/widget/common/DashboardCard_Widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class _OrderItem {
  _OrderItem({
    required this.name,
    required this.quantity,
    required this.unit,
    required this.price,
  });

  final String name;
  final int quantity;
  final String unit;
  final int price;

  int get total => quantity * price;
}

class SellProduct_Screen extends StatefulWidget {
  const SellProduct_Screen({
    super.key,
  });

  @override
  State<SellProduct_Screen> createState() =>
      _SellProduct_Screen_State();
}

class _SellProduct_Screen_State
    extends State<SellProduct_Screen> {
  static const List<String> _units = [
    'KG',
    'G',
    'ITEM',
  ];

  final TextEditingController _nameController =
      TextEditingController();

  final TextEditingController _quantityController =
      TextEditingController();

  final TextEditingController _priceController =
      TextEditingController();

  String _selectedUnit = 'KG';

  int? _editingIndex;

  final List<_OrderItem> _addedItems = [];

  bool get _isFormValid {
    final name =
        _nameController.text.trim();

    final quantity =
        int.tryParse(
          _quantityController.text.trim(),
        ) ??
        0;

    final price =
        int.tryParse(
          _priceController.text.trim(),
        ) ??
        0;

    return name.isNotEmpty &&
        quantity > 0 &&
        price > 0;
  }

  int get _grandTotal {
    return _addedItems.fold(
      0,
      (sum, item) =>
          sum + item.total,
    );
  }

  void _clearForm() {
    _nameController.clear();
    _quantityController.clear();
    _priceController.clear();

    _selectedUnit = 'KG';
    _editingIndex = null;
  }

  void _addOrUpdateItem() {
    if (!_isFormValid) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Fill in item name, quantity and price.',
          ),
        ),
      );

      return;
    }

    final item = _OrderItem(
      name:
          _nameController.text.trim(),
      quantity:
          int.parse(
        _quantityController.text.trim(),
      ),
      unit: _selectedUnit,
      price:
          int.parse(
        _priceController.text.trim(),
      ),
    );

    setState(() {
      if (_editingIndex != null) {
        _addedItems[_editingIndex!] =
            item;
      } else {
        _addedItems.add(item);
      }

      _clearForm();
    });
  }

  void _deleteItem(
    int index,
  ) {
    setState(() {
      _addedItems.removeAt(
        index,
      );

      if (_editingIndex == index) {
        _clearForm();
      } else if (_editingIndex != null &&
          index < _editingIndex!) {
        _editingIndex =
            _editingIndex! - 1;
      }
    });
  }

  void _loadItemIntoForm(
    int index,
  ) {
    final item =
        _addedItems[index];

    setState(() {
      _nameController.text =
          item.name;

      _quantityController.text =
          item.quantity.toString();

      _priceController.text =
          item.price.toString();

      _selectedUnit =
          item.unit;

      _editingIndex =
          index;
    });
  }

  // ============================================================
  // BUILD ORDER ITEMS
  //
  // Merchant NIC is NOT sent from Flutter.
  // Backend extracts merchant NIC from JWT subject.
  // ============================================================

  List<Map<String, dynamic>>
      _buildOrderItems() {
    return _addedItems
        .map(
          (item) => {
            'itemName':
                item.name,
            'quantity':
                item.quantity,
            'itemMetric':
                item.unit,
            'unitPrice':
                item.price,
          },
        )
        .toList();
  }

  // ============================================================
  // GENERATE QR
  //
  // 1. Get JWT
  // 2. Send items to backend
  // 3. Backend creates order
  // 4. Backend returns orderId
  // 5. Provider adds current time
  // 6. Provider generates QR data
  // 7. Show QR
  // 8. After dialog closes, clear frontend order state
  // ============================================================

  Future<void> _generateQrCode()
      async {
    if (_addedItems.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Add at least one item before generating a QR code.',
          ),
        ),
      );

      return;
    }

    final authProvider =
        context.read<AuthProvider>();

    final token =
        authProvider.token;

    if (token == null ||
        token.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Authentication token not found. Please login again.',
          ),
        ),
      );

      return;
    }

    final orderItems =
        _buildOrderItems();

    final sellProductProvider =
        context.read<
            SellProductProvider>();

    final qrData =
        await sellProductProvider
            .generateOrderQr(
      token: token,
      orderItems: orderItems,
    );

    if (!mounted) {
      return;
    }

    if (qrData == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            sellProductProvider
                    .errorMessage ??
                'Unable to create order.',
          ),
        ),
      );

      return;
    }

    final orderId =
        sellProductProvider.orderId;

    final generatedAt =
        sellProductProvider
            .generatedAt;

    if (orderId == null ||
        generatedAt == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Order was created but QR information is invalid.',
          ),
        ),
      );

      return;
    }

    // Save these before clearing frontend state.
    final itemCount =
        _addedItems.length;

    final totalAmount =
        _grandTotal;

    // Show QR and wait until merchant closes it.
    await _showQrDialog(
      qrData: qrData,
      orderId: orderId,
      generatedAt:
          generatedAt,
      itemCount:
          itemCount,
      totalAmount:
          totalAmount,
    );

    if (!mounted) {
      return;
    }

    // ========================================================
    // ORDER COMPLETED ON FRONTEND
    // Clear current frontend order data.
    // ========================================================

    setState(() {
      _addedItems.clear();
      _clearForm();
    });

    // Clear provider's temporary QR/order state.
    sellProductProvider.clearOrder();
  }

  // ============================================================
  // QR DIALOG
  //
  // qrData is used ONLY by QrImageView.
  // Raw QR JSON is NOT displayed to merchant.
  // ============================================================

  Future<void> _showQrDialog({
    required String qrData,
    required int orderId,
    required DateTime generatedAt,
    required int itemCount,
    required int totalAmount,
  }) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (
        dialogContext,
      ) {
        return Dialog(
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              16,
            ),
          ),
          child:
              ConstrainedBox(
            constraints:
                const BoxConstraints(
              maxWidth: 400,
              maxHeight: 600,
            ),
            child:
                SingleChildScrollView(
              padding:
                  const EdgeInsets.all(
                20,
              ),
              child: Column(
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Order QR Code',
                          style:
                              TextStyle(
                            fontSize:
                                18,
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),
                      ),

                      IconButton(
                        onPressed: () {
                          Navigator.of(
                            dialogContext,
                          ).pop();
                        },
                        icon:
                            const Icon(
                          Icons.close,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  // ==========================
                  // QR CODE
                  // ==========================

                  Container(
                    width: 220,
                    height: 220,
                    padding:
                        const EdgeInsets
                            .all(
                      10,
                    ),
                    decoration:
                        BoxDecoration(
                      color:
                          Colors.white,
                      borderRadius:
                          BorderRadius
                              .circular(
                        12,
                      ),
                      border:
                          Border.all(
                        color:
                            Colors.grey
                                .shade300,
                      ),
                    ),
                    child:
                        QrImageView(
                      data: qrData,
                      version:
                          QrVersions
                              .auto,
                      size: 200,
                      backgroundColor:
                          Colors.white,
                    ),
                  ),

                  const SizedBox(
                    height: 18,
                  ),

                  // ==========================
                  // ORDER ID
                  // ==========================

                  Text(
                    'Order #$orderId',
                    style:
                        const TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight
                              .bold,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  // ==========================
                  // TOTAL
                  // ==========================

                  Text(
                    'Rs. ${totalAmount.toStringAsFixed(2)}',
                    style:
                        const TextStyle(
                      fontSize: 17,
                      fontWeight:
                          FontWeight
                              .w700,
                    ),
                  ),

                  const SizedBox(
                    height: 6,
                  ),

                  // ==========================
                  // ITEM COUNT
                  // ==========================

                  Text(
                    '$itemCount item(s)',
                    style:
                        TextStyle(
                      fontSize: 13,
                      color:
                          Colors.grey[
                              600],
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  // ==========================
                  // CREATED TIME
                  // ==========================

                  Text(
                    'Created: ${_formatDateTime(generatedAt.toLocal())}',
                    textAlign:
                        TextAlign.center,
                    style:
                        TextStyle(
                      fontSize: 12,
                      color:
                          Colors.grey[
                              600],
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  // ==========================
                  // CLOSE BUTTON
                  // ==========================

                  SizedBox(
                    width:
                        double.infinity,
                    child:
                        ElevatedButton(
                      onPressed: () {
                        Navigator.of(
                          dialogContext,
                        ).pop();
                      },
                      child:
                          const Text(
                        'Close',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatDateTime(
    DateTime dateTime,
  ) {
    String twoDigits(
      int value,
    ) {
      return value
          .toString()
          .padLeft(
            2,
            '0',
          );
    }

    return '${dateTime.year}-'
        '${twoDigits(dateTime.month)}-'
        '${twoDigits(dateTime.day)} '
        '${twoDigits(dateTime.hour)}:'
        '${twoDigits(dateTime.minute)}:'
        '${twoDigits(dateTime.second)}';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();

    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final primaryContainer =
        Theme.of(context)
            .colorScheme
            .primaryContainer;

    final isEditing =
        _editingIndex != null;

    final sellProductProvider =
        context.watch<
            SellProductProvider>();

    final isGeneratingQr =
        sellProductProvider
            .isGeneratingQr;

    return Scaffold(
      backgroundColor:
          const Color(
        0xFFF3F4F6,
      ),
      resizeToAvoidBottomInset:
          true,
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.all(
            20,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment
                    .start,
            children: [
              const Text(
                'Sell Product',
                style:
                    TextStyle(
                  fontSize: 18,
                  fontWeight:
                      FontWeight
                          .w700,
                ),
              ),

              const SizedBox(
                height: 14,
              ),

              // ==================================================
              // ITEM ENTRY
              // ==================================================

              Expanded(
                flex: 4,
                child:
                    DashboardCard_Widget(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,
                        children: [
                          const Text(
                            'Item Details',
                            style:
                                TextStyle(
                              fontSize:
                                  15,
                              fontWeight:
                                  FontWeight
                                      .w600,
                            ),
                          ),

                          if (isEditing)
                            Container(
                              padding:
                                  const EdgeInsets
                                      .symmetric(
                                horizontal:
                                    10,
                                vertical:
                                    4,
                              ),
                              decoration:
                                  BoxDecoration(
                                color:
                                    primaryContainer,
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  20,
                                ),
                              ),
                              child:
                                  Text(
                                'Editing item ${_editingIndex! + 1}',
                                style:
                                    const TextStyle(
                                  fontSize:
                                      11.5,
                                  fontWeight:
                                      FontWeight
                                          .w600,
                                ),
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(
                        height: 12,
                      ),

                      TextField(
                        controller:
                            _nameController,
                        enabled:
                            !isGeneratingQr,
                        onChanged: (_) =>
                            setState(
                          () {},
                        ),
                        decoration:
                            _fieldDecoration(
                          'Item Name',
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child:
                                TextField(
                              controller:
                                  _quantityController,
                              enabled:
                                  !isGeneratingQr,
                              onChanged:
                                  (_) =>
                                      setState(
                                () {},
                              ),
                              keyboardType:
                                  TextInputType
                                      .number,
                              inputFormatters: [
                                FilteringTextInputFormatter
                                    .digitsOnly,
                              ],
                              decoration:
                                  _fieldDecoration(
                                'Quantity',
                              ),
                            ),
                          ),

                          const SizedBox(
                            width: 10,
                          ),

                          Expanded(
                            flex: 2,
                            child:
                                DropdownButtonFormField<
                                    String>(
                              value:
                                  _selectedUnit,
                              decoration:
                                  _fieldDecoration(
                                'Unit',
                              ),
                              items:
                                  _units
                                      .map(
                                (
                                  unit,
                                ) {
                                  return DropdownMenuItem<
                                      String>(
                                    value:
                                        unit,
                                    child:
                                        Text(
                                      unit,
                                    ),
                                  );
                                },
                              ).toList(),
                              onChanged:
                                  isGeneratingQr
                                      ? null
                                      : (
                                          value,
                                        ) {
                                          if (value ==
                                              null) {
                                            return;
                                          }

                                          setState(
                                            () {
                                              _selectedUnit =
                                                  value;
                                            },
                                          );
                                        },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      TextField(
                        controller:
                            _priceController,
                        enabled:
                            !isGeneratingQr,
                        onChanged: (_) =>
                            setState(
                          () {},
                        ),
                        keyboardType:
                            TextInputType
                                .number,
                        inputFormatters: [
                          FilteringTextInputFormatter
                              .digitsOnly,
                        ],
                        decoration:
                            _fieldDecoration(
                          'Unit Price',
                        ).copyWith(
                          prefixText:
                              'Rs. ',
                        ),
                      ),

                      const Spacer(),

                      Row(
                        children: [
                          if (isEditing) ...[
                            Expanded(
                              child:
                                  OutlinedButton(
                                onPressed:
                                    isGeneratingQr
                                        ? null
                                        : () {
                                            setState(
                                              _clearForm,
                                            );
                                          },
                                style:
                                    OutlinedButton
                                        .styleFrom(
                                  padding:
                                      const EdgeInsets
                                          .symmetric(
                                    vertical:
                                        12,
                                  ),
                                  shape:
                                      RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                      10,
                                    ),
                                  ),
                                ),
                                child:
                                    const Text(
                                  'Cancel',
                                ),
                              ),
                            ),

                            const SizedBox(
                              width: 10,
                            ),
                          ],

                          Expanded(
                            flex: 2,
                            child:
                                ElevatedButton
                                    .icon(
                              onPressed:
                                  _isFormValid &&
                                          !isGeneratingQr
                                      ? _addOrUpdateItem
                                      : null,
                              icon:
                                  Icon(
                                isEditing
                                    ? Icons
                                        .check
                                    : Icons
                                        .add,
                                size: 18,
                              ),
                              label:
                                  Text(
                                isEditing
                                    ? 'Update Item'
                                    : 'Add Item',
                              ),
                              style:
                                  ElevatedButton
                                      .styleFrom(
                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                  vertical:
                                      12,
                                ),
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    10,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 16,
              ),

              // ==================================================
              // ORDER SUMMARY
              // ==================================================

              Expanded(
                flex: 5,
                child:
                    DashboardCard_Widget(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      const Text(
                        'Order Summary',
                        style:
                            TextStyle(
                          fontSize: 15,
                          fontWeight:
                              FontWeight
                                  .w600,
                        ),
                      ),

                      const SizedBox(
                        height: 12,
                      ),

                      Expanded(
                        child:
                            SingleChildScrollView(
                          scrollDirection:
                              Axis.horizontal,
                          child:
                              SizedBox(
                            width:
                                _tableWidth,
                            child:
                                Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                _summaryHeaderRow(),

                                const SizedBox(
                                  height: 8,
                                ),

                                const Divider(
                                  height: 1,
                                ),

                                const SizedBox(
                                  height: 4,
                                ),

                                Expanded(
                                  child:
                                      _addedItems
                                              .isEmpty
                                          ? Center(
                                              child:
                                                  Text(
                                                'No items added yet',
                                                style:
                                                    TextStyle(
                                                  color:
                                                      Colors.grey[500],
                                                ),
                                              ),
                                            )
                                          : ListView
                                              .separated(
                                              padding:
                                                  const EdgeInsets
                                                      .symmetric(
                                                vertical:
                                                    6,
                                              ),
                                              itemCount:
                                                  _addedItems.length,
                                              separatorBuilder:
                                                  (
                                                _,
                                                __,
                                              ) =>
                                                      const Divider(
                                                height:
                                                    1,
                                              ),
                                              itemBuilder:
                                                  (
                                                context,
                                                index,
                                              ) =>
                                                      _summaryRow(
                                                index,
                                                isGeneratingQr,
                                              ),
                                            ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const Divider(
                        height: 1,
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,
                        children: [
                          const Text(
                            'Total Amount',
                            style:
                                TextStyle(
                              fontSize:
                                  14,
                              fontWeight:
                                  FontWeight
                                      .w600,
                            ),
                          ),

                          Text(
                            'Rs. ${_grandTotal.toStringAsFixed(2)}',
                            style:
                                const TextStyle(
                              fontSize:
                                  16,
                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 16,
              ),

              // ==================================================
              // GENERATE QR
              // ==================================================

              SizedBox(
                width:
                    double.infinity,
                height: 50,
                child:
                    ElevatedButton.icon(
                  onPressed:
                      isGeneratingQr ||
                              _addedItems
                                  .isEmpty
                          ? null
                          : _generateQrCode,

                  icon:
                      isGeneratingQr
                          ? const SizedBox(
                              width:
                                  18,
                              height:
                                  18,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth:
                                    2,
                              ),
                            )
                          : const Icon(
                              Icons
                                  .qr_code_2,
                            ),

                  label:
                      Text(
                    isGeneratingQr
                        ? 'Creating Order...'
                        : 'Generate QR Code',
                    style:
                        const TextStyle(
                      fontWeight:
                          FontWeight
                              .w600,
                    ),
                  ),

                  style:
                      ElevatedButton
                          .styleFrom(
                    backgroundColor:
                        Theme.of(
                      context,
                    )
                            .colorScheme
                            .primary,

                    foregroundColor:
                        Theme.of(
                      context,
                    )
                            .colorScheme
                            .onPrimary,

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius
                              .circular(
                        12,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration(
    String label,
  ) {
    return InputDecoration(
      labelText: label,
      isDense: true,
      filled: true,
      fillColor:
          Colors.white,
      contentPadding:
          const EdgeInsets
              .symmetric(
        horizontal: 12,
        vertical: 12,
      ),
      border:
          OutlineInputBorder(
        borderRadius:
            BorderRadius
                .circular(
          10,
        ),
        borderSide:
            BorderSide(
          color: Colors
              .grey.shade300,
        ),
      ),
      enabledBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius
                .circular(
          10,
        ),
        borderSide:
            BorderSide(
          color: Colors
              .grey.shade300,
        ),
      ),
    );
  }

  static const double
      _colItemWidth = 140;

  static const double
      _colQtyWidth = 70;

  static const double
      _colUnitWidth = 60;

  static const double
      _colPriceWidth = 100;

  static const double
      _colTotalWidth = 100;

  static const double
      _colDeleteWidth = 50;

  static const double _tableWidth =
      _colItemWidth +
          _colQtyWidth +
          _colUnitWidth +
          _colPriceWidth +
          _colTotalWidth +
          _colDeleteWidth;

  String _displayUnit(
    String unit,
  ) {
    switch (unit) {
      case 'KG':
        return 'Kg';

      case 'G':
        return 'G';

      case 'ITEM':
        return 'Item';

      default:
        return unit;
    }
  }

  Widget _summaryHeaderRow() {
    final style =
        TextStyle(
      fontSize: 11.5,
      fontWeight:
          FontWeight.w600,
      color:
          Colors.grey[500],
    );

    return Row(
      children: [
        SizedBox(
          width:
              _colItemWidth,
          child: Text(
            'ITEM',
            style: style,
          ),
        ),

        SizedBox(
          width:
              _colQtyWidth,
          child: Text(
            'QTY',
            style: style,
          ),
        ),

        SizedBox(
          width:
              _colUnitWidth,
          child: Text(
            'UNIT',
            style: style,
          ),
        ),

        SizedBox(
          width:
              _colPriceWidth,
          child: Text(
            'PRICE',
            style: style,
          ),
        ),

        SizedBox(
          width:
              _colTotalWidth,
          child: Text(
            'TOTAL',
            style: style,
          ),
        ),

        SizedBox(
          width:
              _colDeleteWidth,
          child: Text(
            '',
            style: style,
          ),
        ),
      ],
    );
  }

  Widget _summaryRow(
    int index,
    bool isGeneratingQr,
  ) {
    final item =
        _addedItems[index];

    final isBeingEdited =
        _editingIndex == index;

    return InkWell(
      onTap:
          isGeneratingQr
              ? null
              : () {
                  _loadItemIntoForm(
                    index,
                  );
                },
      borderRadius:
          BorderRadius.circular(
        8,
      ),
      child: Container(
        padding:
            const EdgeInsets
                .symmetric(
          vertical: 8,
        ),
        decoration:
            BoxDecoration(
          color:
              isBeingEdited
                  ? Colors.grey[
                      100]
                  : null,
          borderRadius:
              BorderRadius
                  .circular(
            8,
          ),
        ),
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment
                  .center,
          children: [
            SizedBox(
              width:
                  _colItemWidth,
              child: Text(
                item.name,
                style:
                    const TextStyle(
                  fontSize: 13,
                  fontWeight:
                      FontWeight
                          .w600,
                ),
                overflow:
                    TextOverflow
                        .ellipsis,
              ),
            ),

            SizedBox(
              width:
                  _colQtyWidth,
              child: Text(
                item.quantity
                    .toString(),
                style:
                    TextStyle(
                  fontSize:
                      12.5,
                  color:
                      Colors.grey[
                          600],
                ),
              ),
            ),

            SizedBox(
              width:
                  _colUnitWidth,
              child: Text(
                _displayUnit(
                  item.unit,
                ),
                style:
                    TextStyle(
                  fontSize:
                      12.5,
                  color:
                      Colors.grey[
                          600],
                ),
              ),
            ),

            SizedBox(
              width:
                  _colPriceWidth,
              child: Text(
                'Rs. ${item.price.toStringAsFixed(2)}',
                style:
                    TextStyle(
                  fontSize:
                      12.5,
                  color:
                      Colors.grey[
                          600],
                ),
              ),
            ),

            SizedBox(
              width:
                  _colTotalWidth,
              child: Text(
                'Rs. ${item.total.toStringAsFixed(2)}',
                style:
                    const TextStyle(
                  fontSize: 13,
                  fontWeight:
                      FontWeight
                          .bold,
                ),
              ),
            ),

            SizedBox(
              width:
                  _colDeleteWidth,
              child: Center(
                child:
                    InkWell(
                  onTap:
                      isGeneratingQr
                          ? null
                          : () {
                              _deleteItem(
                                index,
                              );
                            },
                  borderRadius:
                      BorderRadius
                          .circular(
                    16,
                  ),
                  child:
                      Padding(
                    padding:
                        const EdgeInsets
                            .all(
                      4,
                    ),
                    child:
                        Icon(
                      Icons
                          .delete_outline,
                      size: 18,
                      color:
                          isGeneratingQr
                              ? Colors
                                  .grey
                              : Colors
                                  .redAccent,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}