


import 'dart:io';


import 'package:GradePlus/screens/admin_section/adminscreen.dart';
import 'package:GradePlus/screens/moderator_section/ModeratorScreen.dart';
import 'package:GradePlus/screens/login/screens/login_detail_screen.dart';
import 'package:GradePlus/screens/login/record/SecureStorage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

String mod_name='hima';
String mod_uid='iit237';
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

        final User? user = userCredential.user;
        //
        // // Get the email and name from the user information
        final String? email = user?.email;
        final String? name = user?.displayName;
        //
        // // Use the email and name as needed
        // print('Email: $email');
        // print('Name: $name');
        List<String>? parts = email?.split('@');
        String? emailWithoutDomain = parts?.first;
        // print('Email: $emailWithoutDomain');
        SecureStorage secureStorage = SecureStorage();
        await secureStorage.writeSecureData('isFirstTime', 'true');

        final ref = FirebaseDatabase.instance.ref();
        final snapshot = await ref.child('admins').get();

        if (snapshot.exists) {
          // Get the data snapshot value as a Map<String, dynamic>
          Map<dynamic, dynamic>? userData = snapshot.value as Map<
              dynamic,
              dynamic>?;

          if (userData != null) {
            // Convert the data to Map<String, dynamic> by casting each entry
            Map<String, dynamic> stringData = userData.map((key, value) =>
                MapEntry(key.toString(), value));

            // Check if the entered UID matches any keys under the "users" section
            bool uidExists = stringData.containsKey(emailWithoutDomain);

            if (uidExists) {
              SecureStorage secureStorage = SecureStorage();
              await secureStorage.writeSecureData('isAdmin', 'true');
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => AdminScreen()),
              );
              print('UID exists in the database');
            } else {
              final snapshot = await ref.child('moderators').get();
              if (snapshot.exists) {
                Map<dynamic, dynamic>? userData = snapshot.value as Map<
                    dynamic,
                    dynamic>?;
                if (userData != null) {
                  Map<String, dynamic> stringData = userData.map((key, value) =>
                      MapEntry(key.toString(), value));
                  bool uidExists = stringData.containsKey(emailWithoutDomain);
                  if (uidExists) {
                    //moderators
                    SecureStorage secureStorage = SecureStorage();
                    await secureStorage.writeSecureData('isModerator', 'true');
                     mod_name = userData[emailWithoutDomain]['name'];
                     mod_uid = userData[emailWithoutDomain]['id'];
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => ModeratorScreen()),
                          (Route<dynamic> route) => false,
                    );
                  }
                  else {
                    //noraml user
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginDetailScreen()),
                    );
                  }
                }
              }
            }
          }
        }

        /*if (snapshot.exists) {
          String tmp=snapshot.value.toString();
          print('check : $tmp');
          if(snapshot.value==emailWithoutDomain)
            {
              Navigator.push(context,
              MaterialPageRoute(builder: (context) => AdminScreen(name: name!, email: emailWithoutDomain!)));
            }
          else
            {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginDetailScreen()));
            }
          print(snapshot.value);

        } else {
          print('No data available.');
        }*/


// Compare the signed-in user's email with the admin email


      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw e;
    }
  }

  googleSignOut() async {
    final storage = new FlutterSecureStorage();
    await storage.delete(key: 'isLoggedIn');
    await storage.delete(key: 'branch');
    await storage.delete(key: 'batch');
    await storage.delete(key: 'semester');
    await storage.delete(key: 'isAdmin');
    await storage.delete(key: 'isModerator');
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}