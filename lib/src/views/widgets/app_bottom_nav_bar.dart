import 'package:flutter/material.dart';
import 'package:appointment_booking_app/utils/app_colors.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AppBottomNavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: Offset(0, 5))],
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [_buildNavItem(context, Icons.home, 'Home', 0), _buildNavItem(context, Icons.calendar_today_outlined, 'Schedule', 1), _buildNavItem(context, Icons.notifications_outlined, 'Notifications', 2), _buildNavItem(context, Icons.settings_outlined, 'Settings', 3)]),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, int index) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(color: isSelected ? AppColors.madiBlue : Colors.transparent, borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? Colors.white : Theme.of(context).iconTheme.color?.withValues(alpha: 0.6) ?? Colors.grey[600], size: 24),
            if (isSelected) ...[
              const SizedBox(height: 4.0),
              Text(
                label,
                style: TextStyle(fontFamily: 'Ubuntu', fontSize: 10.0, fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
