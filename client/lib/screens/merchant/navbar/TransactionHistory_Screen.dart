import 'package:flutter/material.dart';
import 'package:client/providers/AuthProvider.dart';
import 'package:provider/provider.dart';
import 'package:client/widget/common/DashboardCard_Widget.dart';

class TransactionHistory_Screen extends StatefulWidget {
  const TransactionHistory_Screen({super.key});

  @override
  State<TransactionHistory_Screen> createState() => _TransactionHistory_Screen_State();
}

class _TransactionHistory_Screen_State extends State<TransactionHistory_Screen> {

  @override
  Widget build(BuildContext context) {
    final isLoging = context.watch<AuthProvider>().isLoging;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            const pagePadding = EdgeInsets.all(20);
            final availableHeight =constraints.maxHeight - pagePadding.vertical;
            return SingleChildScrollView(

              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Padding(
                padding: pagePadding,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: availableHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        Expanded(
                                  flex: 1,
                                  child: DashboardCard_Widget(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Recent Purchase',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.primaryContainer,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: const Icon(
                                                Icons
                                                    .directions_bus_filled_outlined,
                                              ),
                                            ),
                                            const SizedBox(width: 14),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "lastPurchase['title']!",
                                                    style: const TextStyle(
                                                      fontSize: 14.5,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    "lastPurchase['date']",
                                                    style: TextStyle(
                                                      fontSize: 12.5,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              "lastPurchase['amount']!",
                                              style: const TextStyle(
                                                fontSize: 14.5,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        const Divider(height: 1),
                                        const SizedBox(height: 12),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Ref: }',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.green.withValues(
                                                  alpha: 0.12,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                               " lastPurchase['status']!",
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                             
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
