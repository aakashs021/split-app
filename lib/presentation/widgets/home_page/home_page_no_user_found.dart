import 'package:demo/presentation/widgets/home_page/freind_page_two_elevated_buttons.dart';
import 'package:flutter/material.dart';

Widget homePageNoUserFound() {
  return Center(
    child: Column(
      children: [
        const SizedBox(
          height: 200,
        ),
        const Text(
          'No friends found.',
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 100),
        freindPageTwoElevatedButtons()
      ],
    ),
  );
}