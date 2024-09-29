import 'package:demo/presentation/controllers/login_page/new_user_login_controller.dart';
import 'package:demo/presentation/pages/bottom_nav_bar/bottom_nav.dart';
import 'package:demo/presentation/pages/login_page/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

Widget signinGoogleWidget({required BuildContext context}) {
  return Align(
    alignment: Alignment.center,
    child: InkWell(
      onTap: () async {
        // Show loading animation for at least 1.5 seconds
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Center(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: 100, // Set a maximum width
                    maxHeight: 100, // Set a maximum height
                  ),
                  child: LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.white,
                    size: 50, // Set the size of the loading animation
                  ),
                ),
              ),
            );
          },
        );

        // Wait for at least 1.5 seconds before proceeding
        // await Future.delayed(Duration(milliseconds: 0));

        // Perform Google Sign-In
        await googlesignin();
        var user = FirebaseAuth.instance.currentUser;

        // Close the loading dialog after sign-in is complete
        Navigator.of(context).pop();

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
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Image.asset(
          'assets/images/google_logo.png',
          height: 100,
        ),
      ),
    ),
  );
}
