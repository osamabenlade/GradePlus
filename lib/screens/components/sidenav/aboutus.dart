import 'package:flutter/material.dart';

class Aboutus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aboutus'),
      ),
      body: Center(
        child: Text(
          'Aboutus Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
