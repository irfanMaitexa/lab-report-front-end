import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lab_report/admin/admin_booking_list_screen.dart';
import 'package:lab_report/admin/admin_logout_screen.dart';
import 'package:lab_report/admin/drmngmnt.dart';

class AdminRouteScreen extends StatefulWidget {
  @override
  _AdminRouteScreenState createState() => _AdminRouteScreenState();
}

class _AdminRouteScreenState extends State<AdminRouteScreen> {
  int _currentIndex = 0;

  // List of screens for each tab
  final List<Widget> _screens = [
   DoctorManagementScreen  (),
    AdminBookingListScreen(),
    AdminLogoutScreen(),
  ];

  // Function to handle tab change
  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50], // Teal background for the entire screen
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: _screens[_currentIndex], // Display current screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabSelected,
        selectedItemColor: Colors.white, // Selected item color is white
        unselectedItemColor: Colors.teal[200], // Unselected item color
        backgroundColor: Colors.teal[800], // Background color for the bar
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services),
            label: 'Doctor Management',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Booking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
      ),
    );
  }
}

