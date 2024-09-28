import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/presentation/widgets/home_page/home_page_list.dart';
import 'package:demo/presentation/widgets/home_page/home_page_no_user_found.dart';
import 'package:demo/presentation/widgets/home_page/shimmer_home_page_for_stream.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:demo/presentation/controllers/login_page/new_user_login_controller.dart';

var firebaseauth = FirebaseAuth.instance;

Widget homePageStreamBuilderFreinds() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: firestore
          .collection('friends')
          .doc(firebaseauth.currentUser!.email)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return shimmerHomePageforStream();
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error fetching friends'));
        }

        var data = snapshot.data?.data();
        List<dynamic>? emailList = data?['email'];

        if (emailList != null && emailList.isNotEmpty) {
          return homePageList(emailList: emailList, context: context);
        } else {
          return homePageNoUserFound();
        }
      },
    ),
  );
}
