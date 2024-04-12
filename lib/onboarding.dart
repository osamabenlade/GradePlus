

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gradeplus/screens/login/login_screen.dart';





class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (BuildContext context, Widget? widget) => MaterialApp(
        title: "Hello",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: OnboardingScreen1(),
      ),
      designSize: Size(360, 640),
    );
  }

}

class OnboardingScreen1 extends StatefulWidget{
  @override
  State<OnboardingScreen1> createState() => _OnboardingScreen1State();
}

class _OnboardingScreen1State extends State<OnboardingScreen1> {
  int _currentIndex = 0;

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context){
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFF2A2828),
      body: Stack(
        children: [
          CustomPaint(
            painter: ArcPainter(),
            child: SizedBox(
              height: screenSize.height / 1.4,
              width: screenSize.width,
            ),
          ),
          Positioned(
            top: 50.h,
            right: 5.w,
            left: 5.w,
            child: Image.asset(
              tabs[_currentIndex].imgpath,
              key: Key('${Random().nextInt(999999999)}'),
              width: 600.w,
              height: 300.h,
              alignment: Alignment.topCenter,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 250.h,
              child: Column(
                children: [
                  Flexible(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: tabs.length,
                      itemBuilder: (BuildContext context, int index) {
                        OnboardingModel tab = tabs[index];
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 30.h),
                            Expanded(
                              child: Center(
                                child: Text(
                                  tab.title,
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.cyan,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 30.h),
                          ],
                        );
                      },
                      onPageChanged: (value) {
                        _currentIndex = value;
                        setState(() {});
                      },
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (int index = 0; index < tabs.length; index++)
                        _DotIndicator(isSelected: index == _currentIndex),
                    ],
                  ),
                  SizedBox(height: 75.h)
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_currentIndex == 2) {
            Navigator.push(context,
                // MaterialPageRoute(builder: (context) => HomeScreen()));
                MaterialPageRoute(builder: (context) => const LoginScreen()));
          } else {
            _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.linear,
            );
          }
        },
        child: const Icon(CupertinoIcons.chevron_right, color: Colors.white),
        backgroundColor: Colors.cyan,
      ),
    );
  }
}


class ArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path orangeArc = Path()
      ..moveTo(0, 0)
      ..lineTo(0, size.height - 170)
      ..quadraticBezierTo(
          size.width / 2, size.height, size.width, size.height - 170)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(orangeArc, Paint()..color = Colors.orange);

    Path whiteArc = Path()
      ..moveTo(0.0, 0.0)
      ..lineTo(0.0, size.height - 185)
      ..quadraticBezierTo(
          size.width / 2, size.height - 70, size.width, size.height - 185)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(whiteArc, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class _DotIndicator extends StatelessWidget {
  final bool isSelected;

  const _DotIndicator({Key? key, required this.isSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 6.0,
        width: 6.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Colors.white : Colors.white38,
        ),
      ),
    );
  }
}

class OnboardingModel {
  final String imgpath;
  final String title;


  OnboardingModel(this.imgpath , this.title);
}

List<OnboardingModel> tabs = [
  OnboardingModel(
    'assets/test.png',
    'page 1.................'
  ),
  OnboardingModel(
    'assets/test.png',
    'page 2..............................'
  ),
  OnboardingModel(
    'assets/test.png',
    'write later...........................'
  ),
];