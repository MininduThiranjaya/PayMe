import 'dart:ui';

import 'package:client/providers/AuthProvider.dart';
import 'package:client/widget/common/SwitchRoleButton_Widget.dart';
import 'package:flutter/material.dart';
import 'package:client/widget/common/DashboardCard_Widget.dart';

class Home_Screen extends StatefulWidget {
  const Home_Screen({super.key});
  @override
  State<Home_Screen> createState() => _Home_Screen_State();
}

// Most recent purchase (mock)
class _Home_Screen_State extends State<Home_Screen> {
  // ---- Mock data (swap with real user model later) ----
  final String userName = 'Minindu Perera';
  final String joinDate = 'Member since Jan 2024';
  final String profileImageUrl = 'https://i.pravatar.cc/150?img=12';
  final List<String> userRoles = ['Customer', 'Merchant'];

  // Most recent purchase (mock)
  final Map<String, String> lastPurchase = {
    'title': 'Bus Ticket - Colombo to Vavuniya',
    'date': '04 Aug 2026, 9:15 AM',
    'amount': 'Rs. 850.00',
    'status': 'Completed',
    'ref': 'TXN-88213',
  };

  // Draggable QR button position (null until first layout sets a default).
  Offset? _qrButtonPosition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, outerConstraints) {
            final screenSize = Size(
              outerConstraints.maxWidth,
              outerConstraints.maxHeight,
            );
            const fabSize = 56.0;
            // Default position: bottom-right, with margin — set once.
            _qrButtonPosition ??= Offset(
              screenSize.width - fabSize - 20,
              screenSize.height - fabSize - 20,
            );

            return Stack(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    const pagePadding = EdgeInsets.all(20);
                    final availableHeight =
                        constraints.maxHeight - pagePadding.vertical;

                    return SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      child: Padding(
                        padding: pagePadding,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: availableHeight,
                          ),
                          child: IntrinsicHeight(
                            child: Column(
                              children: [
                                // ---- 1/3 : Profile details box ----
                                DashboardCard_Widget(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Avatar + name/date/roles
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            radius: 40,
                                            backgroundImage: NetworkImage(
                                              profileImageUrl,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  userName,
                                                  style: const TextStyle(
                                                    fontSize: 19,
                                                    fontWeight: FontWeight.bold,
                                                    height: 1.15,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 3),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .calendar_today_outlined,
                                                      size: 13,
                                                      color: Colors.grey[600],
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Expanded(
                                                      child: Text(
                                                        joinDate,
                                                        style: TextStyle(
                                                          fontSize: 12.5,
                                                          color:
                                                              Colors.grey[600],
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                Wrap(
                                                  spacing: 8,
                                                  runSpacing: 8,
                                                  children: userRoles.map((
                                                    role,
                                                  ) {
                                                    return Chip(
                                                      visualDensity:
                                                          VisualDensity.compact,
                                                      materialTapTargetSize:
                                                          MaterialTapTargetSize
                                                              .shrinkWrap,
                                                      avatar: Icon(
                                                        role == 'Customer'
                                                            ? Icons
                                                                  .person_outline
                                                            : Icons
                                                                  .storefront_outlined,
                                                        size: 15,
                                                      ),
                                                      label: Text(
                                                        role,
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      backgroundColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .secondaryContainer,
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 4,
                                                          ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 14),
                                      // Top row: switch-role button anchored top-right
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'My Profile',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey[600],
                                              letterSpacing: 0.2,
                                            ),
                                          ),
                                          SwitchRoleButton_Widget(),
                                        ],
                                      ),
                                      const SizedBox(height: 14),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Payment Method',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey[600],
                                              letterSpacing: 0.2,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'No card added',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.grey[600],
                                                  letterSpacing: 0.2,
                                                ),
                                              ),
                                              Text(
                                                '[Add Card]',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.deepPurple,
                                                  letterSpacing: 0.2,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 14),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Expences',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey[600],
                                              letterSpacing: 0.2,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Today',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.grey[600],
                                                  letterSpacing: 0.2,
                                                ),
                                              ),
                                              Text(
                                                '1250.00 Rs',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.deepPurple,
                                                  letterSpacing: 0.2,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // ---- 2/3 : Previous purchasing details box ----
                                Expanded(
                                  flex: 2,
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
                                                    lastPurchase['title']!,
                                                    style: const TextStyle(
                                                      fontSize: 14.5,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    lastPurchase['date']!,
                                                    style: TextStyle(
                                                      fontSize: 12.5,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              lastPurchase['amount']!,
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
                                              'Ref: ${lastPurchase['ref']!}',
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
                                                lastPurchase['status']!,
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

                // ---- Draggable QR scan button ----
                Positioned(
                  left: _qrButtonPosition!.dx,
                  top: _qrButtonPosition!.dy,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        final newX = (_qrButtonPosition!.dx + details.delta.dx)
                            .clamp(0.0, screenSize.width - fabSize);
                        final newY = (_qrButtonPosition!.dy + details.delta.dy)
                            .clamp(0.0, screenSize.height - fabSize);
                        _qrButtonPosition = Offset(newX, newY);
                      });
                    },
                    child: FloatingActionButton(
                      heroTag: 'qr_scan_fab',
                      shape: const CircleBorder(),
                      onPressed: () {
                        // TODO: navigate to QR scanner
                      },
                      tooltip: 'Scan QR (drag to move)',
                      child: const Icon(Icons.qr_code_scanner_rounded),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}