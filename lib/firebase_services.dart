


import 'dart:io';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gradeplus/screens/adminscreen.dart';
import 'package:gradeplus/screens/login/login_detail_screen.dart';

class FirebaseServices {
  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      await InternetAddress.lookup('google.com');
      final GoogleSignInAccount? googleSignInAccount =
      await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken);
        // Sign in to Firebase with the Google credential
        final UserCredential userCredential = await _auth.signInWithCredential(authCredential);

        // Access the user information
        final User? user = userCredential.user;

        // Get the email and name from the user information
        final String? email = user?.email;
        final String? name = user?.displayName;

        // Use the email and name as needed
        print('Email: $email');
        print('Name: $name');


        final ref = FirebaseDatabase.instance.ref();
        final snapshot = await ref.child('admins/mail2').get();
        if (snapshot.exists) {
          if(snapshot.value==email)
            {
              Navigator.push(context,
              MaterialPageRoute(builder: (context) => AdminScreen(name: name!, email: email!)));
            }
          else
            {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginDetailScreen()));
            }
          print(snapshot.value);

        } else {
          print('No data available.');
        }


// Compare the signed-in user's email with the admin email


      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw e;
    }
  }

  googleSignOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}