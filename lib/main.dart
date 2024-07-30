import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:GradePlus/screens/login/screens/login_screen.dart';
import 'package:GradePlus/screens/admin_section/adminscreen.dart';
import 'package:GradePlus/screens/moderator_section/ModeratorScreen.dart';
import 'package:GradePlus/screens/user_section/components/sidenav/aboutus.dart';
import 'package:GradePlus/splash_screen.dart';
import 'screens/login/record/firebase_options.dart';
import 'screens/user_section/homescreen.dart';
import 'onboarding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GradePlus',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/aboutUs': (context) => const Aboutus(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/adminScreen': (context) => const AdminScreen(),
        '/moderatorScreen': (context) => const ModeratorScreen(),
        '/homeScreen': (context) => HomeScreen(
          initialSemester: semester,
          initialBatch: batch,
          initialBranch: branch,
        ),
      },
    );
  }
}
