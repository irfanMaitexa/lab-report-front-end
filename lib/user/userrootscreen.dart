import 'package:flutter/material.dart';
import 'package:lab_report/user/bookinglist.dart';
import 'package:lab_report/user/home_screen.dart';
import 'package:lab_report/user/userprofilescreen.dart';

class UserNavigationScreen extends StatefulWidget {
  @override
  _UserNavigationScreenState createState() => _UserNavigationScreenState();
}

class _UserNavigationScreenState extends State<UserNavigationScreen> {
  int _selectedIndex = 0;

  // Pages for the navigation bar
  final List<Widget> _pages = [
   HomeScreen(),
   BookingListScreen(),
   Userprofilescreen()

  ];

  // Bottom Navigation Bar Functionality
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle(_selectedIndex)),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.teal,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.teal[100],
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Booking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  String _getTitle(int index) {
    switch (index) {
      case 0:
        return 'Home';
      case 1:
        return 'Booking';
      case 2:
        return 'Profile';
      default:
        return '';
    }
  }
}
