import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lab_report/choose_screen.dart';

class AdminLogoutScreen extends StatefulWidget {
  const AdminLogoutScreen({super.key});

  @override
  State<AdminLogoutScreen> createState() => _AdminLogoutScreenState();
}

class _AdminLogoutScreenState extends State<AdminLogoutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
  body: Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
      crossAxisAlignment: CrossAxisAlignment.center, // Center content horizontally
      children: [
        Text(
          'Are you sure?',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          'Logout',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            // Perform logout logic
            try {
              await FirebaseAuth.instance.signOut(); // Log the user out

              // Navigate to the chosen screen (e.g., login screen)
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => ChooseRoleScreen()), // Replace `YourChosenScreen` with your actual widget
                (route) => false, // Remove all routes from the stack
              );
            } catch (e) {
              // Handle logout error if needed
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error logging out: $e')),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red, // Logout button color
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            'Logout',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    ),
  ),
);

  }
}