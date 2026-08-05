import 'package:flutter/material.dart';
// Reusable "box" that sits visually on top of the scaffold background,
// giving the profile / purchase sections a card-like separation.
class DashboardCard_Widget extends StatelessWidget {
  final Widget child;
  const DashboardCard_Widget({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}