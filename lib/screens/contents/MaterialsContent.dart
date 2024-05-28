import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../components/pdfViewer.dart';

class MaterialsContent extends StatelessWidget {
  final String type;
  final String subjectData;

  MaterialsContent(this.subjectData, this.type);

  Future<void> openFile({required String url, required String fileName}) async {
    final file = await downloadFile(url, fileName);
    if (file == null) {
      print('Error: Unable to download file.');
      return;
    }
    print('Path: ${file.path}');
    OpenFile.open(file.path);
  }

  Future<File?> downloadFile(String url, String fileName) async {
    final status = await Permission.storage.request();
    if (!status.isGranted) {
      print('Storage permission not granted');
      return null;
    }

    try {
      final response = await Dio().get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: 0,
        ),
      );

      return await downloadFileLocally(response, fileName);
    } catch (e) {
      print('Error downloading file: $e');
      return null;
    }
  }

  Future<File?> downloadFileLocally(Response<dynamic> response, String fileName) async {
    Directory? directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    final fullPath = '${directory?.path}/NewDirectory';

    Directory(fullPath).createSync(recursive: true);

    List<int> intList = [];

    if (response.data != null) {
      intList = response.data.cast<int>().toList();
    }

    Uint8List bytes = Uint8List.fromList(intList);

    File file = File('$fullPath/$fileName.pdf');

    try {
      await file.writeAsBytes(
          bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
      return file;
    } catch (err) {
      print('Error writing file: $err');
      return null;
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
                      onPressed: () async {
                        await openFile(url: itemLink, fileName: itemName);
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
