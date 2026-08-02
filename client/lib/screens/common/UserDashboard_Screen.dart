import 'package:flutter/material.dart';

class UserDashboard_Screen extends StatefulWidget {
  const UserDashboard_Screen({super.key});
  @override
  State<UserDashboard_Screen> createState() => _UserDashboard_Screen_State();
}

class _UserDashboard_Screen_State extends State<UserDashboard_Screen> {
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
                        Text('Dashboard')
                      ]
                    )
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
