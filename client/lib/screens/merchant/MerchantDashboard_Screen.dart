import 'package:client/screens/merchant/navbar/Home_Screen.dart';
import 'package:client/screens/merchant/navbar/Notification_Screen.dart';
import 'package:client/screens/merchant/navbar/Profile_Screen.dart';
import 'package:client/screens/merchant/navbar/SellProduct_Screen.dart';
import 'package:client/screens/merchant/navbar/TransactionHistory_Screen.dart';
import 'package:client/widget/common/BottomTabNavBar_Widget.dart';
import 'package:flutter/material.dart';

class MerchantDashboard_Screen extends StatelessWidget {
  const MerchantDashboard_Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BottomTabNavBar_Widget(
      initialIndex: 0,
      tabs: [
        BottomTabItem(
          title: 'Home',
          icon: Icons.home_outlined,
          activeIcon: Icons.home,
          page: Home_Screen(),
        ),
        BottomTabItem(
          title: 'Sales',
          icon: Icons.point_of_sale_outlined,
          activeIcon: Icons.point_of_sale,
          page: SellProduct_Screen(),
        ),
        BottomTabItem(
          title: 'Transactions',
          icon: Icons.payments_outlined,
          activeIcon: Icons.payments,
          page: TransactionHistory_Screen(),
        ),
        BottomTabItem(
          title: 'Notification',
          icon: Icons.notifications_active_outlined,
          activeIcon: Icons.notifications_active,
          page: Notification_Screen(),
        ),
        BottomTabItem(
          title: 'Profile',
          icon: Icons.person_outline,
          activeIcon: Icons.person,
          page: Profile_Screen(),
        ),
      ],
    );
  }
}