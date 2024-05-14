import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:file_picker/file_picker.dart';

import '../components/ChatScreen.dart';
import '../contents/MaterialsContent.dart';
import '../contents/VideoLinksContent.dart';
import 'dart:io';

import '../login/login_detail_screen.dart';

class SubjectScreen extends StatefulWidget {
  final Map<dynamic, dynamic> subjectData;
  final String semester;



  SubjectScreen(this.subjectData, this.semester);

  @override
  _SubjectScreenState createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  File? selectedFile;
  String? desc;
  bool _uploading = false;
  String? selectedSubject;

  Future<void> _uploadFile(String desc,String docType) async {
    String? selectedSubject = widget.subjectData['subjectCode'];
    if (selectedFile == null || selectedSubject == null || desc == null) return;

    setState(() {
      _uploading = true;
    });

    try {

      String fileName = selectedFile!.path.split('/').last;
      Reference reference = FirebaseStorage.instance.ref().child('requests/$selectedSubject/$docType/$fileName');
      UploadTask uploadTask = reference.putFile(selectedFile!);

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      print("link check $downloadURL");
      // Upload document details to Firestore
      FirebaseFirestore.instance.collection('Requests').doc(selectedSubject!).collection(docType).doc(fileName).set({
        'itemName': desc,
        'link': downloadURL,
      });
      FirebaseFirestore.instance.collection('Requests').doc(selectedSubject!).set({
        'subjectCode': selectedSubject,
        'semester':semester,
      });

      setState(() {
        _uploading = false;
        selectedSubject = null;
        selectedFile = null;
        desc = '';
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Document uploaded successfully'),
        duration: Duration(seconds: 3),
      ));
    } catch (error) {
      print('Error uploading file: $error');
      setState(() {
        _uploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    void _showUploadMaterialDialog(String filetype) {

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Upload $filetype'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(labelText: 'Description'),
                    onChanged: (value) {
                      desc = value;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      // Implement upload functionality here
                      if (_uploading) return;
                      await _uploadFile(desc!,filetype);
                      Navigator.of(context).pop();
                    },
                    child: Text('Upload'),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['pdf'],
                  );
                  if (result != null) {
                    setState(() {
                      selectedFile = File(result.files.single.path!);
                    });
                  }
                },
                child: Text('Choose PDF'),
              ),
            ],
          );
        },
      );
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.subjectData['subjectCode'],
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue[700],
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.chat),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ChatScreen(getChatroom(widget.subjectData['subjectCode'], widget.semester)),
                  ),
                );
              },
            ),
          ],
          iconTheme: IconThemeData(color: Colors.white),
          bottom: TabBar(
            indicatorColor: Colors.white,
            unselectedLabelColor: Colors.blue[300],
            tabs: [
              Tab(
                icon: Icon(Icons.book),
                text: 'Materials',
              ),
              Tab(
                icon: Icon(Icons.assignment),
                text: 'PYQs',
              ),
              Tab(
                icon: Icon(Icons.video_library),
                text: 'Video Links',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MaterialsContent(widget.subjectData['subjectCode'], 'materials'),
            MaterialsContent(widget.subjectData['subjectCode'], 'pyq'),
            VideoLinksContent(widget.subjectData['subjectCode']),
          ],
        ),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          backgroundColor: Colors.blue[700],
          overlayColor: Colors.black,
          overlayOpacity: 0.5,
          children: [
            SpeedDialChild(
              child: Icon(Icons.file_upload),
              backgroundColor: Colors.blue,
              label: 'Upload PYQs',
              onTap: () {
                // Action when Upload PDF option is tapped
                // Navigator.pop(context);
                _showUploadMaterialDialog('pyq');
              },
            ),
            SpeedDialChild(
              child: Icon(Icons.upload_rounded),
              backgroundColor: Colors.blue,
              label: 'Upload Materials',
              onTap: () {
                // Show upload material dialog
                _showUploadMaterialDialog('materials');
              },
            ),
          ],
        ),
      ),
    );
  }
}

String getChatroom(String code, String sem) {
  return '$code$sem';
}
