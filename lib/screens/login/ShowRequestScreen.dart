import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import '../components/pdfViewer.dart';

class ShowRequestsScreen extends StatefulWidget {
  @override
  _ShowRequestsScreenState createState() => _ShowRequestsScreenState();
}

class _ShowRequestsScreenState extends State<ShowRequestsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Requests').snapshots(),
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

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No data available'),
            );
          }

          List<String> subjectNames = snapshot.data!.docs.map((doc) => doc.id).toList();

          return ListView.builder(
            itemCount: subjectNames.length,
            itemBuilder: (context, index) {
              String subjectName = subjectNames[index];
              print("sub $subjectName");

              return FutureBuilder<List<Widget>>(
                future: _buildRequestItems(subjectName, context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return Text('Error11: ${snapshot.error}');
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...snapshot.data!,
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<List<Widget>> _buildRequestItems(String subjectName, BuildContext context) async {
    List<Widget> requestItems = [];

    QuerySnapshot materialsSnapshot = await FirebaseFirestore.instance.collection('Requests').doc(subjectName).collection('materials').get();
    List<QueryDocumentSnapshot> materialsDocuments = materialsSnapshot.docs;

    QuerySnapshot pyqsSnapshot = await FirebaseFirestore.instance.collection('Requests').doc(subjectName).collection('pyq').get();
    List<QueryDocumentSnapshot> pyqsDocuments = pyqsSnapshot.docs;

    for (var document in materialsDocuments) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      String description = data['itemName'];
      String link = data['link'];
      String fileName=document.id;

      requestItems.add(_buildRequestItem(subjectName, 'materials', description, link, context,fileName));
    }

    for (var document in pyqsDocuments) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      String description = data['itemName'];
      String link = data['link'];
      String fileName=document.id;

      requestItems.add(_buildRequestItem(subjectName, 'pyq', description, link, context,fileName));
    }

    return requestItems;
  }

  Widget _buildRequestItem(String subjectName, String docType, String description, String link, BuildContext context,String fileName) {
    Future<void> deleteItem() async {
      try {

        // Delete the document from Firestore
        await FirebaseFirestore.instance
            .collection('Requests')
            .doc(subjectName)
            .collection(docType)
            .doc(fileName)
            .delete();
        setState(() {});
      } catch (e) {
        print('Error deleting document: $e');
        // Handle error here
      }
    }
    Future<void> _uploadFile() async {
      try {
        print("link check $link");
        // Upload document details to Firestore
        FirebaseFirestore.instance.collection('Subjects').doc(subjectName!).collection(docType).doc(fileName).set({
          'itemName': fileName,
          'link': link,
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Document uploaded successfully'),
          duration: Duration(seconds: 3),
        ));
        deleteItem();
      } catch (error) {
        print('Error uploading file: $error');
      }
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        elevation: 4,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Subject: $subjectName',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Type: $docType',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Description: $description',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.visibility),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PdfViewer(link, description),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.check,color: Colors.green,size: 30,),
                    onPressed: () {
                      // Add your onPressed logic for the tick icon
                      _uploadFile();

                    },
                  ),
                  SizedBox(width: 16),
                  IconButton(
                    icon: Icon(Icons.close,color: Colors.red,size: 30,),
                    onPressed: () {
                      // Add your onPressed logic for the wrong icon
                      deleteItem();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
