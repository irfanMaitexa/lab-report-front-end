import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorHomeScreen extends StatelessWidget {
  final String userId = "user123";

  const DoctorHomeScreen({super.key}); // Replace with dynamic user ID if needed.

  Future<Map<String, dynamic>> fetchProfileData() async {
    final DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('profiles')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();

    if (doc.exists) {
      return doc.data() as Map<String, dynamic>;
    } else {
      throw Exception("Profile not found!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchProfileData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text("No profile data found"));
          }

          // Extract data from Firestore
          final data = snapshot.data!;
          final certificateUrl = data['certificateUrl'] as String;
          final name = data['name'] as String;
          final email = data['email'] as String;
          final mobile = data['mobile'] as String;
          final isApproved = data['isapproved'] as bool;
          final createdAt = (data['createdAt'] as Timestamp).toDate();

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Image
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(certificateUrl),
                    backgroundColor: Colors.teal.shade100,
                  ),
                  const SizedBox(height: 16),
                  // Name
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Approval Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isApproved
                          ? Colors.green.shade100
                          : Colors.red.shade100,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isApproved ? Icons.check_circle : Icons.cancel,
                          color: isApproved ? Colors.green : Colors.red,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isApproved ? "Approved" : "Not Approved",
                          style: TextStyle(
                            color: isApproved
                                ? Colors.green.shade700
                                : Colors.red.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // User Details
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.email, color: Colors.teal),
                            title: Text("Email"),
                            subtitle: Text(email),
                          ),
                          Divider(),
                          ListTile(
                            leading: Icon(Icons.phone, color: Colors.teal),
                            title: Text("Mobile"),
                            subtitle: Text(mobile),
                          ),
                          Divider(),
                          ListTile(
                            leading: Icon(Icons.date_range, color: Colors.teal),
                            title: Text("Joined On"),
                            subtitle: Text(
                              "${createdAt.day}/${createdAt.month}/${createdAt.year}",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
