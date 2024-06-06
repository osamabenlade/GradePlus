

import 'dart:async';

import 'package:GradePlus/screens/user_section/SubjectListScreen.dart';
import 'package:GradePlus/screens/admin_section/adminscreen.dart';
import 'package:GradePlus/screens/moderator_section/ModeratorScreen.dart';
import 'package:GradePlus/screens/login/screens/login_screen.dart';
import 'package:GradePlus/screens/login/record/SecureStorage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:simple_ripple_animation/simple_ripple_animation.dart';

import 'screens/login/record/firebase_services.dart';
import 'screens/user_section/homescreen.dart';
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
    bool NotFirstTime = await isFirstTimeCheck();
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
    print("ff $loggedIn");
    if (!NotFirstTime) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
            (Route<dynamic> route) => false,
      );
    } else {
      if (!loggedIn) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
              (Route<dynamic> route) => false,
        );
      } else {
        if (isAdmin) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => AdminScreen()),
                (Route<dynamic> route) => false,
          );
        } else if (isMod) {
          // Navigate to ModeratorScreen if user is a moderator
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => ModeratorScreen()),
                (Route<dynamic> route) => false,
          );
        } else {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) =>
                HomeScreen(
                  initialSemester: semester,
                  initialBatch: batch,
                  initialBranch: branch,
                )),
                (Route<dynamic> route) => false,
          );
        }
      }
    }
    }
    /*if (loggedIn) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
            (Route<dynamic> route) => false,
      );
    } else {
      if (!NotFirstTime) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => OnboardingScreen()),
              (Route<dynamic> route) => false,
        );
      } else {
        if (isAdmin) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => AdminScreen()),
                (Route<dynamic> route) => false,
          );
        } else if (isMod) {
          // Navigate to ModeratorScreen if user is a moderator
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => ModeratorScreen()),
                (Route<dynamic> route) => false,
          );
        } else {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) =>
                HomeScreen(
                  initialSemester: semester,
                  initialBatch: batch,
                  initialBranch: branch,
                )),
                (Route<dynamic> route) => false,
          );
        }
      }
    }*/



    @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return Scaffold(
        body: Center(
          // child:Image.asset("assets/images/IIIta.png"),
          child: RippleAnimation(
            color: Colors.deepPurpleAccent,
            delay: const Duration(milliseconds: 800),
            minRadius: 905,
            ripplesCount: 5,
            repeat: true,
            duration: const Duration(milliseconds: 4200),
            child: Center(
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
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    return (user != null);
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

