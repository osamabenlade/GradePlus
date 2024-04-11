// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
//
// class MaterialsContent extends StatelessWidget {
//   final String subjectData;
//
//   MaterialsContent(this.subjectData);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance.collection(subjectData).snapshots(),
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.hasError) {
//             return Center(
//               child: Text('Error: ${snapshot.error}'),
//             );
//           }
//
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//
//           return Container(
//             margin: EdgeInsets.only(top: 16),
//             child: ListView.builder(
//               itemCount: snapshot.data!.docs.length,
//               itemBuilder: (context, index) {
//                 DocumentSnapshot document = snapshot.data!.docs[index];
//                 Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
//
//                 if (data == null) {
//                   return SizedBox(); // Return an empty widget if data is null
//                 }
//
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
//                   child: Card(
//                     elevation: 4,
//                     color: Colors.white, // Set card color to white
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: ListTile(
//                       leading: IconButton(
//                         icon: Icon(Icons.download),
//                         onPressed: () {
//                           // Implement download action
//                         },
//                       ),
//                       title: Text(data['itemName']),
//                       trailing: IconButton(
//                         icon: Icon(Icons.visibility),
//                         onPressed: () {
//                           print(data['link']);
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => PdfViewer(data['link']),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
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
//     final document = await PDFDocument.fromURL(widget.pdfUrl);
//     setState(() {
//       _document = document;
//       _loading = false;
//     });
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
//
//
//
//


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/pdfViewer.dart';

class MaterialsContent extends StatelessWidget {
  final String subjectData;

  MaterialsContent(this.subjectData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection(subjectData).snapshots(),
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

          return Container(
            margin: EdgeInsets.only(top: 16),
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = snapshot.data!.docs[index];
                Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

                if (data == null) {
                  return SizedBox(); // Return an empty widget if data is null
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Card(
                    elevation: 4,
                    color: Colors.white, // Set card color to white
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: IconButton(
                        icon: Icon(Icons.download),
                        onPressed: () {
                          // Implement download action
                        },
                      ),
                      title: Text(data['itemName']),
                      trailing: IconButton(
                        icon: Icon(Icons.visibility),
                        onPressed: () {
                          print(data['link']);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PdfViewer(data['link']),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

