import 'package:flutter/material.dart';
import 'chat/chat_list_screen.dart';
import 'profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ChatListScreen(),
    const Center(child: Text("Stories Screen (Coming Soon)")),
    const Center(child: Text("Search Screen (Coming Soon)")),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -4)),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF0284C7),
          unselectedItemColor: Colors.grey,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), activeIcon: Icon(Icons.chat_bubble), label: "Chats"),
            BottomNavigationBarItem(icon: Icon(Icons.data_usage), activeIcon: Icon(Icons.data_usage_rounded), label: "Stories"),
            BottomNavigationBarItem(icon: Icon(Icons.search), activeIcon: Icon(Icons.search_rounded), label: "Search"),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      ),
    );
  }
}