import 'package:email_validator/email_validator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddModeratorScreen extends StatefulWidget {
  @override
  _AddModeratorScreenState createState() => _AddModeratorScreenState();
}

class _AddModeratorScreenState extends State<AddModeratorScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _uidController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _uidController.dispose();
    super.dispose();
  }

  void _addModerator() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Get the values from the text fields
      String email = _emailController.text;
      String name = _nameController.text;
      String uid = _uidController.text;
      List<String>? parts = email.split('@');
      String? emailWithoutDomain = parts?.first;

      // Save to Firebase
      DatabaseReference moderatorRef = FirebaseDatabase.instance.reference().child("moderators").child(emailWithoutDomain!);

      await moderatorRef.set({
        "name": name,
        "id": uid,
        "email":emailWithoutDomain,
      });

      setState(() {
        _isLoading = false;
      });

      // Clear the text fields after saving
      _emailController.clear();
      _nameController.clear();
      _uidController.clear();

      // Optionally show a success message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Moderator added successfully')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Add Moderator', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }
                  if (!EmailValidator.validate(value)) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _uidController,
                decoration: InputDecoration(
                  labelText: 'Enrollment No',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter enrollment no';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),
              Center(
                child: _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF9E6FE5), // Change the background color here
                  ),
                  onPressed: _addModerator,
                  child: Text('Add', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
