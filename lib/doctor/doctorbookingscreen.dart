import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class DoctorBookingListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String doctorId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('bookings')
            .where('doctorId', isEqualTo: doctorId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No bookings found',
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
                name: booking['name'] ?? 'No Name',
                age: booking['age'] ?? 0,
                gender: booking['gender'] ?? 'Not Specified',
                mobileNumber: booking['mobileNumber'] ?? 'No Number',
                isAccepted: booking['isAccepted'] ?? false,
                timestamp: booking['timestamp'] != null
                    ? (booking['timestamp'] as Timestamp).toDate()
                    : null,
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
  final bool isAccepted;
  final DateTime? timestamp;

  BookingCard({
    required this.name,
    required this.age,
    required this.gender,
    required this.mobileNumber,
    required this.isAccepted,
    this.timestamp,
  });

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
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 18,
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
