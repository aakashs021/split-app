import 'package:demo/presentation/pages/add_expense_screen/add_expense.dart';
import 'package:demo/presentation/widgets/home_page/friend_page_stream_builder.dart';
import 'package:demo/presentation/widgets/login_page/loginpage_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final _firebase_auth = FirebaseAuth.instance;

static String? email;  

  getUserEmail(){
email= _firebase_auth.currentUser!.email!;
  }

  newUserLoginAuth(
      {required BuildContext context,
      required String name,
      required String phone,
      required String email,
      required String password}) async {
    try {
      await _firebase_auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if(context.mounted){
      loginpageSnackbar(context: context, e: e.message);
      }
    }
  }

  userLogin(
    {required BuildContext context,
    required String email,
    required String password}) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
        useremail=firebaseauth.currentUser!.email!;
  
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
    if(context.mounted){
    loginpageSnackbar(context: context, e: errorMessage);
    }
  }
}
}
