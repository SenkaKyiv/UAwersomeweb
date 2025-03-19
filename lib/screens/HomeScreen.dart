import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'mycourse.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    ProfileScreen(),
    MyCoursesScreen(),
  ];

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Coach Tool"),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.cloud_upload), label: "Завантаження курсу"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Мої курси"),
        ],
        onTap: (i) {
          setState(() => _currentIndex = i);
        },
      ),
    );
  }
}
