




import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradeplus/constants.dart';
import 'package:gradeplus/homescreen.dart';

import 'components/custom_dropdown.dart';

List<Color> _colors = [kPrimaryColor, kPrimaryLightColor];
List<double> _stops = [0.0, 1.8];



String college = "IIITA";
int batch=2022;
String branch='IT';
int semester=4;

class LoginDetailScreen extends StatefulWidget {
  @override
  _LoginDetailScreenGetterState createState() => _LoginDetailScreenGetterState();
}

class _LoginDetailScreenGetterState extends State<LoginDetailScreen> {
  List<String> _branches = ['IT', 'ITBI', 'ECE'];

  List<int> _semester = [1, 2, 3, 4, 5, 6, 7, 8];

  List<int> _batches = [2023, 2022, 2021, 2020, 2019];

  @override
  void initState() {
    super.initState();
  }
  String? _selectedBranch;
  int? _selectedSemester;
  int? _selectedBatch;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Hero(
                        tag: 'logo',
                        child: Container(
                          height: 180.0,
                          child: Image.asset('assets/images/tmplogo.png'),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 28.0, top: 8.0, bottom: 8.0),
                    child: Text(
                      'Semester',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                          color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomDropdown(
                      text: "Select semester",
                      list: _semester,
                      type: 1,
                    ),

                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 28.0, top: 8.0, bottom: 8.0),
                    child: Text(
                      'Batch',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                          color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomDropdown(
                      text: "Select Batch",
                      list: _batches,
                      type: 2,
                    ),

                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 28.0, top: 8.0, bottom: 8.0),
                    child: Text(
                      'Branch',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                          color: Colors.black),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomDropdown(
                      text: "Select Branch",
                      list: _branches,
                      type: 3,

                    ),
                  ),

                  Align(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                        onTap: () {
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                        builder: (context) => SubjectListScreen(
                        semester: semester,
                        batch: batch,
                        branch: branch,
                        ),
                        ),
                        );
                        /*Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return SignIn(
                                  college: college,
                                  batch: batch,
                                  branch: branch,
                                  semester: semester);
                            },
                          ),
                        );*/
                      },
                      child: Padding(
                        padding: EdgeInsets.all(36.0),
                        child: Container(
                          height: 50.0,
                          width: 120.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            gradient: LinearGradient(
                              colors: _colors,
                              stops: _stops,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Next",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}