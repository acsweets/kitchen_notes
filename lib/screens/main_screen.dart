import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'ingredient_management_screen.dart';
import 'recipe_category_management_screen.dart';
import 'cooking_calendar_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const HomeScreen(),
    const IngredientManagementScreen(),
    const CookingCalendarScreen(),
    const RecipeCategoryManagementScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFE8D5B7),
        selectedItemColor: const Color(0xFFB8860B),
        unselectedItemColor: Colors.grey[600],
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: '菜谱',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2),
            label: '食材',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '日历',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: '分类',
          ),
        ],
      ),
    );
  }
}