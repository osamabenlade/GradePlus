
import 'package:GradePlus/screens/components/sidenav/aboutus.dart';
import 'package:GradePlus/screens/login/login_screen.dart';
import 'package:GradePlus/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'firebase_options.dart';
import 'homescreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
         options: DefaultFirebaseOptions.currentPlatform,
       );

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GradePlus',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginScreen(),
      initialRoute: '/splash', // Set initial route to the splash screen
      routes: {
        '/splash': (context) => SplashScreen(), // Define your splash screen route
        '/login': (context) => LoginScreen(),
        '/aboutUs':(context)=> Aboutus(),


      },
    );
  }
}

