import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class AddLinkScreen extends StatefulWidget {
  final String fileType;

  const AddLinkScreen({required this.fileType});
  @override
  _AddLinkScreenState createState() => _AddLinkScreenState();
}

class _AddLinkScreenState extends State<AddLinkScreen> {
  final _formKey = GlobalKey<FormState>();
  String? selectedSemester;
  String? selectedSubject;
  String? selectedBranch;
  File? selectedFile;
  String? documentName;
  String? documentLink;
  bool _uploading = false;


  List<String> semesters = ['1', '2', '3','4','5','6','7','8']; // Example semesters
  List<String> branch = ['IT', 'ITBI', 'ECE'];


  Future<void> _uploadFile() async {
    // Validate the form before uploading
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _uploading = true;
    });

    try {
      String docType = widget.fileType;
      // Upload document details to Firestore
      FirebaseFirestore.instance.collection('Subjects').doc(selectedSubject!).collection(docType).doc(documentName).set({
        'itemName': documentName,
        'link': documentLink,
      });

      setState(() {
        _uploading = false;
        selectedSemester = null;
        selectedSubject = null;
        selectedFile = null;
        documentName = '';
        selectedBranch = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Link added successfully'),
        duration: Duration(seconds: 3),
      ));
    } catch (error) {
      print('Error adding link: $error');
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
            backgroundColor: Colors.blue[700],
            iconTheme: IconThemeData(color: Colors.white),
            title: Text('Add Links',style: TextStyle(color: Colors.white),),
          ),
          body: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedSemester,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedSemester = newValue;
                        selectedBranch = null; // Reset
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
                  SizedBox(height: 20,),
                  selectedSemester != null ?
                  DropdownButtonFormField<String>(
                    value: selectedBranch,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedBranch = newValue;
                        selectedSubject = null; // Reset selected subject when changing semester
                      });
                    },
                    items: branch.map((branch) {
                      return DropdownMenuItem<String>(
                        value: branch,
                        child: Text(branch),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Select Branch',
                      border: OutlineInputBorder(),
                    ),
                  ): Container(),
                  SizedBox(height: 20),
                  selectedBranch != null
                      ? StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("Semester" + selectedSemester!).doc(selectedBranch).collection('sub')
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a document name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20,),
                          TextFormField(
                            onChanged: (value) {
                              setState(() {
                                documentLink = value;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Paste link here',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter link';
                              }
                              return null;
                            },
                          ),
                        ],
                      );
                    },
                  )
                      : Container(),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF9E6FE5), // Change the background color here
                      ),
                      onPressed: _uploading ? null : _uploadFile,
                      child: Text('Add Link',style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ],
              ),
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
