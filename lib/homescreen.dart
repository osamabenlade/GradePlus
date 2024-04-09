import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gradeplus/screens/subjects/SubjectScreen.dart';


class SubjectListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Subject List',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue[700],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Semester4').snapshots(),
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


void main() {
  runApp(MaterialApp(
    home: SubjectListScreen(),
  ));
}

