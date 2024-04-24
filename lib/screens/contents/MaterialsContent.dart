import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart'; // Import file picker package
import '../components/pdfViewer.dart';

class MaterialsContent extends StatelessWidget {
  final String type;
  final String subjectData;

  MaterialsContent(this.subjectData, this.type);

  Future<void> _downloadFile(String url, String fileName, BuildContext context) async {
    Dio dio = Dio();
    try {
      // Request storage permission
      final permissionStatus = await Permission.storage.request();
      if (permissionStatus.isGranted) {
        // Let the user choose a directory
        String? saveDirectory = await FilePicker.platform.getDirectoryPath();
        if (saveDirectory != null) {
          // Append the file name to the directory path
          String savePath = '$saveDirectory/$fileName';
          print("URL: $url");
          print("Save Path: $savePath");

          await dio.download(url, savePath);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('File downloaded successfully.'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No directory selected.'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Storage permission denied.'),
          ),
        );
      }
    } catch (e) {
      print("Error fetching directory path: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to fetch directory path: $e'),
        ),
      );
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Subjects')
            .doc(subjectData)
            .collection(type)
            .snapshots(),
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

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot document = snapshot.data!.docs[index];
              Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

              if (data == null || data.isEmpty) {
                return SizedBox();
              }

              String itemName = data['itemName'];
              String itemLink = data['link'];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Card(
                  elevation: 4,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: IconButton(
                      icon: Icon(Icons.download),
                      onPressed: () {
                        _downloadFile(itemLink, itemName, context);
                      },
                    ),
                    title: Text(itemName),
                    trailing: IconButton(
                      icon: Icon(Icons.visibility),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PdfViewer(itemLink, itemName),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
