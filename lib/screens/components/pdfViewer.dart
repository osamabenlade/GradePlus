import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PdfViewer extends StatefulWidget {
  final String pdfUrl;

  PdfViewer(this.pdfUrl);

  @override
  _PdfViewerState createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  bool _loading = true;
  late PDFDocument _document;

  @override
  void initState() {
    super.initState();
    loadPdf();
  }

  void loadPdf() async {
    setState(() {
      _loading = true;
    });
    print("PDF URL: ${widget.pdfUrl}"); // Debug print
    try {
      final document = await PDFDocument.fromURL(widget.pdfUrl);
      setState(() {
        _document = document;
        _loading = false;
      });
    } catch (e) {
      print("Error loading PDF: $e"); // Print error message
      setState(() {
        _loading = false; // Update loading state even if there's an error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : PDFViewer(
        document: _document,
        zoomSteps: 1,
      ),
    );
  }
}

