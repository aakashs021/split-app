import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo/fonts.dart';
import 'package:demo/model/user_model.dart';
import 'package:demo/presentation/pages/add_expense_screen/add_expense.dart';

Widget floatingAddExpense({required UserModel usermodel}) {
  return InkWell(
    onTap: () async {
      Get.to(() => AddExpense(
            usermodel: usermodel,
          ));
    },
    child: Container(
      margin: EdgeInsets.only(bottom: 40),
      width: 170,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.black87),
      height: 50,
      child: Row(
        children: [
          const SizedBox(
            width: 5,
          ),
          Icon(
            Icons.list,
            size: 30,
            color: Colors.white,
          ),
          const SizedBox(
            width: 10,
          ),
          floatingActionButtontext("Add expense", Colors.white, 18)
        ],
      ),
    ),
  );
}
