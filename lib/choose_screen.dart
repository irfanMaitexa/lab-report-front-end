import 'package:flutter/material.dart';
import 'package:lab_report/admin/adminlogin.dart';
import 'package:lab_report/doctor/doctorlogin.dart';
import 'package:lab_report/user/login.dart';

class ChooseRoleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[100],  // Set the background color to teal
      appBar: AppBar(
        title: Text('Choose Your Role'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Please select your role:',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.teal[800],
              ),
            ),
            SizedBox(height: 40),
            _buildRoleButton(context, 'User', Colors.teal[300], Colors.teal[900], () {
             Navigator.push(context, MaterialPageRoute(builder: (context) => 
             LoginPage(),));
              
            },),
            SizedBox(height: 20),
            _buildRoleButton(context, 'Admin', Colors.teal[400], Colors.teal[900],() {
             Navigator.push(context, MaterialPageRoute(builder: (context) => 
             AdminLoginScreen(),)); 
            },),
            SizedBox(height: 20),
            _buildRoleButton(context, 'Doctor', Colors.teal[500], Colors.teal[900],() {
              Navigator.push(context, MaterialPageRoute(builder: (context) => 
             DoctorLoginScreen (),));  
            },),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleButton(BuildContext context, String role, Color ? buttonColor, Color? textColor,VoidCallback onpress) {
    return ElevatedButton(
      onPressed: onpress
      ,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor, // Button background color
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 5,
      ),
      child: Text(
        role,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: textColor, // Text color
        ),
      ),
    );
  }
}