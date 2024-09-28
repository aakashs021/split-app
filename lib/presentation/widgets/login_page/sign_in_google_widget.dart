
import 'package:demo/presentation/controllers/login_page/new_user_login_controller.dart';
import 'package:demo/presentation/pages/bottom_nav_bar/bottom_nav.dart';
import 'package:demo/presentation/pages/login_page/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Widget signinGoogleWidget({required BuildContext context}) {
  return Align(
    alignment: Alignment.center,
    child: InkWell(
      onTap: () async {
        await googlesignin();
        var user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          newGoogleUserLogin(
            email: user.email!,
            name: user.displayName!,
            phone: 'phone',
          );
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => BottomNav(),
            ),
            (route) => false,
          );
          // Get.clearRouteTree( () => BottomNav());
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 0),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.7),
              blurRadius: 5,
              offset: const Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        child: Image.asset(
          'assets/images/google_logo.png', // Update this to your JPEG file path
          height: 100, // Set a fixed height for the image
        ),
      ),
    ),
  );
}