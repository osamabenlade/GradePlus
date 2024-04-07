

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';

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
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
          builder: (context) => OnboardingScreen(),
      ),
      );
    });
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
