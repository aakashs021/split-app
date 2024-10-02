import 'package:demo/presentation/pages/add_people_screen/add_people.dart';
import 'package:demo/presentation/pages/login_page/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quickalert/quickalert.dart';

Widget freindPageTwoElevatedButtons({required BuildContext context}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Get.to(() =>  AddPeople());
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue.shade400,
              elevation: 4, // Text color
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Rounded corners
              ),
            ),
            child: const Text('Add People'),
          ),
        ),
        const SizedBox(width: 10), // Space between buttons
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              QuickAlert.show(
                context: context,
                type: QuickAlertType.confirm,
                text: 'Do you want to logout',
                confirmBtnText: 'Yes',
                cancelBtnText: 'No',
                confirmBtnColor: Colors.white,
                backgroundColor: Colors.black,
                headerBackgroundColor: Colors.grey,
                confirmBtnTextStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                // barrierColor: Colors.white,
                titleColor: Colors.white,
                textColor: Colors.white,
                onCancelBtnTap: () => Navigator.pop(context),
                onConfirmBtnTap: () {
                  GoogleSignIn().signOut();
                  FirebaseAuth.instance.signOut();
                  Get.to(() => LoginPage());
                },
              );
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.red.shade400,
              elevation: 4, // Text color
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Rounded corners
              ),
            ),
            child: const Text('Sign Out'),
          ),
        ),
      ],
    ),
  );
}
