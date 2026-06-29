import 'package:flutter/material.dart';
import '../../theme/yonwa_theme.dart';
import 'home/home_screen.dart';
import 'pro/dashboard_screen.dart';
import 'ai_assistant_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;
  
  final List<Widget> _screens = [
    const HomeScreen(),
    const AIAssistantScreen(),
    const ProfessionalDashboardScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: YonwaColors.primary500,
        unselectedItemColor: YonwaColors.neutral400,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explorer'),
          BottomNavigationBarItem(icon: Icon(Icons.psychology), label: 'Assistant'),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Pro'),
        ],
      ),
    );
  }
}



