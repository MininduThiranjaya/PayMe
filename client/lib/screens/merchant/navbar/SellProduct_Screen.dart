import 'dart:convert';

import 'package:client/providers/AuthProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:client/widget/common/DashboardCard_Widget.dart';

// ---------------------------------------------------------------------------
// Plain data model for a saved item (no controllers — these are committed
// values shown in the summary list, and get loaded back into the form
// fields for editing when tapped).
// ---------------------------------------------------------------------------
class _OrderItem {
  _OrderItem({
    required this.name,
    required this.quantity,
    required this.unit,
    required this.price,
  });

  final String name;
  final double quantity;
  final String unit; // KG | G | ITEM — matches the API's `itemMetric` field
  final double price;

  double get total => quantity * price;
}

class SellProduct_Screen extends StatefulWidget {
  const SellProduct_Screen({super.key});
  @override
  State<SellProduct_Screen> createState() => _SellProduct_Screen_State();
}

class _SellProduct_Screen_State extends State<SellProduct_Screen> {
  static const List<String> _units = ['KG', 'G', 'ITEM'];

  // TODO: replace with the logged-in merchant's id, e.g. via
  // context.read<AuthProvider>().merchantId once that's wired up.
  static const int _merchantId = 1;

  // ---- Single entry form state ------------------------------------------
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String _selectedUnit = 'KG';

  // Index into _addedItems currently being edited, or null when the form
  // is set up to add a brand new item.
  int? _editingIndex;

  // ---- Items already added ------------------------------------------------
  final List<_OrderItem> _addedItems = [];

  bool get _isFormValid {
    final name = _nameController.text.trim();
    final qty = double.tryParse(_quantityController.text) ?? 0;
    final price = double.tryParse(_priceController.text) ?? 0;
    return name.isNotEmpty && qty > 0 && price > 0;
  }

  double get _grandTotal =>
      _addedItems.fold(0.0, (sum, item) => sum + item.total);

  // Sends whole numbers as int (2, not 2.0) to match the sample payload,
  // keeps fractional values as-is.
  num _numify(double value) => value % 1 == 0 ? value.toInt() : value;

  void _clearForm() {
    _nameController.clear();
    _quantityController.clear();
    _priceController.clear();
    _selectedUnit = 'KG';
    _editingIndex = null;
  }

  void _addOrUpdateItem() {
    if (!_isFormValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fill in item name, quantity and price to continue.'),
        ),
      );
      return;
    }

    final item = _OrderItem(
      name: _nameController.text.trim(),
      quantity: double.parse(_quantityController.text),
      unit: _selectedUnit,
      price: double.parse(_priceController.text),
    );

    setState(() {
      if (_editingIndex != null) {
        _addedItems[_editingIndex!] = item;
      } else {
        _addedItems.add(item);
      }
      _clearForm();
    });
  }

  void _deleteItem(int index) {
    setState(() {
      _addedItems.removeAt(index);
      if (_editingIndex == index) {
        _clearForm();
      }
    });
  }

  void _loadItemIntoForm(int index) {
    final item = _addedItems[index];
    setState(() {
      _nameController.text = item.name;
      _quantityController.text = _numify(item.quantity).toString();
      _priceController.text = _numify(item.price).toString();
      _selectedUnit = item.unit;
      _editingIndex = index;
    });
  }

  Map<String, dynamic> _buildOrderPayload() {
    return {
      'merchantId': _merchantId,
      'orderItem': _addedItems
          .map(
            (item) => {
              'itemName': item.name,
              'quantity': _numify(item.quantity),
              'itemMetric': item.unit,
              'unitPrice': _numify(item.price),
            },
          )
          .toList(),
    };
  }

  Future<void> _generateQrCode() async {
    if (_addedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Add at least one item before generating a QR code.'),
        ),
      );
      return;
    }

    final payload = _buildOrderPayload();
    final qrResponse = await _dummyGenerateQrApiCall(payload);

    if (!mounted) return;
    _showQrDialog(payload, _addedItems.length, qrResponse);
  }

  // ---------------------------------------------------------------------
  // Placeholder for the real API call. Fill this in with your actual
  // request (merchantId + orderItem payload above) when ready.
  // ---------------------------------------------------------------------
  Future<Map<String, dynamic>> _dummyGenerateQrApiCall(
    Map<String, dynamic> payload,
  ) async {
    // TODO: implement API call here
    return {};
  }

  void _showQrDialog(
    Map<String, dynamic> payload,
    int itemCount,
    Map<String, dynamic> qrResponse,
  ) {
    final prettyPayload =
        const JsonEncoder.withIndent('  ').convert(payload);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Order QR Code'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 240,
                    height: 240,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.qr_code_2, size: 130),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    'Total: Rs. ${_grandTotal.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Center(
                  child: Text(
                    '$itemCount item(s) encoded',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    'Demo call ref: ${qrResponse['qrData'] ?? 'n/a'}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11.5, color: Colors.grey[500]),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Request body sent:',
                  style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SelectableText(
                    prettyPayload,
                    style: const TextStyle(
                      fontSize: 11,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final isLoging = context.watch<AuthProvider>().isLoging;

    final primaryContainer = Theme.of(context).colorScheme.primaryContainer;
    final isEditing = _editingIndex != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sell Product',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 14),

              // ---- Item entry form ------------------------------------
              Expanded(
                flex: 4,
                child: DashboardCard_Widget(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Item Details',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (isEditing)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: primaryContainer,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Editing item ${_editingIndex! + 1}',
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _nameController,
                        onChanged: (_) => setState(() {}),
                        decoration: _fieldDecoration('Item Name'),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: TextField(
                              controller: _quantityController,
                              onChanged: (_) => setState(() {}),
                              keyboardType: const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              decoration: _fieldDecoration('Quantity'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: DropdownButtonFormField<String>(
                              value: _selectedUnit,
                              decoration: _fieldDecoration('Unit'),
                              items: _units
                                  .map(
                                    (u) => DropdownMenuItem(
                                      value: u,
                                      child: Text(u),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                if (value == null) return;
                                setState(() => _selectedUnit = value);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _priceController,
                        onChanged: (_) => setState(() {}),
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                        decoration: _fieldDecoration('Unit Price').copyWith(
                          prefixText: 'Rs. ',
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          if (isEditing) ...[
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => setState(_clearForm),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text('Cancel'),
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                          Expanded(
                            flex: 2,
                            child: ElevatedButton.icon(
                              onPressed:
                                  _isFormValid ? _addOrUpdateItem : null,
                              icon: Icon(
                                isEditing ? Icons.check : Icons.add,
                                size: 18,
                              ),
                              label: Text(isEditing ? 'Update Item' : 'Add Item'),
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
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

              const SizedBox(height: 16),

              // ---- Preview / summary section --------------------------
              Expanded(
                flex: 5,
                child: DashboardCard_Widget(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Order Summary',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: _tableWidth,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _summaryHeaderRow(),
                                const SizedBox(height: 8),
                                const Divider(height: 1),
                                const SizedBox(height: 4),
                                Expanded(
                                  child: _addedItems.isEmpty
                                      ? Center(
                                          child: Text(
                                            'No items added yet',
                                            style: TextStyle(
                                              color: Colors.grey[500],
                                            ),
                                          ),
                                        )
                                      : ListView.separated(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 6,
                                          ),
                                          itemCount: _addedItems.length,
                                          separatorBuilder: (_, __) =>
                                              const Divider(height: 1),
                                          itemBuilder: (context, index) =>
                                              _summaryRow(index),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Divider(height: 1),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Amount',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Rs. ${_grandTotal.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ---- Generate QR button ----------------------------------
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _generateQrCode,
                  icon: const Icon(Icons.qr_code_2),
                  label: const Text(
                    'Generate QR Code',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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

  InputDecoration _fieldDecoration(String label) {
    return InputDecoration(
      labelText: label,
      isDense: true,
      filled: true,
      fillColor: Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }

  // -------------------------------------------------------------------
  // Preview section: column header row + per-item row-wise summary.
  // Tapping a row loads it back into the form for editing; the trash
  // icon deletes it from the list (form itself is untouched by delete
  // unless that exact item was mid-edit).
  // -------------------------------------------------------------------
  // Fixed column widths so header and rows line up while horizontally
  // scrolling on narrow screens. Header and body share one horizontal
  // scroll (see the Order Summary section in build()) so they always
  // stay aligned, and the header never moves during vertical scrolling
  // since it sits outside the vertical ListView.
  static const double _colItemWidth = 140;
  static const double _colQtyWidth = 70;
  static const double _colUnitWidth = 60;
  static const double _colPriceWidth = 100;
  static const double _colTotalWidth = 100;
  static const double _colDeleteWidth = 50;
  static const double _tableWidth = _colItemWidth +
      _colQtyWidth +
      _colUnitWidth +
      _colPriceWidth +
      _colTotalWidth +
      _colDeleteWidth;

  String _displayUnit(String unit) {
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
    final style = TextStyle(
      fontSize: 11.5,
      fontWeight: FontWeight.w600,
      color: Colors.grey[500],
    );
    return Row(
      children: [
        SizedBox(width: _colItemWidth, child: Text('ITEM', style: style)),
        SizedBox(width: _colQtyWidth, child: Text('QTY', style: style)),
        SizedBox(width: _colUnitWidth, child: Text('UNIT', style: style)),
        SizedBox(width: _colPriceWidth, child: Text('PRICE', style: style)),
        SizedBox(
          width: _colTotalWidth,
          child: Text('TOTAL', style: style),
        ),
        SizedBox(
          width: _colDeleteWidth,
          child: Text('', style: style, textAlign: TextAlign.center),
        ),
      ],
    );
  }

  Widget _summaryRow(int index) {
    final item = _addedItems[index];
    final isBeingEdited = _editingIndex == index;

    return InkWell(
      onTap: () => _loadItemIntoForm(index),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isBeingEdited ? Colors.grey[100] : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: _colItemWidth,
              child: Text(
                item.name,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              width: _colQtyWidth,
              child: Text(
                '${_numify(item.quantity)}',
                style: TextStyle(fontSize: 12.5, color: Colors.grey[600]),
              ),
            ),
            SizedBox(
              width: _colUnitWidth,
              child: Text(
                _displayUnit(item.unit),
                style: TextStyle(fontSize: 12.5, color: Colors.grey[600]),
              ),
            ),
            SizedBox(
              width: _colPriceWidth,
              child: Text(
                'Rs. ${item.price.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 12.5, color: Colors.grey[600]),
              ),
            ),
            SizedBox(
              width: _colTotalWidth,
              child: Text(
                'Rs. ${item.total.toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: _colDeleteWidth,
              child: Center(
                child: InkWell(
                  onTap: () => _deleteItem(index),
                  borderRadius: BorderRadius.circular(16),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(
                      Icons.delete_outline,
                      size: 18,
                      color: Colors.redAccent,
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
