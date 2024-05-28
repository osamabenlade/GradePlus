import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class DownloadScreen extends StatefulWidget {
  @override
  _DownloadScreenState createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  List<FileSystemEntity> _pdfFiles = [];

  @override
  void initState() {
    super.initState();
    _listPDFFiles();
  }

  Future<void> _listPDFFiles() async {
    final directoryPath = '/storage/emulated/0/Android/data/com.example.gradeplus/files/NewDirectory/';
    Directory directory;
    try {
      directory = Directory(directoryPath);
      if (directory.existsSync()) {
        final pdfFiles = directory
            .listSync()
            .where((file) => file.path.endsWith('.pdf'))
            .toList();
        print("Found PDF files: ${pdfFiles.map((file) => file.path).toList()}");
        setState(() {
          _pdfFiles = pdfFiles;
        });
      } else {
        print('Directory does not exist');
      }
    } catch (e) {
      print('Error: $e');
    }
  }


  void _openFile(FileSystemEntity file) {
    OpenFile.open(file.path);
  }

  Future<void> _refreshFiles() async {
    await _listPDFFiles();
  }
  Future<void> _confirmDelete(FileSystemEntity file) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this file?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () async {
                Navigator.of(context).pop(); // Dismiss the dialog
                await _deleteFile(file); // Call the delete file method
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteFile(FileSystemEntity file) async {
    try {
      if (await file.exists()) {
        await file.delete();
        setState(() {
          _pdfFiles.remove(file);
        });
      }
    } catch (e) {
      // Handle any errors that might occur during deletion
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to delete the file: ${e.toString()}'),
      ));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pdfFiles.isEmpty
          ? Center(child: Text('No PDF files found.'))
          : RefreshIndicator(
        onRefresh: _refreshFiles,
        child: ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 4.0,horizontal: 8.0),
          itemCount: _pdfFiles.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 4,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              margin: EdgeInsets.symmetric(vertical: 6.0),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                title: Text(_pdfFiles[index].path.split('/').last),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.remove_red_eye),
                      onPressed: () => _openFile(_pdfFiles[index]),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _confirmDelete(_pdfFiles[index]),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class PDFViewerScreen extends StatelessWidget {
  final FileSystemEntity file;

  PDFViewerScreen({required this.file});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(file.path.split('/').last),
      ),
      body: SfPdfViewer.file(
        File(file.path),
      ),
    );
  }
}
