import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewer extends StatefulWidget {
  final String pdfUrl;
  final String pdfName;

  PdfViewer(this.pdfUrl, this.pdfName);

  @override
  _PdfViewerState createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  late bool _isLoading;
  late String _pdfUrl;
  late String _pdfName;
  bool _isRotated = false;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _pdfUrl = widget.pdfUrl;
    _pdfName = widget.pdfName;
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    try {
      // Simulate a delay for demonstration purposes
      await Future.delayed(Duration(seconds: 2));
      // Assuming the PDF is loaded successfully
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      // Handle any potential errors
      print('Error loading PDF: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleRotation() {
    setState(() {
      _isRotated = !_isRotated;
    });

    if (_isRotated) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pdfName),
        actions: <Widget>[
          IconButton(
            icon: Icon(_isRotated ? Icons.screen_lock_rotation : Icons.screen_rotation),
            onPressed: _toggleRotation,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SfPdfViewer.network(
        _pdfUrl,
        onDocumentLoaded: (PdfDocumentLoadedDetails details) {
          setState(() {
            _isLoading = false;
          });
        },
      ),
    );
  }
}