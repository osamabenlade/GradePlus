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
      Map<dynamic, dynamic>? moderatorsData = snapshot.value as Map<
          dynamic,
          dynamic>?;
      if (moderatorsData != null) {
        moderatorsData.forEach((key, value) {
          setState(() {
            _moderatorsList.add({
              'id': value['id'],
              'name': value['name'],
            });
          });
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Moderators List'),
      ),
      body: _moderatorsList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _moderatorsList.length,
        itemBuilder: (context, index) {
          final moderator = _moderatorsList[index];
          return ListTile(
            title: Text(moderator['name']),
            subtitle: Text(moderator['id']),
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
                                // Delete the moderator from Firebase
                                final ref = FirebaseDatabase.instance.ref().child('moderators').child(moderator['email']);
                                ref.remove().then((_) {
                                  print('Moderator deleted successfully');
                                  setState(() {
                                    _moderatorsList.removeAt(index); // Remove the deleted item from the list
                                  });
                                }).catchError((error) {
                                  print('Failed to delete moderator: $error');
                                });
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
          );
        },
      ),
    );
  }

}

