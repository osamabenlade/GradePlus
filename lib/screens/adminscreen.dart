import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradeplus/screens/ShowModeratorsScreen.dart';
import 'package:gradeplus/screens/addModerator.dart';

import '../firebase_services.dart';

class AdminScreen extends StatelessWidget {
  final String name;
  final String email;

  const AdminScreen({Key? key, required this.name, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Screen'),
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Name: $name',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              'Email: $email',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20), // Add some space between the user info and the card
            Card(
              elevation: 4, // Add elevation for a shadow effect
              margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8), // Add margin for spacing between tiles
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Add rounded corners to the tile
              ),
              child: ListTile(
                title: Text('Add moderators'), // Replace 'Your Tile Text' with the text you want to display
                onTap: () {
                  // Add any action you want to perform when the tile is tapped
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddModeratorScreen()));
                },
              ),

            ),
            SizedBox(height: 20),
            Card(
              elevation: 4, // Add elevation for a shadow effect
              margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8), // Add margin for spacing between tiles
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Add rounded corners to the tile
              ),
              child: ListTile(
                title: Text('Show moderators'), // Replace 'Your Tile Text' with the text you want to display
                onTap: () {
                  // Add any action you want to perform when the tile is tapped
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ShowModerators()));
                },
              ),

            ),
          ],
        ),
      ),
    );
  }
}
