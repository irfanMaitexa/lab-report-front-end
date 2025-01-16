import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Two tabs: Accepted and Pending
      child: Scaffold(
        backgroundColor: Colors.teal[50],
        appBar: AppBar(
          backgroundColor: Colors.teal,
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Accepted'),
              Tab(text: 'Pending'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            DoctorList(tab: 'Accepted'),
            DoctorList(tab: 'Pending'),
          ],
        ),
      ),
    );
  }
}

class DoctorList extends StatelessWidget {
  final String tab;

  DoctorList({required this.tab});

  @override
  Widget build(BuildContext context) {
    // Query Firestore for the appropriate data
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('doctors')
          .where('isapproved', isEqualTo: tab == 'Accepted')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text('No $tab doctors available'),
          );
        }

        final doctors = snapshot.data!.docs;

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: doctors.length,
          itemBuilder: (context, index) {
            final doctor = doctors[index];
            final name = doctor['name'] ?? 'No Name';
            final mobile = doctor['mobile'] ?? 'No Mobile';
            final certificateUrl = doctor['certificateUrl'] ?? '';

            return Card(
              margin: EdgeInsets.only(bottom: 16),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
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
                          mobile,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.teal[600],
                          ),
                        ),
                        SizedBox(height: 8),
                        InkWell(
                          onTap: () {
                            _showFullScreenDocument(
                                context, name, mobile, certificateUrl);
                          },
                          child: Row(
                            children: [
                              Icon(Icons.insert_drive_file,
                                  color: Colors.teal[600]),
                              SizedBox(width: 8),
                              Text(
                                'View Document',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.teal[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        if (!doctor['isapproved']) // Show Accept button only if not approved
                          ElevatedButton(
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('doctors')
                                  .doc(doctor.id)
                                  .update({'isapproved': true});
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Accepted $name')),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal[600],
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Accept',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            if (doctor['isapproved']) {
                              // If already approved, delete the record
                              FirebaseFirestore.instance
                                  .collection('doctors')
                                  .doc(doctor.id)
                                  .delete();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Deleted $name')),
                              );
                            } else {
                              // Otherwise, reject the record
                              FirebaseFirestore.instance
                                  .collection('doctors')
                                  .doc(doctor.id)
                                  .delete();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Rejected $name')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                doctor['isapproved'] ? Colors.red : Colors.teal[300],
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            doctor['isapproved'] ? 'Delete' : 'Reject',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showFullScreenDocument(
      BuildContext context, String name, String mobile, String certificateUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.all(16),
          backgroundColor: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
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
                        mobile,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.teal[600],
                        ),
                      ),
                      SizedBox(height: 16),
                      certificateUrl.isNotEmpty
                          ? Image.network(
                              certificateUrl,
                              fit: BoxFit.contain,
                            )
                          : Text(
                              'No certificate available',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}


