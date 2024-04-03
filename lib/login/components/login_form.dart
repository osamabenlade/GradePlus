



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../homescreen.dart';



bool is_visible =false;

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
    TextEditingController uid = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {

    return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
            child: Form(
              child: Column(
                children: [
                  SizedBox(
            height: 55.0,
            child: TextFormField(
              controller: uid,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              onSaved: (text) {},
              decoration: InputDecoration(
                filled: true,
                fillColor: kPrimaryLightColor,

                border: OutlineInputBorder(
                    borderSide: BorderSide(width: 3,color: kPrimaryColor),
                    borderRadius: BorderRadius.circular(50.0)
                ),
                labelText: "User ID",
                labelStyle: TextStyle(fontSize: 16),
                //hintText: "Enrollment ID",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.person,
                  color: kPrimaryColor,),
                ),
              ),
            ),

          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 55.0,
            child: TextFormField(
              controller: password,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              obscureText: !is_visible,
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: kPrimaryLightColor,
                  border: OutlineInputBorder(
                      borderSide: BorderSide(width: 3,color: kPrimaryColor),
                      borderRadius: BorderRadius.circular(50.0)
                  ),
                  labelText: "Security Key",
                  labelStyle: TextStyle(fontSize: 16),
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(defaultPadding),
                    child: Icon(Icons.lock,
                    color: kPrimaryColor,),
                  ),
                  suffixIcon: IconButton(


                    icon: Icon(
                        is_visible ? Icons.visibility_off : Icons.visibility),
                    color: kPrimaryColor,
                    onPressed: () =>
                        setState(() {
                          is_visible = !is_visible;
                        }),

                  )
              ),
            ),
          ),
          const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen() // Replace HomeScreen() with your actual home screen widget
                    ),
                  );

                },
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
                        Colors.purple.shade600,
                        Colors.amber.shade900
                      ])),
                  child: Text('Login',
                      style: TextStyle(
                          color: Colors.white.withOpacity(.8),
                          fontSize: 17,
                          fontWeight: FontWeight.bold)),
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

