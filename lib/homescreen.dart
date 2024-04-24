import 'package:circle_list/circle_list.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:gradeplus/screens/login/login_screen.dart';
import 'package:gradeplus/screens/subjects/SubjectScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'constants.dart';
import 'firebase_services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:gradeplus/screens/components/sidenav/downloadscreen.dart';
import 'package:gradeplus/screens/components/sidenav/announcements.dart';
import 'package:gradeplus/screens/components/sidenav/aboutus.dart';



class SubjectListScreen extends StatefulWidget {
  final int semester;
  final int batch;
  final String branch;
  User? user = FirebaseAuth.instance.currentUser;

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

  Color _iconColor = Colors.grey[700] ?? Colors.grey; // Initial icon color
  Color _textColor = Colors.grey[700] ?? Colors.grey; // Initial text color

  String _selectedItem = ''; // Track the currently selected item


  // Variables to store user information
  String? _userName;
  String? _userEmail;
  String? _userProfileImageUrl;

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

    // Fetch user information when the screen initializes
    fetchUserInfo();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _hideFabAnimController.dispose();
    super.dispose();
  }

  // Function to fetch user information
  void fetchUserInfo() async {
    // Get the current user from FirebaseAuth
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Set user name
      setState(() {
        _userName = user.displayName;
      });

      // Set user email
      setState(() {
        _userEmail = user.email;
      });

      // Set user profile image URL
      setState(() {
        _userProfileImageUrl = user.photoURL;
      });
    }
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
              Navigator.pushReplacementNamed(context, '/login');
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 210,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue[700],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display user's profile image
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(_userProfileImageUrl ?? ''),
                    ),
                    SizedBox(height: 10),
                    // Display user's name
                    Text(
                      _userName ?? 'User Name',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Display user's email
                    Text(
                      _userEmail ?? 'user@gmail.com',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            ListTile(
              leading: Icon(Icons.home, color: _selectedItem == 'Home' ? Colors.blue : Colors.grey[700]),
              title: Text(
                'Home',
                style: TextStyle(color: _selectedItem == 'Home' ? Colors.blue : Colors.grey[700], fontWeight: FontWeight.bold),
              ),
              onTap: () {
                setState(() {
                  _selectedItem = 'Home';
                });
                // Navigate to home screen
                Navigator.pop(context); // Close the drawer
                // Replace the current screen with the home screen
                Navigator.pushReplacementNamed(context, '/home');
              },
            ),
            ListTile(
              leading: Icon(Icons.file_download, color: _selectedItem == 'Downloads' ? Colors.blue : Colors.grey[700]),
              title: Text(
                'Downloads',
                style: TextStyle(color: _selectedItem == 'Downloads' ? Colors.blue : Colors.grey[700], fontWeight: FontWeight.bold),
              ),
              onTap: () {
                setState(() {
                  _selectedItem = 'Downloads';
                });
                // Navigate to downloads screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DownloadsScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.announcement, color: _selectedItem == 'Announcements' ? Colors.blue : Colors.grey[700]),
              title: Text(
                'Announcements',
                style: TextStyle(color: _selectedItem == 'Announcements' ? Colors.blue : Colors.grey[700], fontWeight: FontWeight.bold),
              ),
              onTap: () {
                setState(() {
                  _selectedItem = 'Announcements';
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Announcements()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.info, color: _selectedItem == 'About' ? Colors.blue : Colors.grey[700]),
              title: Text(
                'About',
                style: TextStyle(color: _selectedItem == 'About' ? Colors.blue : Colors.grey[700], fontWeight: FontWeight.bold),
              ),
              onTap: () {
                setState(() {
                  _selectedItem = 'About';
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Aboutus()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

String getSemesterName(int semesterNumber) {
  return 'Semester$semesterNumber';
}

String getSemester(int semesterNumber) {
  return 'Semester $semesterNumber';
}
