import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget shimmerHomePageforStream() {
  return Shimmer.fromColors(
    baseColor: Colors.black12,
    highlightColor: Colors.white10,
    child: ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
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
        );
      },
    ),
  );
}