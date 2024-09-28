import 'package:demo/presentation/pages/add_expense_screen/add_expense.dart';
import 'package:demo/presentation/widgets/home_page/friend_page_stream_builder.dart';
import 'package:demo/presentation/widgets/login_page/login_bottom_text.dart';
import 'package:demo/presentation/widgets/login_page/sign_in_google_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:demo/presentation/controllers/login_page/validation_functions_controller.dart';
import 'package:demo/presentation/controllers/login_page/visibility_getx.dart';
import 'package:demo/presentation/widgets/login_page/login_button.dart';
import 'package:demo/presentation/widgets/login_page/loginpagetextform.dart';
import 'package:demo/presentation/widgets/login_page/or_text_widget.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final formkey = GlobalKey<FormState>();

  final List<TextEditingController> controller = List.generate(
    2,
    (index) => TextEditingController(),
  );

  final visibilityController = Get.create(() => VisibilityGetx());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
        child: Form(
          key: formkey,
          child: Padding(
            padding: EdgeInsets.all(
                MediaQuery.of(context).size.width * 0.05), // Responsive padding
            child: ListView(
              children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height *
                        0.05), // Responsive height
                const Icon(
                  color: Colors.black,
                  Icons.lock,
                  size: 200,
                ),
                SizedBox(
                    height: MediaQuery.of(context).size.height *
                        0.05), // Responsive height
                loginpagetextformfeild(
                  name: "Email",
                  controller: controller[0],
                  validation: validateEmail,
                ),
                SizedBox(
                    height: MediaQuery.of(context).size.height *
                        0.02), // Responsive height
                GetBuilder<VisibilityGetx>(
                  builder: (visibility) {
                    return loginpagetextformfeild(
                      name: "Password",
                      visibilitycallback: visibility,
                      controller: controller[1],
                      validation: validatename,
                      password: true,
                    );
                  },
                ),
                SizedBox(
                    height: MediaQuery.of(context).size.height *
                        0.02), // Responsive height
                loginButton(
                  context: context,
                  formkey: formkey,
                  controller: controller,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.005,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    forgotPassword(),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                orWidget(),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                signinGoogleWidget(context: context),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                loginBottomText(
                  context: context,
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget forgotPassword() {
  return Text(
    'forgot password?',
    style: TextStyle(color: Colors.grey.shade700),
  );
}



Future<void> googlesignin() async {
  try {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      return; // User canceled the sign-in
    }
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final cred = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
    await FirebaseAuth.instance.signInWithCredential(cred);
    useremail=firebaseauth.currentUser!.email!;
  } on FirebaseAuthException {
    // print(e.toString());
  }
}

