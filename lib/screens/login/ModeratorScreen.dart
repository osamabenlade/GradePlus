import 'package:flutter/material.dart';

import '../../firebase_services.dart';
import '../AddDocumentScreen.dart';

class ModeratorScreen extends StatefulWidget {
  final String name;
  final String uid;
  final String email;

  ModeratorScreen({
    required this.name,
    required this.uid,
    required this.email,
  });

  @override
  _ModeratorScreenState createState() => _ModeratorScreenState();
}

class _ModeratorScreenState extends State<ModeratorScreen> {
  String? selectedSemester;
  String? selectedSubject;
  void _addDocument(BuildContext context) {
    // Implement logic to add document
    // For example, you can navigate to another screen for adding a document
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddDocumentScreen(),
      ),
    );
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Moderators Screen'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              FirebaseServices().googleSignOut();
              Navigator.pop(context); // Go back to the previous screen after signing out
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${widget.name}', // Accessing name from widget
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              'UID: ${widget.uid}', // Accessing uid from widget
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              'Email: ${widget.email}', // Accessing email from widget
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement logic to add document
                _addDocument(context);
              },
              child: Text('Add Document'),
            ),
          ],
        ),
      ),
    );
  }
}
