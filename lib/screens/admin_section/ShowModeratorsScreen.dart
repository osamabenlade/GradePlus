import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ShowModerators extends StatefulWidget {
  @override
  _ShowModeratorsState createState() => _ShowModeratorsState();
}

class _ShowModeratorsState extends State<ShowModerators> {
  late DatabaseReference _moderatorsRef;
  List<Map<String, dynamic>> _moderatorsList = [];

  @override
  void initState() {
    super.initState();
    _moderatorsRef = FirebaseDatabase.instance.reference().child('moderators');
    _fetchModeratorsData();
  }

  Future<void> _fetchModeratorsData() async {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('moderators').get();
    if (snapshot.exists) {
      Map<dynamic, dynamic>? moderatorsData = snapshot.value as Map<dynamic, dynamic>?;
      if (moderatorsData != null) {
        moderatorsData.forEach((key, value) {
          setState(() {
            _moderatorsList.add({
              'email': key,
              'id': value['id'],
              'name': value['name'],
            });
          });
        });
      }
    }
  }

  void _deleteModerator(String email, int index) {
    final ref = FirebaseDatabase.instance.ref().child('moderators').child(email);
    ref.remove().then((_) {
      print('Moderator deleted successfully');
      setState(() {
        _moderatorsList.removeAt(index); // Remove the deleted item from the list
      });
    }).catchError((error) {
      print('Failed to delete moderator: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Moderators List', style: TextStyle(color: Colors.white)),
      ),
      body: _moderatorsList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _moderatorsList.length,
        itemBuilder: (context, index) {
          final moderator = _moderatorsList[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              title: Text(moderator['name'],style: TextStyle(fontSize: 16),),
              subtitle: Text(moderator['id'],style: TextStyle(fontSize: 12),),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      // Show an alert dialog
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Confirm Deletion'),
                            content: Text('Are you sure you want to delete this moderator?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  // Handle 'Yes' button tap
                                  _deleteModerator(moderator['email'], index);
                                  // Close the alert dialog
                                  Navigator.of(context).pop();
                                },
                                child: Text('Yes'),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Handle 'No' button tap
                                  Navigator.of(context).pop(); // Close the alert dialog
                                },
                                child: Text('No'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
