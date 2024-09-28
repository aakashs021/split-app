import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget shimmerHomePageforStreamMoney() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[200]!,
    child: Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Container(
          height: 10.0,
          color: Colors.white,
        ),
        subtitle: Container(
          height: 10.0,
          color: Colors.white,
        ),
      ),
    ),
  );
}