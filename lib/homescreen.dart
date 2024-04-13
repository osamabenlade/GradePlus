import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gradeplus/screens/components/ChatScreen.dart';
import 'package:gradeplus/screens/login/login_screen.dart';
import 'package:gradeplus/screens/subjects/SubjectScreen.dart';

import 'firebase_services.dart';


class SubjectListScreen extends StatelessWidget {
  final int semester;
  final int batch;
  final String branch;

  SubjectListScreen({
    required this.semester,
    required this.batch,
    required this.branch,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Subject List',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue[700],
        actions: <Widget>[ // Add actions to the app bar
          IconButton(
            icon: Icon(Icons.chat), // Add chat icon
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              FirebaseServices().googleSignOut();
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
              );
              // Go back to the previous screen after signing out
            },
          ),
        ],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection(getSemesterName(semester)).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.separated(
            itemCount: snapshot.data!.docs.length,
            separatorBuilder: (BuildContext context, int index) => Divider(),
            itemBuilder: (BuildContext context, int index) {
              DocumentSnapshot document = snapshot.data!.docs[index];
              Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

              if (data == null) {
                return SizedBox();
              }

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: Image.network(
                    data['iconUrl'],
                    height: 60,
                    width: 80,
                  ),
                  title: Text(data['subjectCode'], style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),),
                  subtitle: Text(data['subjectName']),
                  trailing: Icon(
                    Icons.keyboard_arrow_right,
                    size: 30,
                    color: Colors.black,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SubjectScreen(data)),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
String getSemesterName(int semesterNumber) {
  return 'Semester$semesterNumber';
}

