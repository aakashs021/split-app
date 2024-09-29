import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/presentation/controllers/login_page/new_user_login_controller.dart';
import 'package:demo/presentation/widgets/home_page/freind_page_two_elevated_buttons.dart';
import 'package:demo/presentation/widgets/home_page/home_list_page_owes.dart';
import 'package:demo/presentation/widgets/home_page/shimmer_home_page_for_stream_money.dart';
import 'package:flutter/material.dart';

Widget homePageList({
  required emailList,
  required context,
}) {
  return ListView(
    children: [
      ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: emailList.length,
        itemBuilder: (context, index) {
          return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: firestore.collection('users').doc(emailList[index]).get(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return shimmerHomePageforStreamMoney();
              }

              if (userSnapshot.hasError) {
                return const Center(child: Text('Error fetching user details'));
              }

              return homePageListOwes(
                  userSnapshot: userSnapshot, index: index, context: context);
            },
          );
        },
      ),
      const SizedBox(height: 20),
      freindPageTwoElevatedButtons(context: context)
    ],
  );
}
