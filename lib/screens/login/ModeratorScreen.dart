import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../firebase_services.dart';
import '../AddDocumentScreen.dart';

import 'ShowRequestScreen.dart'; // Import the screen for showing requests

class ModeratorScreen extends StatefulWidget {
  @override
  _ModeratorScreenState createState() => _ModeratorScreenState();
}

class _ModeratorScreenState extends State<ModeratorScreen> {
  String? selectedSemester;
  String? selectedSubject;

  void _addDocument(BuildContext context, String doctype) {
    // Implement logic to add document
    // For example, you can navigate to another screen for adding a document
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddDocumentScreen(fileType: doctype,),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String name = user?.displayName ?? '';
    String email = user?.email ?? '';

    return DefaultTabController(
      length: 2, // Define the number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Moderators Screen',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue[700],
          iconTheme: IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                FirebaseServices().googleSignOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
          bottom: TabBar( // Define the TabBar
            tabs: [
              Tab(text: 'Home'), // First tab
              Tab(text: 'Show Requests'), // Second tab
            ],
          ),
        ),
        body: TabBarView( // Define the TabBarView
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name: ${name}',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'UID: ${name}',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Email: ${email}',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: () {
                            _addDocument(context, 'materials');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 12.0,
                            ),
                            child: Text(
                              'Add Document',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: () {
                            _addDocument(context, 'pyq');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 12.0,
                            ),
                            child: Text(
                              'Add Pyqs',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: () {
                            // Implement logic to add links
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 12.0,
                            ),
                            child: Text(
                              'Add Links',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Second tab content
            ShowRequestsScreen(), // ShowRequestsScreen should be implemented separately
          ],
        ),
      ),
    );
  }
}
