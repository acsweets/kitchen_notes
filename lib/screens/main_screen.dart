import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'ingredient_management_screen.dart';
import 'community_screen_v2.dart';
import 'smart_recommendation_screen.dart';
import 'login_screen.dart';
import 'category_management_screen.dart';
import '../services/auth_service.dart';

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
    const SmartRecommendationScreen(),
    const CommunityScreenV2(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('灶边记'),
        backgroundColor: const Color(0xFFE8D5B7),
        actions: [
          IconButton(
            icon: Icon(
              AuthService.isLoggedIn ? Icons.account_circle : Icons.login,
              color: Colors.white,
            ),
            onPressed: () {
              if (AuthService.isLoggedIn) {
                _showUserMenu();
              } else {
                _navigateToLogin();
              }
            },
          ),
        ],
      ),
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
            icon: Icon(Icons.lightbulb),
            label: '推荐',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: '社区',
          ),
        ],
      ),
    );
  }

  void _navigateToLogin() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
    if (result == true) {
      setState(() {}); // 刷新状态
    }
  }

  void _showUserMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: Text('用户：${AuthService.currentUsername ?? '未知'}'),
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: Text('邮箱：${AuthService.currentEmail ?? '未知'}'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.category),
              title: const Text('类别管理'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CategoryManagementScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('退出登录', style: TextStyle(color: Colors.red)),
              onTap: () async {
                await AuthService.logout();
                Navigator.pop(context);
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('已退出登录')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}