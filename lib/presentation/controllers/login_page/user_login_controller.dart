import 'package:demo/presentation/pages/add_expense_screen/add_expense.dart';
import 'package:demo/presentation/widgets/home_page/friend_page_stream_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:demo/presentation/pages/bottom_nav_bar/bottom_nav.dart';
import 'package:demo/presentation/pages/home_page/home_screen.dart';
import 'package:demo/presentation/widgets/login_page/loginpage_snackbar.dart';

userLogin(
    {required BuildContext context,
    required String email,
    required String password}) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
        useremail=firebaseauth.currentUser!.email!;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => BottomNav(),
      ),
      (route) => false,
    );
  } on FirebaseAuthException catch (e) {
    String errorMessage;
    switch (e.code) {
      case 'user-not-found':
        errorMessage = 'No user found for that email.';
        break;
      case 'wrong-password':
        errorMessage = 'Wrong password provided for that user.';
        break;
      case 'invalid-credential':
        errorMessage = 'The email address or password in incorrect';
        break;
      default:
        errorMessage = 'An unexpected error occurred.';
    }
    loginpageSnackbar(context: context, e: errorMessage);
  }
}
