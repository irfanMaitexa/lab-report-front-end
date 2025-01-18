import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // For formatting timestamps

class BookingListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bookings"),
        backgroundColor: Colors.teal,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('bookings')
            .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No bookings available',
                style: TextStyle(fontSize: 18, color: Colors.teal[800]),
              ),
            );
          }

          final bookings = snapshot.data!.docs;

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return BookingCard(
                isAccepted: booking['isAccepted'] ?? false,
                name: booking['name'] ?? 'No Name',
                age: booking['age'] ?? 0,
                gender: booking['gender'] ?? 'Not Specified',
                mobileNumber: booking['mobileNumber'] ?? 'No Number',
                timestamp: booking['timestamp'] != null
                    ? (booking['timestamp'] as Timestamp).toDate()
                    : null,
                doctorId: booking['doctorId'],
              );
            },
          );
        },
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final String name;
  final int age;
  final String gender;
  final String mobileNumber;
  final DateTime? timestamp;
  final bool isAccepted;
  final String doctorId;

  BookingCard({
    required this.name,
    required this.age,
    required this.gender,
    required this.mobileNumber,
    this.timestamp,
    required this.isAccepted,
    required this.doctorId,
  });

  void showDoctorDetails(BuildContext context, String doctorId) async {
    // Fetch the doctor's details from Firestore
    final doctorSnapshot = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(doctorId)
        .get();

    if (doctorSnapshot.exists) {
      final doctorData = doctorSnapshot.data()!;
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              doctorData['name'] ?? 'Doctor Details',
              style: TextStyle(color: Colors.teal),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (doctorData['certificateUrl'] != null)
                  Image.network(
                    doctorData['certificateUrl'],
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                  ),
                SizedBox(height: 16),
                Text(
                  'Email: ${doctorData['email'] ?? 'N/A'}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  'Mobile: ${doctorData['mobile'] ?? 'N/A'}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  'Created At: ${doctorData['createdAt'] != null ? DateFormat('yMMMd').format((doctorData['createdAt'] as Timestamp).toDate()) : 'N/A'}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    } else {
      // Show error if doctor data not found
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Doctor details not found.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Card(
            margin: EdgeInsets.only(bottom: 16),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => showDoctorDetails(context, doctorId),
                    child: Text(
                      'Doctor: Tap for details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal[900],
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Patient: $name',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[900],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Age: $age',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.teal[700],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Gender: $gender',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.teal[700],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Mobile: $mobileNumber',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.teal[700],
                    ),
                  ),
                  SizedBox(height: 8),
                  if (timestamp != null)
                    Text(
                      'Date: ${DateFormat('yMMMd').add_jm().format(timestamp!)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.teal[600],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isAccepted ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              isAccepted ? 'Accepted' : 'Pending',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
