// import 'package:flutter/material.dart';
//
// import '../contents/MaterialsContent.dart';
// import '../contents/PYQsContent.dart';
// import '../contents/VideoLinksContent.dart';
//
// class SubjectScreen extends StatelessWidget {
//   final Map<dynamic, dynamic> subjectData;
//
//   SubjectScreen(this.subjectData);
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 3,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(
//             subjectData['subjectCode'],
//             style: TextStyle(color: Colors.white),
//           ),
//           backgroundColor: Colors.blue[700],
//           iconTheme: IconThemeData(color: Colors.white),
//           bottom: TabBar(
//             indicatorColor: Colors.white,
//             unselectedLabelColor: Colors.blue[300],
//             tabs: [
//               Tab(
//                 icon: Icon(Icons.book),
//                 text: 'Materials',
//               ),
//               Tab(
//                 icon: Icon(Icons.assignment),
//                 text: 'PYQs',
//               ),
//               Tab(
//                 icon: Icon(Icons.video_library),
//                 text: 'Video Links',
//               ),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             MaterialsContent(subjectData['subjectCode']),
//             PYQsContent(),
//             VideoLinksContent(),
//           ],
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             showModalBottomSheet(
//               context: context,
//               builder: (BuildContext context) {
//                 return BottomSheet(
//                   onClosing: () {},
//                   builder: (BuildContext context) {
//                     return Container(
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           ListTile(
//                             title: Text('Moderators'),
//                             onTap: () {
//                               // Implement action when Moderators is tapped
//                               Navigator.pop(context);
//                             },
//                           ),
//                           ListTile(
//                             title: Text('Books'),
//                             onTap: () {
//                               // Implement action when Books is tapped
//                               Navigator.pop(context);
//                             },
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 );
//               },
//             );
//           },
//           child: Icon(Icons.add),
//           backgroundColor: Colors.blue[700],
//         ),
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
//
// import '../contents/MaterialsContent.dart';
// import '../contents/PYQsContent.dart';
// import '../contents/VideoLinksContent.dart';
//
// class SubjectScreen extends StatelessWidget {
//   final Map<dynamic, dynamic> subjectData;
//
//   SubjectScreen(this.subjectData);
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 3,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(
//             subjectData['subjectCode'],
//             style: TextStyle(color: Colors.white),
//           ),
//           backgroundColor: Colors.blue[700],
//           iconTheme: IconThemeData(color: Colors.white),
//           bottom: TabBar(
//             indicatorColor: Colors.white,
//             unselectedLabelColor: Colors.blue[300],
//             tabs: [
//               Tab(
//                 icon: Icon(Icons.book),
//                 text: 'Materials',
//               ),
//               Tab(
//                 icon: Icon(Icons.assignment),
//                 text: 'PYQs',
//               ),
//               Tab(
//                 icon: Icon(Icons.video_library),
//                 text: 'Video Links',
//               ),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             MaterialsContent(subjectData['subjectCode']),
//             PYQsContent(),
//             VideoLinksContent(),
//           ],
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             showModalBottomSheet(
//               context: context,
//               builder: (BuildContext context) {
//                 return BottomSheet(
//                   onClosing: () {},
//                   builder: (BuildContext context) {
//                     return Container(
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           ListTile(
//                             title: Text('Moderators'),
//                             onTap: () {
//                               // Implement action when Moderators is tapped
//                               Navigator.pop(context);
//                             },
//                           ),
//                           ListTile(
//                             title: Text('Books'),
//                             onTap: () {
//                               // Implement action when Books is tapped
//                               Navigator.pop(context);
//                             },
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 );
//               },
//             );
//           },
//           child: Icon(Icons.add),
//           backgroundColor: Colors.blue[700],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import '../contents/MaterialsContent.dart';
import '../contents/PYQsContent.dart';
import '../contents/VideoLinksContent.dart';

class SubjectScreen extends StatelessWidget {
  final Map<dynamic, dynamic> subjectData;

  SubjectScreen(this.subjectData);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            subjectData['subjectCode'],
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue[700],
          iconTheme: IconThemeData(color: Colors.white),
          bottom: TabBar(
            indicatorColor: Colors.white,
            unselectedLabelColor: Colors.blue[300],
            tabs: [
              Tab(
                icon: Icon(Icons.book),
                text: 'Materials',
              ),
              Tab(
                icon: Icon(Icons.assignment),
                text: 'PYQs',
              ),
              Tab(
                icon: Icon(Icons.video_library),
                text: 'Video Links',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MaterialsContent(subjectData['subjectCode']),
            PYQsContent(),
            VideoLinksContent(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return BottomSheet(
                  onClosing: () {},
                  builder: (BuildContext context) {
                    return Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: Text('Moderators'),
                            onTap: () {
                              // Implement action when Moderators is tapped
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            title: Text('Books'),
                            onTap: () {
                              // Implement action when Books is tapped
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.blue[700],
        ),
      ),
    );
  }
}