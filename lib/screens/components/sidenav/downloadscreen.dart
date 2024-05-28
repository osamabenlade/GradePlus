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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Files'),
      ),
      body: _pdfFiles.isEmpty
          ? Center(child: Text('No PDF files found.'))
          : RefreshIndicator(
        onRefresh: _refreshFiles,
        child: ListView.builder(
          itemCount: _pdfFiles.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_pdfFiles[index].path.split('/').last),
              trailing: IconButton(
                icon: Icon(Icons.remove_red_eye),
                onPressed: () => _openFile(_pdfFiles[index]),
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
