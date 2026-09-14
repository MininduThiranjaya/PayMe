// import 'package:flutter/material.dart';
// import 'package:client/providers/AuthProvider.dart';
// import 'package:provider/provider.dart';
// import 'package:client/widget/common/DashboardCard_Widget.dart';

// class TransactionHistory_Screen extends StatefulWidget {
//   const TransactionHistory_Screen({super.key});

//   @override
//   State<TransactionHistory_Screen> createState() => _TransactionHistory_Screen_State();
// }

// class _TransactionHistory_Screen_State extends State<TransactionHistory_Screen> {

//   @override
//   Widget build(BuildContext context) {
//     final isLoging = context.watch<AuthProvider>().isLoging;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF3F4F6),
//       resizeToAvoidBottomInset: true,
//       body: SafeArea(
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             const pagePadding = EdgeInsets.all(20);
//             final availableHeight =constraints.maxHeight - pagePadding.vertical;
//             return SingleChildScrollView(

//               keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
//               child: Padding(
//                 padding: pagePadding,
//                 child: ConstrainedBox(
//                   constraints: BoxConstraints(minHeight: availableHeight),
//                   child: IntrinsicHeight(
//                     child: Column(
//                       children: [
//                         Expanded(
//                                   flex: 1,
//                                   child: DashboardCard_Widget(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         const Text(
//                                           'Recent Purchase',
//                                           style: TextStyle(
//                                             fontSize: 15,
//                                             fontWeight: FontWeight.w600,
//                                           ),
//                                         ),
//                                         const SizedBox(height: 16),
//                                         Row(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Container(
//                                               padding: const EdgeInsets.all(10),
//                                               decoration: BoxDecoration(
//                                                 color: Theme.of(
//                                                   context,
//                                                 ).colorScheme.primaryContainer,
//                                                 borderRadius:
//                                                     BorderRadius.circular(10),
//                                               ),
//                                               child: const Icon(
//                                                 Icons
//                                                     .directions_bus_filled_outlined,
//                                               ),
//                                             ),
//                                             const SizedBox(width: 14),
//                                             Expanded(
//                                               child: Column(
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   Text(
//                                                     "lastPurchase['title']!",
//                                                     style: const TextStyle(
//                                                       fontSize: 14.5,
//                                                       fontWeight:
//                                                           FontWeight.w600,
//                                                     ),
//                                                   ),
//                                                   const SizedBox(height: 4),
//                                                   Text(
//                                                     "lastPurchase['date']",
//                                                     style: TextStyle(
//                                                       fontSize: 12.5,
//                                                       color: Colors.grey[600],
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                             Text(
//                                               "lastPurchase['amount']!",
//                                               style: const TextStyle(
//                                                 fontSize: 14.5,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         const SizedBox(height: 16),
//                                         const Divider(height: 1),
//                                         const SizedBox(height: 12),
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Text(
//                                               'Ref: }',
//                                               style: TextStyle(
//                                                 fontSize: 12,
//                                                 color: Colors.grey[600],
//                                               ),
//                                             ),
//                                             Container(
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                     horizontal: 10,
//                                                     vertical: 4,
//                                                   ),
//                                               decoration: BoxDecoration(
//                                                 color: Colors.green.withValues(
//                                                   alpha: 0.12,
//                                                 ),
//                                                 borderRadius:
//                                                     BorderRadius.circular(20),
//                                               ),
//                                               child: Text(
//                                                " lastPurchase['status']!",
//                                                 style: const TextStyle(
//                                                   fontSize: 12,
//                                                   fontWeight: FontWeight.w600,
//                                                   color: Colors.green,
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),                    
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:client/providers/AuthProvider.dart';
import 'package:provider/provider.dart';
import 'package:client/widget/common/DashboardCard_Widget.dart';

class TransactionHistory_Screen extends StatefulWidget {
  const TransactionHistory_Screen({super.key});

  @override
  State<TransactionHistory_Screen> createState() =>
      _TransactionHistory_Screen_State();
}

class OrderItem {
  final String itemName;
  final int quantity;
  final String itemMetric;
  final double unitPrice;

  OrderItem({
    required this.itemName,
    required this.quantity,
    required this.itemMetric,
    required this.unitPrice,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      itemName: json['itemName'] as String,
      quantity: json['quantity'] as int,
      itemMetric: json['itemMetric'] as String,
      unitPrice: (json['unitPrice'] as num).toDouble(),
    );
  }
}

class Transaction {
  final String id;
  final String shopName;
  final String date;
  final double amount;
  final bool success;
  final List<OrderItem> orderItem;

  Transaction({
    required this.id,
    required this.shopName,
    required this.date,
    required this.amount,
    required this.success,
    required this.orderItem,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      shopName: json['shopName'] as String,
      date: json['date'] as String,
      amount: (json['amount'] as num).toDouble(),
      success: json['success'] as bool,
      orderItem: (json['orderItem'] as List)
          .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// ---- Dummy "API" layer ----
/// Swap the body of this function with a real HTTP call
/// (e.g. `final res = await dio.get('/transactions'); return (res.data as List).map(...)`)
/// The rest of the screen doesn't need to change — it just awaits this Future.
class TransactionApi {
  static Future<List<Transaction>> fetchTransactions() async {
    // Simulate network latency.
    await Future.delayed(const Duration(milliseconds: 900));

    // Simulate an occasional failure so the error state is exercised too.
    // Comment this out once a real API call replaces it.
    // if (DateTime.now().second % 7 == 0) {
    //   throw Exception('Failed to load transactions');
    // }

    const mockJson = [
      {
        'id': 't1',
        'shopName': 'Cargills Food City',
        'date': '04 Aug 2026, 9:15 AM',
        'amount': 8950.00,
        'success': true,
        'orderItem': [
          {'itemName': 'Beef', 'quantity': 2, 'itemMetric': 'KG', 'unitPrice': 4250},
          {'itemName': 'Brown Sugar', 'quantity': 1, 'itemMetric': 'KG', 'unitPrice': 400},
          {'itemName': 'Milk Packet', 'quantity': 3, 'itemMetric': 'ITEM', 'unitPrice': 180},
        ],
      },
      {
        'id': 't2',
        'shopName': 'Keells Super',
        'date': '02 Aug 2026, 5:40 PM',
        'amount': 1250.00,
        'success': false,
        'orderItem': [
          {'itemName': 'Basmati Rice', 'quantity': 1, 'itemMetric': 'KG', 'unitPrice': 850},
          {'itemName': 'Chicken Eggs', 'quantity': 1, 'itemMetric': 'ITEM', 'unitPrice': 400},
        ],
      },
      {
        'id': 't3',
        'shopName': 'Arpico Supercentre',
        'date': '30 Jul 2026, 11:05 AM',
        'amount': 3420.00,
        'success': true,
        'orderItem': [
          {'itemName': 'Coconut Oil', 'quantity': 2, 'itemMetric': 'L', 'unitPrice': 960},
          {'itemName': 'Wheat Flour', 'quantity': 2, 'itemMetric': 'KG', 'unitPrice': 250},
          {'itemName': 'Tea Leaves', 'quantity': 1, 'itemMetric': 'KG', 'unitPrice': 1000},
        ],
      },
      {
        'id': 't4',
        'shopName': 'Laugfs Supermarket',
        'date': '27 Jul 2026, 2:20 PM',
        'amount': 640.00,
        'success': false,
        'orderItem': [
          {'itemName': 'Bread', 'quantity': 2, 'itemMetric': 'ITEM', 'unitPrice': 150},
          {'itemName': 'Butter', 'quantity': 1, 'itemMetric': 'ITEM', 'unitPrice': 340},
        ],
      },
    ];

    return mockJson.map((e) => Transaction.fromJson(e)).toList();
  }

  /// Dummy "delete" call — swap with a real DELETE request later.
  static Future<void> deleteTransaction(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // TODO: await dio.delete('/transactions/$id');
  }

  /// Dummy "recover all" call — swap with a real POST/PATCH request later.
  static Future<void> recoverAllTransactions() async {
    await Future.delayed(const Duration(milliseconds: 300));
    // TODO: await dio.post('/transactions/recover-all');
  }
}

class _TransactionHistory_Screen_State extends State<TransactionHistory_Screen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // ---- Async load state ----
  List<Transaction> _allTransactions = [];
  bool _isLoading = true;
  String? _errorMessage;

  // Soft-delete: ids hidden from the visible list until recovered.
  final Set<String> _deletedIds = {};

  // Which transactions currently have their item list expanded.
  final Set<String> _expandedIds = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() => setState(() {}));
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.trim().toLowerCase());
    });
    _loadTransactions();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadTransactions() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await TransactionApi.fetchTransactions();
      setState(() {
        _allTransactions = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Could not load transactions. Please try again.';
        _isLoading = false;
      });
    }
  }

  List<Transaction> get _visibleTransactions {
    return _allTransactions.where((t) {
      if (_deletedIds.contains(t.id)) return false;

      // Tab filter: 0 = All, 1 = Success, 2 = Failed
      if (_tabController.index == 1 && !t.success) return false;
      if (_tabController.index == 2 && t.success) return false;

      // Search filter (shop name)
      if (_searchQuery.isNotEmpty &&
          !t.shopName.toLowerCase().contains(_searchQuery)) {
        return false;
      }

      return true;
    }).toList();
  }

  void _toggleExpanded(String id) {
    setState(() {
      if (_expandedIds.contains(id)) {
        _expandedIds.remove(id);
      } else {
        _expandedIds.add(id);
      }
    });
  }

  Future<void> _deleteTransaction(String id) async {
    // Optimistic UI update, then fire the dummy call.
    setState(() => _deletedIds.add(id));
    try {
      await TransactionApi.deleteTransaction(id);
    } catch (e) {
      // Roll back if the "API call" fails.
      setState(() => _deletedIds.remove(id));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete transaction')),
        );
      }
    }
  }

  Future<void> _recoverAllTransactions() async {
    final previouslyDeleted = Set<String>.from(_deletedIds);
    setState(() => _deletedIds.clear());
    try {
      await TransactionApi.recoverAllTransactions();
    } catch (e) {
      setState(() => _deletedIds.addAll(previouslyDeleted));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to recover transactions')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoging = context.watch<AuthProvider>().isLoging;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            // ---- Recent Purchase card — kept exactly as-is ----

            // ---- Tabs ----
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: const Color.fromARGB(255, 210, 189, 248),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey[700],
                  labelStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(text: 'All'),
                    Tab(text: 'Success'),
                    Tab(text: 'Failed'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ---- Search bar ----
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search by shop name',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () => _searchController.clear(),
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ---- Transaction History section — the ONLY scrollable region ----
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Transaction History',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                            letterSpacing: 0.2,
                          ),
                        ),
                        if (!_isLoading && _errorMessage == null)
                          IconButton(
                            icon: const Icon(Icons.refresh, size: 18),
                            color: Colors.deepPurple,
                            tooltip: 'Refresh',
                            onPressed: _loadTransactions,
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          if (_isLoading) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Color.fromARGB(255, 89, 25, 199),
                              ),
                            );
                          }

                          if (_errorMessage != null) {
                            return Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: Colors.red[300],
                                    size: 32,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _errorMessage!,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                  const SizedBox(height: 12),
                                  OutlinedButton(
                                    onPressed: _loadTransactions,
                                    child: const Text('Retry'),
                                  ),
                                ],
                              ),
                            );
                          }

                          if (_visibleTransactions.isEmpty) {
                            return Center(
                              child: Text(
                                'No transactions found',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            );
                          }

                          return RefreshIndicator(
                            color: Colors.deepPurple,
                            onRefresh: _loadTransactions,
                            child: ListView.separated(
                              padding: const EdgeInsets.only(bottom: 8),
                              itemCount: _visibleTransactions.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final tx = _visibleTransactions[index];
                                final isExpanded =
                                    _expandedIds.contains(tx.id);

                                return DashboardCard_Widget(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // ---- Collapsed row: shop, date, price ----
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primaryContainer,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: const Icon(
                                              Icons.storefront_outlined,
                                            ),
                                          ),
                                          const SizedBox(width: 14),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  tx.shopName,
                                                  style: const TextStyle(
                                                    fontSize: 14.5,
                                                    fontWeight:
                                                        FontWeight.w600,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  tx.date,
                                                  style: TextStyle(
                                                    fontSize: 12.5,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                'Rs. ${tx.amount.toStringAsFixed(2)}',
                                                style: const TextStyle(
                                                  fontSize: 14.5,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 2,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: (tx.success
                                                          ? Colors.green
                                                          : Colors.red)
                                                      .withValues(alpha: 0.12),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20),
                                                ),
                                                child: Text(
                                                  tx.success
                                                      ? 'Success'
                                                      : 'Failed',
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.w600,
                                                    color: tx.success
                                                        ? Colors.green
                                                        : Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      const Divider(height: 1),
                                      // ---- Actions row: delete + dropdown ----
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              Icons.delete_outline,
                                              size: 19,
                                              color: Colors.red[400],
                                            ),
                                            onPressed: () =>
                                                _deleteTransaction(tx.id),
                                          ),
                                          IconButton(
                                            icon: AnimatedRotation(
                                              turns: isExpanded ? 0.5 : 0,
                                              duration: const Duration(
                                                  milliseconds: 200),
                                              child: const Icon(
                                                Icons.keyboard_arrow_down,
                                                size: 22,
                                                color: Colors.deepPurple,
                                              ),
                                            ),
                                            onPressed: () =>
                                                _toggleExpanded(tx.id),
                                          ),
                                        ],
                                      ),

                                      // ---- Hidden item list (revealed on dropdown tap) ----
                                      AnimatedCrossFade(
                                        duration: const Duration(
                                            milliseconds: 200),
                                        crossFadeState: isExpanded
                                            ? CrossFadeState.showFirst
                                            : CrossFadeState.showSecond,
                                        firstChild: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Items',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              ...tx.orderItem.map((item) {
                                                final lineTotal =
                                                    item.quantity *
                                                        item.unitPrice;
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                    vertical: 4,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          '${item.itemName} (${item.quantity} ${item.itemMetric})',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        'Rs. ${lineTotal.toStringAsFixed(2)}',
                                                        style:
                                                            const TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }),
                                            ],
                                          ),
                                        ),
                                        secondChild:
                                            const SizedBox(width: double.infinity),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ---- Recover all transactions — pinned to bottom ----
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _deletedIds.isEmpty ? null : _recoverAllTransactions,
                  icon: const Icon(Icons.restore_rounded, size: 18),
                  label: Text(
                    _deletedIds.isEmpty
                        ? 'No Deleted Transactions'
                        : 'Recover All Transactions (${_deletedIds.length})',
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.deepPurple,
                    side: const BorderSide(color: Colors.deepPurple),
                    padding: const EdgeInsets.symmetric(vertical: 13),
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