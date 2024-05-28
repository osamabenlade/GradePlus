

import 'dart:async';

import 'package:GradePlus/screens/SubjectListScreen.dart';
import 'package:GradePlus/screens/adminscreen.dart';
import 'package:GradePlus/screens/login/ModeratorScreen.dart';
import 'package:GradePlus/screens/login/login_screen.dart';
import 'package:GradePlus/screens/login/record/SecureStorage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:simple_ripple_animation/simple_ripple_animation.dart';

import 'homescreen.dart';
import 'onboarding.dart';

class SplashScreen extends StatefulWidget{
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Timer(const Duration(milliseconds: 2600), () {
      checkLoginState(context);
    });
  }
  Future<void> checkLoginState(BuildContext context) async {
    String branch = 'IT';
    int batch = 2023;
    int semester = 1;
    SecureStorage secureStorage = SecureStorage(); // Get the instance of SecureStorage
    bool loggedIn = await isLoggedInCheck();
    bool FirstTime = await isFirstTimeCheck();
    bool isAdmin = await isAdminCheck();
    bool isMod = await isModeratorCheck();

    if (loggedIn) {
      branch = await secureStorage.readSecureData('branch');
      String sem = (await secureStorage.readSecureData('semester'));
      String bat = (await secureStorage.readSecureData('batch'));
      if (sem != null) {
        semester = int.tryParse(sem) ?? 0;
      }
      if (bat != null) {
        batch = int.tryParse(bat) ?? 0;
      }
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          if (!loggedIn) {
            return LoginScreen();
          } else {
            if (!FirstTime) {
              return OnboardingScreen();
            } else {
              if (isAdmin) {
                return AdminScreen();
              } else if (isMod) {
                // Navigate to ModeratorScreen if user is a moderator
                return ModeratorScreen();
              } else {
                return HomeScreen(
                  initialSemester: semester,
                  initialBatch: batch,
                  initialBranch: branch,
                );
              }
            }
          }
        },
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body:Center(
        // child:Image.asset("assets/images/IIIta.png"),
        child: RippleAnimation(
          color: Colors.deepPurpleAccent,
          delay: const Duration(milliseconds: 800),
          minRadius: 905,
          ripplesCount: 5,
          repeat: true,
          duration: const Duration(milliseconds: 4200),
          child:Center(
            child: Container(
              width: 290,
              height: 290,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: ClipOval(
                child: Center(
                  child: Image.asset(
                    'assets/images/tmplogo.png',
                    height: 220,
                    width: 220,),
                ),
              ),
            ),),
        ),
      ),
    );
  }

}
Future<bool> isLoggedInCheck() async {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user = _auth.currentUser;
  return(user != null);
}
Future<bool> isFirstTimeCheck() async {
  final storage = FlutterSecureStorage();
  String? value = await storage.read(key: 'isFirstTime');
  return value == 'true';
}
Future<bool> isAdminCheck() async {
  final storage = FlutterSecureStorage();
  String? value = await storage.read(key: 'isAdmin');
  return value == 'true';
}
Future<bool> isModeratorCheck() async {
  final storage = FlutterSecureStorage();
  String? value = await storage.read(key: 'isModerator');
  return value == 'true';
}