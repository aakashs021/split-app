import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/services/auth_service.dart';
import 'package:demo/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo/presentation/controllers/login_page/submit_button_getx.dart';
import 'package:demo/presentation/pages/login_page/login_page.dart';
import 'package:demo/presentation/widgets/login_page/loginpage_snackbar.dart';

var firestore = FirebaseFirestore.instance;

newuserLogin(
    {required BuildContext context,
    required String name,
    required String phone,
    required String email,
    required String password}) async {
  try {
    Get.find<SubmitButtonGetx>().onTap();
    DatabaseService().newUserLoginDetailStorage(
        context: context,
        name: name,
        phone: phone,
        email: email,
        password: password);
    await AuthService().newUserLoginAuth(
        context: context,
        name: name,
        phone: phone,
        email: email,
        password: password);


    Get.to(() => LoginPage());
    Get.delete<SubmitButtonGetx>();
  } on FirebaseAuthException catch (e) {
    loginpageSnackbar(context: context, e: e.message);
  }
}

newGoogleUserLogin(
    {required String email,
    required String name,
    required String phone}) async {
  Map<String, dynamic> datamodel = {
    'name': name,
    'email': email,
    'phone': phone
  };
  var doc = await firestore
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.email)
      .get();

  if (!doc.exists) {
    await firestore
        .collection('users')
        .doc(email)
        .set(datamodel, SetOptions(merge: true));
    Map<String, dynamic> newfreind = {'email': []};
    await firestore
        .collection('friends')
        .doc(email)
        .set(newfreind, SetOptions(merge: true));
  }
}
