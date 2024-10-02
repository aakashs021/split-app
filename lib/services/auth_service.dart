import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/presentation/controllers/login_page/new_user_login_controller.dart';
import 'package:demo/presentation/controllers/login_page/submit_button_getx.dart';
import 'package:demo/presentation/pages/login_page/login_page.dart';
import 'package:demo/presentation/widgets/login_page/loginpage_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class AuthService {
  final _firebase_auth=FirebaseAuth.instance;

  newUserLoginAuth(
    {required BuildContext context,
    required String name,
    required String phone,
    required String email,
    required String password}) async {
  try {
    Get.find<SubmitButtonGetx>().onTap();
    await _firebase_auth.createUserWithEmailAndPassword(email: email, password: password);
          
    
  } on FirebaseAuthException catch (e) {
    loginpageSnackbar(context: context, e: e.message);
  }
}
}