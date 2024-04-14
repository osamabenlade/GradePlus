import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class AddDocumentScreen extends StatefulWidget {
  @override
  _AddDocumentScreenState createState() => _AddDocumentScreenState();
}

class _AddDocumentScreenState extends State<AddDocumentScreen> {
  String? selectedSemester;
  String? selectedSubject;
  File? selectedFile;
  String? documentName;
  bool _uploading = false;

  List<String> semesters = ['1', '2', '3','4','5','6','7','8']; // Example semesters

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _uploadFile() async {
    if (selectedFile == null || selectedSubject == null || documentName == null) return;

    setState(() {
      _uploading = true;
    });

    try {
      String fileName = selectedFile!.path.split('/').last;
      String semesterName = "Semester" + selectedSemester!;
      Reference reference = FirebaseStorage.instance.ref().child('pdf/$semesterName/$selectedSubject/$fileName');
      UploadTask uploadTask = reference.putFile(selectedFile!);

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String downloadURL = await taskSnapshot.ref.getDownloadURL();

      // Upload document details to Firestore
      await FirebaseFirestore.instance.collection(selectedSubject!).doc(documentName).set({
        'itemName': documentName,
        'link': downloadURL,
      });

      setState(() {
        _uploading = false;
        selectedSemester = null;
        selectedSubject = null;
        selectedFile = null;
        documentName = '';
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
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text('Add Document'),
          ),
          body: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedSemester,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedSemester = newValue;
                      selectedSubject = null; // Reset selected subject when changing semester
                    });
                  },
                  items: semesters.map((semester) {
                    return DropdownMenuItem<String>(
                      value: semester,
                      child: Text(semester),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Select Semester',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                selectedSemester != null
                    ? StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Semester" + selectedSemester!)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }

                    List<DropdownMenuItem<String>> subjectItems = [];
                    for (var subject in snapshot.data!.docs) {
                      subjectItems.add(
                        DropdownMenuItem(
                          child: Text(subject.id),
                          value: subject.id,
                        ),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButtonFormField<String>(
                          value: selectedSubject,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedSubject = newValue;
                            });
                          },
                          items: subjectItems,
                          decoration: InputDecoration(
                            labelText: 'Select Subject',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          onChanged: (value) {
                            setState(() {
                              documentName = value;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Document Name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    );
                  },
                )
                    : Container(),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _pickFile();
                  },
                  child: Text('Choose PDF File'),
                ),
                SizedBox(height: 10),
                selectedFile != null
                    ? Text(
                  'Selected File: ${selectedFile!.path}',
                  style: TextStyle(fontSize: 16),
                )
                    : Container(),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _uploading ? null : _uploadFile,
                  child: Text('Add Document'),
                ),
              ],
            ),
          ),
        ),
        if (_uploading)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}