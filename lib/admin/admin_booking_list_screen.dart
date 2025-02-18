import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // For formatting timestamps

class AdminBookingListScreen extends StatefulWidget {
  @override
  _AdminBookingListScreenState createState() => _AdminBookingListScreenState();
}

class _AdminBookingListScreenState extends State<AdminBookingListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
     
        backgroundColor: Colors.teal,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Accepted'),
            Tab(text: 'Pending'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBookingList(true), // Accepted bookings
          _buildBookingList(false), // Pending bookings
        ],
      ),
    );
  }

  Widget _buildBookingList(bool isAccepted) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('bookings')
          .where('isAccepted', isEqualTo: isAccepted)
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
            );
          },
        );
      },
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

  BookingCard({
    required this.name,
    required this.age,
    required this.gender,
    required this.mobileNumber,
    this.timestamp,
    required this.isAccepted,
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
