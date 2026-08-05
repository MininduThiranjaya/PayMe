import 'package:flutter/material.dart';

class BottomTabItem {
  final String title;
  final IconData icon;
  final IconData? activeIcon;
  final Widget page;

  const BottomTabItem({
    required this.title,
    required this.icon,
    required this.page,
    this.activeIcon,
  });
}

class BottomTabNavBar_Widget extends StatefulWidget {
  final List<BottomTabItem> tabs;
  final int initialIndex;

  const BottomTabNavBar_Widget({
    super.key,
    required this.tabs,
    this.initialIndex = 0,
  });

  @override
  State<BottomTabNavBar_Widget> createState() =>
      _BottomTabNavBar_Widget_State();
}

class _BottomTabNavBar_Widget_State extends State<BottomTabNavBar_Widget> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();

    if (widget.tabs.isEmpty) {
      throw ArgumentError('Bottom navigation tabs cannot be empty.');
    }

    if (widget.initialIndex < 0 || widget.initialIndex >= widget.tabs.length) {
      selectedIndex = 0;
    } else {
      selectedIndex = widget.initialIndex;
    }
  }

  void changeTab(int index) {
    if (selectedIndex == index) {
      return;
    }

    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final selectedTab = widget.tabs[selectedIndex];

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(selectedTab.title),
      //   centerTitle: true,
      // ),

      // IndexedStack keeps the state of every tab page.
      body: IndexedStack(
        index: selectedIndex,
        children: widget.tabs.map((tab) => tab.page).toList(),
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: changeTab,
        destinations: widget.tabs.map((tab) {
          return NavigationDestination(
            icon: Icon(tab.icon),
            selectedIcon: Icon(tab.activeIcon ?? tab.icon),
            label: tab.title,
          );
        }).toList(),
      ),
    );
  }
}
