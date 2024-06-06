import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import '../login/record/firebase_services.dart';
import 'ShowModeratorsScreen.dart';
import 'addModerator.dart';

class AdminScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String name = user?.displayName ?? '';
    String email = user?.email ?? '';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Admin Screen',style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              FirebaseServices().googleSignOut();
              Navigator.pushReplacementNamed(context, '/login'); // Go back to the previous screen after signing out
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size .height*.2,
              width: MediaQuery.of(context).size.width * 0.94,
              child: Card(
                color: Color(0xFFD1B7F9),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Welcome ${name}',
                          style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),
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
            ),
            SizedBox(height: 80), // Add some space between the user info and the card
      Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.push(context,
                                MaterialPageRoute(builder: (context) => AddModeratorScreen()));
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
                            'assets/add.png',
                            height: 40,
                            width: 40,
                          ),
                          const Text(
                            'Add Moderators',
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
                  Navigator.push(context,
                                MaterialPageRoute(builder: (context) => ShowModerators()));
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
                            'assets/show.png',
                            height: 40,
                            width: 40,
                          ),
                          const Text(
                            'Show Moderators',
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
          ],
        ),
      ],
      ),
      ),
    );
  }
}
