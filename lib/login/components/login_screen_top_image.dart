import 'package:flutter/cupertino.dart';

import '../../constants.dart';




class LoginScreenTopImage extends StatelessWidget {
  const LoginScreenTopImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "LOGIN",
          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
             Spacer(),
             Expanded(
             flex: 8,
             child: Image.asset("assets/images/logo.png",height: 210,width: 210,),
             ),
             Spacer(),
          ],
        ),
        const SizedBox(height: defaultPadding * 2),
      ],
    );
  }
}