import 'package:flutter/material.dart';

Widget amountText(
    {required String data, required num amount, String isPage = 'detail'}) {
  return SizedBox(
    width: isPage != 'detail' ? null : 70,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          isPage == 'detail' ? 'Amount' : 'owes',
          style: const TextStyle(fontSize: 16), // Adjust as needed
        ),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: data,
                style: TextStyle(
                    fontSize: 17,
                    color: amount >= 0 ? Colors.green : Colors.red),
              ),
              TextSpan(
                text: '\$', // Dollar sign as a separate span
                style: TextStyle(
                  fontSize: 17,
                  color: amount >= 0 ? Colors.green : Colors.red,
                  // baseline: TextBaseline.alphabetic,
                ),
              ),
            ],
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    ),
  );
}
