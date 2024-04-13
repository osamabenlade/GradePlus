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
    if (selectedFile == null) return;

    try {
      String fileName = selectedFile!.path.split('/').last; // Extracts the file name from the file path
      String semesterName="Semester"+selectedSemester!;
      Reference reference = FirebaseStorage.instance.ref().child('pdf/$semesterName/$selectedSubject/$fileName');
      UploadTask uploadTask = reference.putFile(selectedFile!);

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String downloadURL = await taskSnapshot.ref.getDownloadURL();

      // Now you have the download URL, you can save it to Firebase Database or do other tasks.
      print('File uploaded to Firebase Storage. Download URL: $downloadURL');

      // Now you have the download URL, you can save it to Firebase Firestore
      FirebaseFirestore.instance.collection(selectedSubject!).doc(documentName).set({
        'itemName': documentName, // Replace 'Document Name' with the actual document name entered by the user
        'link': downloadURL,
      });

      setState(() {
        selectedSemester = null;
        selectedSubject = null;
        selectedFile = null;
        documentName = '';
      });
    } catch (error) {
      print('Error uploading file: $error');
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  .collection("Semester"+selectedSemester!) // Assuming subjects are stored under collection with the same name as selected semester
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }

                List<DropdownMenuItem<String>> subjectItems = [];
                for (var subject in snapshot.data!.docs) {
                  subjectItems.add(
                    DropdownMenuItem(
                      child: Text(subject.id), // Assuming subject name is stored as document ID
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
                        // Handle the document name change
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
                // Add logic to handle file selection
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
              onPressed: () {
                // Add logic to upload document
                _uploadFile();
              },
              child: Text('Add Document'),
            ),
          ],
        ),
      ),
    );
  }


}
