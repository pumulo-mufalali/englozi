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
      selectedItemColor: Colors.teal,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.shuffle),
          label: '',
          tooltip: 'Random word',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: '',
          tooltip: 'Favourite',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.record_voice_over),
          label: '',
          tooltip: 'Pronunciation',
        ),
      ],
    );
  }
}