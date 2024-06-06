import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'dart:io';

import 'ChatScreen.dart';
import 'contents/LinksContent.dart';
import 'contents/MaterialsContent.dart';


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

  Future<void> _uploadFile(String desc, String docType) async {
    String? selectedSubject = widget.subjectData['subjectCode'];
    if (selectedFile == null || selectedSubject == null || desc == null) return;

    setState(() {
      _uploading = true;
    });

    try {
      String fileName = selectedFile!.path.split('/').last;
      Reference reference =
      FirebaseStorage.instance.ref().child('requests/$selectedSubject/$docType/$fileName');
      UploadTask uploadTask = reference.putFile(selectedFile!);

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      print("link check $downloadURL");
      // Upload document details to Firestore
      await FirebaseFirestore.instance
          .collection('Requests')
          .doc(selectedSubject)
          .collection(docType)
          .doc(fileName)
          .set({
        'itemName': desc,
        'link': downloadURL,
      });
      await FirebaseFirestore.instance.collection('Requests').doc(selectedSubject).set({
        'subjectCode': selectedSubject,
        'semester': widget.semester,
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
      String? errorMessage = '';
      String? _description;
      final _formKey = GlobalKey<FormState>();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: Text('Upload $filetype'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Form(
                        key: _formKey,
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'Description'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter description';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _description = value;
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
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
                      SizedBox(height: 10,),
                      if (selectedFile != null) Text('Selected file: ${selectedFile!.path.split('/').last}'),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _uploading = false;
                              selectedSubject = null;
                              selectedFile = null;
                              desc = '';
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel'),
                          ),
                          Spacer(),
                          _uploading
                              ? CircularProgressIndicator()
                              : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF9E6FE5), // Change the background color here
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                              } else {
                                return;
                              }
                              if (selectedFile == null || _description == null || _description!.isEmpty) {
                                setState(() {
                                  errorMessage = 'Please choose a file';
                                });
                                return;
                              }
                              // Implement upload functionality here
                              if (_uploading) return;
                              setState(() {
                                _uploading = true;
                              });
                              await _uploadFile(_description!, filetype);
                              setState(() {
                                _uploading = false;
                              });
                              Navigator.of(context).pop();
                            },
                            child: Text('Upload',style: TextStyle(color: Colors.white),),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      if (errorMessage != null && errorMessage!.isNotEmpty)
                        Text(errorMessage!, style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              );
            },
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
                    builder: (context) => ChatScreen(getChatroom(widget.subjectData['subjectCode'], widget.semester)),
                  ),
                );
              },
            ),
          ],
          iconTheme: IconThemeData(color: Colors.white),
          bottom: TabBar(
            indicatorColor: Colors.white, // Color of the indicator (underline)
            indicatorWeight: 5.0, // Thickness of the indicator
            labelColor: Colors.white, // Color of the selected tab label
            unselectedLabelColor: Colors.white70, // Color of the unselected tab labels
            labelStyle: TextStyle(
              fontSize: 18.0, // Font size of the selected tab label
              fontWeight: FontWeight.bold, // Font weight of the selected tab label
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 14.0, // Font size of the unselected tab labels
            ),
            indicatorSize: TabBarIndicatorSize.tab,
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
                text: 'Links',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MaterialsContent(widget.subjectData['subjectCode'], 'materials'),
            MaterialsContent(widget.subjectData['subjectCode'], 'pyq'),
            LinksContent(widget.subjectData['subjectCode']),
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
