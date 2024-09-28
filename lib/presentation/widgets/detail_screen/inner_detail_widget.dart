import 'package:demo/model/expense_model.dart';
import 'package:demo/model/user_model.dart';
import 'package:demo/presentation/pages/payment_detail_screen/payment_detail.dart';
import 'package:demo/presentation/widgets/detail_screen/amount_text.dart';
import 'package:demo/presentation/widgets/detail_screen/paid_by_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget innerDetailingWidget({
  required UserModel usermodel,
  required ExpenseModel expenseModel,
}) {
  return Card(
    color: Colors.grey.shade300,
    // Use Card to add elevation and styling
    elevation: 4, // Adjust elevation for shadow effect
    margin: const EdgeInsets.symmetric(
        vertical: 8, horizontal: 16), // Margin around the card
    shape: RoundedRectangleBorder(
      // Optional: Round the corners of the card
      borderRadius: BorderRadius.circular(10),
    ),
    child: ListTile(
      onTap: () {
        Get.to(() => PaymentDetail(
              userModel: usermodel,
              expenseModel: expenseModel,
            ));
      },
      leading: const Icon(Icons.receipt,
          size: 30), // Larger icon for better visibility
      title: Text(
        overflow: TextOverflow.ellipsis,
        expenseModel.description,
        style: const TextStyle(fontWeight: FontWeight.bold), // Bold title
      ),
      subtitle: paidByTextWidget(paid: expenseModel.paid, name: usermodel.name),
      trailing: amountText(
        data: expenseModel.amount.toString(),
        amount: expenseModel.amount,
      ),
    ),
  );
}