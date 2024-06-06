import 'package:GradePlus/screens/user_section/SubjectListScreen.dart';
import 'package:GradePlus/screens/login/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../constants/constants.dart';
import '../login/record/firebase_services.dart';
import 'package:iconsax/iconsax.dart';

import 'components/sidenav/aboutus.dart';
import 'components/sidenav/announcements.dart';
import 'components/sidenav/downloadscreen.dart';


class HomeScreen extends StatefulWidget {
  final int initialSemester;
  final int initialBatch;
  final String initialBranch;

  HomeScreen({
    required this.initialSemester,
    required this.initialBatch,
    required this.initialBranch,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _semester;
  late int _batch;
  late String _branch;
  String _selectedItem = 'Home'; // Track the currently selected item

  // Variables to store user information
  String? _userName;
  String? _userEmail;
  String? _userProfileImageUrl;

  @override
  void initState() {
    super.initState();
    _semester = widget.initialSemester;
    _batch = widget.initialBatch;
    _branch = widget.initialBranch;
    fetchUserInfo();
  }
  void _updateSemester(int newSemester) {
    setState(() {
      _semester = newSemester;
    });
  }

  // Function to fetch user information
  void fetchUserInfo() async {
    // Get the current user from FirebaseAuth
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Set user name
      setState(() {
        _userName = user.displayName;
        _userEmail = user.email;
        _userProfileImageUrl = user.photoURL;
      });
    }
  }

  // Function to get the content based on the selected item
  Widget _getSelectedScreen() {
    switch (_selectedItem) {
      case 'Home':
        return SubjectListScreen(
          semester: _semester,
          batch: _batch,
          branch: _branch, onSemesterChanged: _updateSemester,
        );
      case 'Downloads':
        return DownloadScreen();
      case 'Announcements':
        return Announcements();
      case 'About Us':
        return Aboutus();
      default:
        return Center(child: Text('Error: Unknown screen'));
    }
  }
  String _getAppBarTitle() {
    switch (_selectedItem) {
      case 'Home':
        return getSemester(_semester);
      case 'Downloads':
        return 'Downloads';
      case 'Announcements':
        return 'Announcements';
      case 'About Us':
        return 'About Us';
      case 'Logout':
        return 'Logout';
      default:
        return getSemester(_semester);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getAppBarTitle(),
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue[700],
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              FirebaseServices().googleSignOut();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginScreen()),
                    (Route<dynamic> route) => false,
              );
            },
          ),
        ],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: _getSelectedScreen(),
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
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Display user's email
                    Text(
                      _userEmail ?? 'user@gmail.com',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
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
                Navigator.pop(context); // Close the drawer
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
                Navigator.pop(context); // Close the drawer
              },
            ),
            // ListTile(
            //   leading: Icon(Icons.announcement, color: _selectedItem == 'Announcements' ? Colors.blue : Colors.grey[700]),
            //   title: Text(
            //     'Announcements',
            //     style: TextStyle(color: _selectedItem == 'Announcements' ? Colors.blue : Colors.grey[700], fontWeight: FontWeight.bold),
            //   ),
            //   onTap: () {
            //     setState(() {
            //       _selectedItem = 'Announcements';
            //     });
            //     Navigator.pop(context); // Close the drawer
            //   },
            // ),
            ListTile(
              leading: Icon(Icons.info, color: _selectedItem == 'About Us' ? Colors.blue : Colors.grey[700]),
              title: Text(
                'About Us',
                style: TextStyle(color: _selectedItem == 'About Us' ? Colors.blue : Colors.grey[700], fontWeight: FontWeight.bold),
              ),
              onTap: () {
                setState(() {
                  _selectedItem = 'About Us';
                });
                Navigator.pop(context); // Close the drawer
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
