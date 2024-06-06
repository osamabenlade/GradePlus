import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../login/record/firebase_services.dart';
import 'AddDocumentScreen.dart';
import 'AddLinkScreen.dart';
import 'ShowRequestScreen.dart'; // Import the screen for showing requests

class ModeratorScreen extends StatefulWidget {
  @override
  _ModeratorScreenState createState() => _ModeratorScreenState();
}

class _ModeratorScreenState extends State<ModeratorScreen> {
  String? selectedSemester;
  String? selectedSubject;
  String? mod_name;
  String? mod_uid;

  void _addDocument(BuildContext context, String doctype) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddDocumentScreen(fileType: doctype),
      ),
    );
  }
  void _addLinks(BuildContext context, String doctype) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddLinkScreen(fileType: doctype),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getModeratorDetails();
  }

  Future<void> _getModeratorDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    String email = user?.email ?? '';
    List<String>? parts = email.split('@');
    String? emailWithoutDomain = parts?.first;

    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('moderators').get();

    Map<dynamic, dynamic>? userData = snapshot.value as Map<dynamic, dynamic>?;
    mod_name = userData?[emailWithoutDomain]['name'];
    mod_uid = userData?[emailWithoutDomain]['id'];
    setState(() {}); // Trigger a rebuild to update the UI with the fetched data
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String email = user?.email ?? '';

    return DefaultTabController(
      length: 2, // Define the number of tabs
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Moderator',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue[700],
          iconTheme: IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                FirebaseServices().googleSignOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
          bottom: const TabBar(
            // Define the TabBar
            tabs: [
              Tab(text: 'Home'), // First tab
              Tab(text: 'Requests'), // Second tab
            ],
            // Styling the TabBar
            indicatorColor: Colors.white, // Color of the indicator (underline)
            indicatorWeight: 5.0, // Thickness of the indicator
            labelColor: Colors.white, // Color of the selected tab label
            unselectedLabelColor: Colors.white70, // Color of the unselected tab labels
            labelStyle: TextStyle(
              fontSize: 18.0, // Font size of the selected tab label
              fontWeight: FontWeight.bold, // Font weight of the selected tab label
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 14.0, // Font size of the unselected tab labels
            ),
            indicatorSize: TabBarIndicatorSize.tab, // Indicator width matches the tab width
          ),
        ),
        body: TabBarView(
          // Define the TabBarView
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.94,
                    margin: EdgeInsets.symmetric(horizontal: 16.0),

                    child: Card(
                      color: Color(0xFFD1B7F9),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Welcome ${mod_name}',
                              style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 3),
                            Text(
                              mod_uid ?? '',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 3),
                            Text(
                              email,
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 10,)
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height:70),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: (){
                              _addDocument(context, 'materials');
                            },
                            child: Card(
                              color: Color(0xFFfefae0),
                              elevation: 5,
                              child: Container(
                                height: MediaQuery.of(context).size.width * 0.37,
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children:<Widget> [
                                      Image.asset(
                                        'assets/images/pdf.png',
                                        height: 40,
                                        width: 40,
                                      ),
                                      const Text(
                                        'Add Documents',
                                        style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              _addLinks(context, 'links');
                            },
                            child: Card(
                              color: Color(0xFFcad2c5),
                              elevation: 5,
                              child: Container(
                                height: MediaQuery.of(context).size.width * 0.37,
                                width: MediaQuery.of(context).size.width * 0.445,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children:<Widget> [
                                      Image.asset(
                                        'assets/images/youtube.png',
                                        height: 40,
                                        width: 40,
                                      ),
                                      const Text(
                                        'Add Links',
                                        style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: (){
                              _addDocument(context, 'pyq');
                            },
                            child: Card(
                              color: Color(0xFFdde5b6),
                              elevation: 5,
                              child: Container(
                                height: MediaQuery.of(context).size.width * 0.37,
                                width: MediaQuery.of(context).size.width * 0.85,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children:<Widget> [
                                      Image.asset(
                                        'assets/images/quiz.png',
                                        height: 40,
                                        width: 40,
                                      ),
                                      const Text(
                                        'Add PYQs',
                                        style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                  ),
                    ],
                ),
              ],
            ),
            ),
            // Second tab content
            ShowRequestsScreen(), // ShowRequestsScreen should be implemented separately
          ],
        ),
      ),
    );
  }
}
