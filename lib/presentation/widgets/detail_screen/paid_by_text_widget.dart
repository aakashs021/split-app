import 'package:demo/presentation/widgets/detail_screen/paid_by_string.dart';
import 'package:flutter/material.dart';

Widget paidByTextWidget({required int paid, required String name}) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      const Text('Paid: '),
      SizedBox(
        width: 120,
        child: Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          padiByString(paid: paid, name: name),
          style: const TextStyle(),
        ),
      ),
      // Text('slkdfjosfdoisdfsdjdjiodioj')
    ],
  );
}