import 'package:client/providers/AuthProvider.dart';
import 'package:client/widget/common/SwitchRoleButton_Widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MerchantDashboard_Screen extends StatefulWidget {
  const MerchantDashboard_Screen({super.key});
  @override
  State<MerchantDashboard_Screen> createState() =>
      _MerchantDashboard_Screen_State();
}

class _MerchantDashboard_Screen_State extends State<MerchantDashboard_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            const pagePadding = EdgeInsets.all(20);
            final availableHeight =
                constraints.maxHeight - pagePadding.vertical;

            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Padding(
                padding: pagePadding,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: availableHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        Text('Merchant dashboard'),
                        SwitchRoleButton_Widget()
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
