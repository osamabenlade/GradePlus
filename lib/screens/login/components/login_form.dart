



import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import '../../../constants.dart';
import '../../../firebase_services.dart';
import '../../../homescreen.dart';





bool is_visible =false;

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
    TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {

    return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
            child: Form(
              child: Column(
                children: [
          //         SizedBox(
          //   height: 55.0,
          //   child: TextFormField(
          //     controller: email,
          //     keyboardType: TextInputType.text,
          //     textInputAction: TextInputAction.next,
          //     cursorColor: kPrimaryColor,
          //     onSaved: (text) {},
          //     decoration: InputDecoration(
          //       filled: true,
          //       fillColor: kPrimaryLightColor,
          //
          //       border: OutlineInputBorder(
          //           borderSide: BorderSide(width: 3,color: kPrimaryColor),
          //           borderRadius: BorderRadius.circular(50.0)
          //       ),
          //       labelText: "User ID",
          //       labelStyle: TextStyle(fontSize: 16),
          //       //hintText: "Enrollment ID",
          //       prefixIcon: Padding(
          //         padding: EdgeInsets.all(defaultPadding),
          //         child: Icon(Icons.person,
          //         color: kPrimaryColor,),
          //       ),
          //     ),
          //   ),
          //
          // ),
          // SizedBox(
          //   height: 20,
          // ),
          // SizedBox(
          //   height: 55.0,
          //   child: TextFormField(
          //     controller: password,
          //     keyboardType: TextInputType.text,
          //     textInputAction: TextInputAction.done,
          //     obscureText: !is_visible,
          //     cursorColor: kPrimaryColor,
          //     decoration: InputDecoration(
          //         filled: true,
          //         fillColor: kPrimaryLightColor,
          //         border: OutlineInputBorder(
          //             borderSide: BorderSide(width: 3,color: kPrimaryColor),
          //             borderRadius: BorderRadius.circular(50.0)
          //         ),
          //         labelText: "Security Key",
          //         labelStyle: TextStyle(fontSize: 16),
          //         prefixIcon: Padding(
          //           padding: EdgeInsets.all(defaultPadding),
          //           child: Icon(Icons.lock,
          //           color: kPrimaryColor,),
          //         ),
          //         suffixIcon: IconButton(
          //
          //
          //           icon: Icon(
          //               is_visible ? Icons.visibility_off : Icons.visibility),
          //           color: kPrimaryColor,
          //           onPressed: () =>
          //               setState(() {
          //                 is_visible = !is_visible;
          //               }),
          //
          //         )
          //     ),
          //   ),
          // ),
          const SizedBox(height: 30),
              GestureDetector(
              onTap: () async {
              await FirebaseServices().signInWithGoogle(context);
              // Navigator.push(context,
              // MaterialPageRoute(builder: (context) => LoginDetailScreen()));
              },
                /*onTap: () {
                  FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                      email: email.text,
                      password: password.text)
                      .then((value) {
                    print("Created New Account");
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  }).onError((error, stackTrace) {
                    print("Error ${error.toString()}");
                  });*/





                child: Container(
                  height: 53,
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 4,
                            color: Colors.black12.withOpacity(.2),
                            offset: const Offset(2, 2))
                      ],
                      borderRadius: BorderRadius.circular(100),
                      gradient: LinearGradient(colors: [
                        kPrimaryLightColor,
                        Colors.amber.shade900
                      ])),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/google_logo.png', // Replace with the actual path to your PNG image
                        height: 30, // Adjust the height as needed
                        width: 30, // Adjust the width as needed
                      ),
                      SizedBox(width: 8), // Adjust the width as needed for spacing
                      Text(
                        'Continue with Google',
                        style: TextStyle(
                          color: Colors.white.withOpacity(.8),
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          // AlreadyHaveAnAccountCheck(
          //   press: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) {
          //           return const SignUpScreen();
          //         },
          //       ),
          //     );
          //   },
          // ),
        ],
      ),
    )));
  }
}

