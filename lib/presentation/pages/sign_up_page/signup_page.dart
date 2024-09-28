import 'package:demo/presentation/widgets/login_page/login_bottom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo/presentation/controllers/login_page/validation_functions_controller.dart';
import 'package:demo/presentation/controllers/login_page/visibility_getx.dart';
import 'package:demo/presentation/widgets/login_page/login_button.dart';
import 'package:demo/presentation/widgets/login_page/loginpagetextform.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  final formkey = GlobalKey<FormState>();

  final List<TextEditingController> controller = List.generate(
    4,
    (index) => TextEditingController(),
  );

  final visibilityController = Get.put(VisibilityGetx(), tag: 'signup');

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
                  name: "Name",
                  controller: controller[0],
                  validation: validatename,
                ),
                SizedBox(
                    height: MediaQuery.of(context).size.height *
                        0.02), // Responsive height
                loginpagetextformfeild(
                  name: "Email",
                  controller: controller[1],
                  validation: validateEmail,
                ),
                SizedBox(
                    height: MediaQuery.of(context).size.height *
                        0.02), // Responsive height
                loginpagetextformfeild(
                  name: "Phone number",
                  controller: controller[2],
                  validation: validatePhoneNumber,
                ),
                SizedBox(
                    height: MediaQuery.of(context).size.height *
                        0.02), // Responsive height
                GetBuilder<VisibilityGetx>(
                  builder: (visibility) {
                    return loginpagetextformfeild(
                      name: "Password",
                      visibilitycallback: visibility,
                      controller: controller[3],
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
                  page: 'signup',
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                loginBottomText(
                    page: 1,
                    height: MediaQuery.of(context).size.height * 0.02,
                    context: context)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
