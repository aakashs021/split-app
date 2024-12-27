import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/presentation/widgets/login_page/loginpage_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  final _firestore = FirebaseFirestore.instance;

  newUserLoginDetailStorage(
      {required BuildContext context,
      required String name,
      required String phone,
      required String email,
      required String password}) {
    try {
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
    } on FirebaseAuthException catch (e) {
      loginpageSnackbar(context: context, e: e.message);
    }
  }
}
