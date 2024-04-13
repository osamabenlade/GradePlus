import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddModeratorScreen extends StatefulWidget {
  @override
  _AddModeratorScreenState createState() => _AddModeratorScreenState();
}

class _AddModeratorScreenState extends State<AddModeratorScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _uidController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _uidController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Moderator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _uidController,
              decoration: InputDecoration(labelText: 'UID'),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {

                // Get the values from the text fields
                String email = _emailController.text;
                String name = _nameController.text;
                String uid = _uidController.text;
                List<String>? parts = email?.split('@');
                String? emailWithoutDomain = parts?.first;

                // Validate input if needed
                DatabaseReference moderatorRef = FirebaseDatabase.instance.reference().child("moderators").child(emailWithoutDomain!);

                await moderatorRef.set({
                  "name": name,
                  "id": uid,
                });
                // Add your logic to save the moderator details here

                // Clear the text fields after saving
                _emailController.clear();
                _nameController.clear();
                _uidController.clear();
              },
              child: Text('Add Moderator'),
            ),
          ],
        ),
      ),
    );
  }
}
