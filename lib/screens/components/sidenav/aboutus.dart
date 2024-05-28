import 'package:flutter/material.dart';

class Aboutus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'GradePlus',
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 16.0),
            ExpansionTile(
              title: Text(
                'About GradePlus',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: Icon(Icons.info, color: Colors.blue),
              initiallyExpanded: true,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'GradePlus is a dedicated app for the students of IIITA. Our aim is to provide a comprehensive platform where students can easily access lecture slides shared by professors, past year question papers, and other academic resources, all arranged systematically.',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            ExpansionTile(
              title: Text(
                'Features',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: Icon(Icons.list, color: Colors.blue),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '• Lecture slides shared by professors',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      Text(
                        '• Past year question papers',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      Text(
                        '• Systematic arrangement of all academic resources',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      Text(
                        '• Real-time chat screen for each subject',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            ExpansionTile(
              title: Text(
                'Contributors',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: Icon(Icons.people, color: Colors.blue),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'GradePlus is developed by a dedicated team of students and faculty members from IIITA. We thank all contributors for their efforts in making this app a valuable resource for the academic community.',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Text(
              'Contact Us:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }
}
