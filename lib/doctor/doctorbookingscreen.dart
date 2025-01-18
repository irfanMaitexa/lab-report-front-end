import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class BookingListScreen extends StatefulWidget {
  @override
  _BookingListScreenState createState() => _BookingListScreenState();
}

class _BookingListScreenState extends State<BookingListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Pending'),
            Tab(text: 'Accepted'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Pending Tab
          BookingList(
            isAcceptedFilter: false,
          ),
          // Accepted Tab
          BookingList(
            isAcceptedFilter: true,
          ),
        ],
      ),
    );
  }
}

class BookingList extends StatelessWidget {
  final bool isAcceptedFilter;

  BookingList({required this.isAcceptedFilter});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('bookings')
          .where('doctorId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .where('isAccepted', isEqualTo: isAcceptedFilter)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              isAcceptedFilter
                  ? 'No accepted bookings available'
                  : 'No pending bookings available',
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
              onAccept: () {
                FirebaseFirestore.instance
                    .collection('bookings')
                    .doc(booking.id)
                    .update({'isAccepted': true});
              },
              onReject: () {
                FirebaseFirestore.instance
                    .collection('bookings')
                    .doc(booking.id)
                    .delete();
              },
              showActions: !isAcceptedFilter,
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
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final bool showActions;

  BookingCard({
    required this.name,
    required this.age,
    required this.gender,
    required this.mobileNumber,
    this.timestamp,
    required this.isAccepted,
    this.onAccept,
    this.onReject,
    required this.showActions,
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
                  if (showActions)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: onAccept,
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.green,
                   
                          ),
                          child: Text('Accept'),
                        ),
                        SizedBox(width: 8),
                        TextButton(
                          onPressed: onReject,
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.red,
                            
                          ),
                          child: Text('Reject'),
                        ),
                      ],
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
