import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedItemColor: Colors.transparent,
      unselectedItemColor: Colors.grey,
      selectedIconTheme: const IconThemeData(
        color: Colors.transparent,
      ),
      unselectedIconTheme: const IconThemeData(
        color: Colors.grey,
      ),
      items: [
        _buildNavItem(Icons.shuffle, 0),
        _buildNavItem(Icons.home, 1),
        _buildNavItem(Icons.record_voice_over, 2),
      ],
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, int index) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: currentIndex == index ? Colors.teal.withOpacity(0.2) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: currentIndex == index ? Colors.teal : Colors.grey),
      ),
      label: '',
      tooltip: _getTooltip(index),
    );
  }

  String _getTooltip(int index) {
    switch(index) {
      case 0: return 'Random word';
      case 1: return 'Home';
      case 2: return 'Pronunciation';
      default: return '';
    }
  }
}