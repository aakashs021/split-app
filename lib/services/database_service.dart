import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/presentation/controllers/login_page/submit_button_getx.dart';
import 'package:demo/presentation/pages/login_page/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class DatabaseService {
  final _firestore=FirebaseFirestore.instance;

  newUserDetailStorage(
    {required BuildContext context,
    required String name,
    required String phone,
    required String email,
    required String password})
{
  Map<String, dynamic> datamodel = {
      'name': name,
      'email': email,
      'phone': phone
    };
     _firestore
        .collection('users')
        .doc(email)
        .set(datamodel, SetOptions(merge: true));
    Map<String, dynamic> newfreind = {'email': []};

     _firestore
        .collection('friends')
        .doc(email)
        .set(newfreind, SetOptions(merge: true));
        Get.to(() => LoginPage());
    Get.delete<SubmitButtonGetx>();
}


}