import 'package:flutter/material.dart';
import 'package:client/providers/AuthProvider.dart';
import 'package:provider/provider.dart';

class Notification_Screen extends StatefulWidget {
  const Notification_Screen({super.key});

  @override
  State<Notification_Screen> createState() => _Notification_Screen_State();
}

class _Notification_Screen_State extends State<Notification_Screen> {

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
                        // Title section: 1/3
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text('Welcome to the notification!'),
                              SizedBox(height: 20),
                            ],
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
