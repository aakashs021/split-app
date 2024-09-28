import 'package:demo/presentation/pages/login_page/login_page.dart';
import 'package:demo/presentation/pages/sign_up_page/signup_page.dart';
import 'package:flutter/material.dart';

Widget loginBottomText(
    {int page = 0, required double height, required BuildContext context}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        page == 0 ? 'Not a member?' : 'Alredy have an account?',
        style: TextStyle(color: Colors.grey.shade700),
      ),
      SizedBox(
        width: 4,
      ),
      InkWell(
        onTap: () {
          page == 0
              ? Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SignupPage(),
                ))
              : Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                  (route) => false,
                );
        },
        child: Text(
          page == 0 ? 'Register now' : 'Sign in',
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
      )
    ],
  );
}