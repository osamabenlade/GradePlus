import 'package:circle_list/circle_list.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:gradeplus/screens/login/login_screen.dart';
import 'package:gradeplus/screens/subjects/SubjectScreen.dart';

import 'constants.dart';
import 'firebase_services.dart';

class SubjectListScreen extends StatefulWidget {
  final int semester;
  final int batch;
  final String branch;

  SubjectListScreen({
    required this.semester,
    required this.batch,
    required this.branch,
  });

  @override
  _SubjectListScreenState createState() => _SubjectListScreenState();
}

class _SubjectListScreenState extends State<SubjectListScreen>
    with SingleTickerProviderStateMixin {
  late int _semester;
  late int _batch;
  late String _branch;
  late ScrollController _scrollController;
  late AnimationController _hideFabAnimController;

  @override
  void initState() {
    super.initState();
    _semester = widget.semester;
    _batch = widget.batch;
    _branch = widget.branch;
    _scrollController = ScrollController();
    _hideFabAnimController = AnimationController(
      vsync: this,
      duration: kThemeAnimationDuration,
      value: 1, // initially visible
    );
    _scrollController.addListener(() {
      switch (_scrollController.position.userScrollDirection) {
        case ScrollDirection.forward:
          _hideFabAnimController.forward();
          break;
        case ScrollDirection.reverse:
          _hideFabAnimController.reverse();
          break;
        case ScrollDirection.idle:
          break;
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _hideFabAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          getSemester(_semester),
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue[700],
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              FirebaseServices().googleSignOut();
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
              );
            },
          ),
        ],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(getSemesterName(_semester))
            .doc(_branch)
            .collection('sub')
            .snapshots(),
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

          return ListView.separated(
            controller: _scrollController,
            itemCount: snapshot.data!.docs.length,
            separatorBuilder: (BuildContext context, int index) => Divider(),
            itemBuilder: (BuildContext context, int index) {
              DocumentSnapshot document = snapshot.data!.docs[index];
              Map<String, dynamic>? data =
              document.data() as Map<String, dynamic>?;

              if (data == null) {
                return SizedBox();
              }

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: Image.network(
                    data['iconUrl'],
                    height: 60,
                    width: 80,
                  ),
                  title: Text(
                    data['subjectCode'],
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
                  ),
                  subtitle: Text(data['subjectName']),
                  trailing: Icon(
                    Icons.keyboard_arrow_right,
                    size: 30,
                    color: Colors.black,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubjectScreen(data, getSemesterName(_semester)),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FadeTransition(
        opacity: _hideFabAnimController,
        child: ScaleTransition(
          scale: _hideFabAnimController,
          child: FloatingActionButton.extended(
            backgroundColor: Constants.DARK_SKYBLUE,
            elevation: 1,
            isExtended: true,
            label: Text(
              'Switch Sem',
              style: TextStyle(
                fontSize: 18,
                color: Constants.WHITE,
                fontWeight: FontWeight.w700,
              ),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return CircleList(
                    showInitialAnimation: true,
                    animationSetting: AnimationSetting(
                        duration: Duration(milliseconds: 800),
                        curve: Curves.fastOutSlowIn),
                    children: List.generate(
                      8,
                          (index) => ClipRRect(
                        borderRadius:
                        BorderRadius.all(Radius.circular(1000)),
                        child: MaterialButton(
                          height: 60,
                          minWidth: 60,
                          color: (index + 1) == _semester
                              ? Constants.DARK_SKYBLUE
                              : Constants.WHITE,
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 36,
                                color: Constants.BLACK,
                                fontWeight: FontWeight.w600),
                          ),
                          onPressed: () async {
                            Navigator.of(context).pop();
                            setState(
                                  () {
                                _semester = index + 1;
                                FirebaseFirestore.instance
                                    .collection(getSemesterName(_semester))
                                    .doc(_branch)
                                    .set({'semester': index + 1},
                                    SetOptions(merge: true));
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    outerCircleColor: Constants.WHITE,
                  );
                },
              );
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

String getSemesterName(int semesterNumber) {
  return 'Semester$semesterNumber';
}

String getSemester(int semesterNumber) {
  return 'Semester $semesterNumber';
}