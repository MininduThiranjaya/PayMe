import 'package:client/providers/AuthProvider.dart';
import 'package:client/screens/common/RoleSelection_Screen.dart';
import 'package:client/screens/customer/CustomerDashboard_Screen.dart';
import 'package:client/screens/merchant/MerchantDashboard_Screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserDashboard_Screen extends StatelessWidget {

  const UserDashboard_Screen({super.key});
  @override
  Widget build(BuildContext context) {

    final activeRole = context.select<AuthProvider, String?>(
      (provider) => provider.activeRole
    );
    switch(activeRole) {
      case 'CUSTOMER':
        return CustomerDashboard_Screen();
      case 'MERCHANT':
        return MerchantDashboard_Screen();
      default:
        return RoleSelection_Screen();
    }
  }
}