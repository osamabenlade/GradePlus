import 'package:flutter/material.dart';

class Announcements extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Announcements'),
      ),
      body: Center(
        child: Text(
          'Announcements Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
