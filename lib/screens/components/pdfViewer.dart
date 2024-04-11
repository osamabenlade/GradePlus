// import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class PdfViewer extends StatefulWidget {
//   final String pdfUrl;
//
//   PdfViewer(this.pdfUrl);
//
//   @override
//   _PdfViewerState createState() => _PdfViewerState();
// }
//
// class _PdfViewerState extends State<PdfViewer> {
//   bool _loading = true;
//   late PDFDocument _document;
//
//   @override
//   void initState() {
//     super.initState();
//     loadPdf();
//   }
//
//   void loadPdf() async {
//     setState(() {
//       _loading = true;
//     });
//     print("PDF URL: ${widget.pdfUrl}"); // Debug print
//     try {
//       final document = await PDFDocument.fromURL(widget.pdfUrl);
//       setState(() {
//         _document = document;
//         _loading = false;
//       });
//     } catch (e) {
//       print("Error loading PDF: $e"); // Print error message
//       setState(() {
//         _loading = false; // Update loading state even if there's an error
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('PDF Viewer'),
//       ),
//       body: _loading
//           ? Center(child: CircularProgressIndicator())
//           : PDFViewer(
//         document: _document,
//         zoomSteps: 1,
//       ),
//     );
//   }
// }
//

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
//
// class PdfViewer extends StatefulWidget {
//   final String pdfUrl;
//
//   PdfViewer(this.pdfUrl);
//
//   @override
//   _PdfViewerState createState() => _PdfViewerState();
//
// }
//
// class _PdfViewerState extends State<PdfViewer> {
//   String pathPDF = '';
//   bool _loading = true;
//   late PDFDocument _document;
//
//   @override
//   void initState() {
//     super.initState();
//     loadPdf();
//   }
//
//   Future<void> loadPdf() async {
//     setState(() {
//       _loading = true;
//     });
//     try {
//       final document = await PDFDocument.fromURL(widget.pdfUrl);
//       setState(() {
//         _document = document;
//         _loading = false;
//       });
//     } catch (e) {
//       print("Error loading PDF: $e");
//       setState(() {
//         _loading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('PDF Viewer'),
//       ),
//       body: _loading
//           ? Center(child: CircularProgressIndicator())
//           : PDFViewer(document: _document),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewer extends StatefulWidget {
  final String pdfUrl;

  PdfViewer(this.pdfUrl);

  @override
  _PdfViewerState createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  late bool _isLoading;
  late String _pdfUrl;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _pdfUrl = widget.pdfUrl;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
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


