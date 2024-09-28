 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/model/expense_model.dart';
import 'package:demo/model/user_model.dart';
import 'package:demo/presentation/controllers/login_page/new_user_login_controller.dart';
import 'package:demo/presentation/pages/add_expense_screen/add_expense.dart';
import 'package:flutter/material.dart';

paymentMethod({
  required BuildContext context,
  required UserModel userModel,
  required ExpenseModel expenseModel,
  required bool isDecline, // Flag to differentiate between decline and payment
}) {
  String date = expenseModel.dateTime.microsecondsSinceEpoch.toString();
  Navigator.pop(context);

  firestore
      .collection('expense')
      .doc(useremail)
      .collection(userModel.email)
      .doc(date)
      .delete();

  firestore
      .collection('expense')
      .doc(userModel.email)
      .collection(useremail)
      .doc(date)
      .delete();

  // Update total in the corresponding user's subcollection
  firestore
      .collection('total')
      .doc(isDecline ? userModel.email : useremail) // Adjust total based on isDecline
      .collection(isDecline ? useremail : userModel.email)
      .doc('total')
      .set({
    'total': FieldValue.increment(isDecline
        ? expenseModel.amount
        : expenseModel.amount * -1), // Invert amount for decline
  }, SetOptions(merge: true));

  // Convert date to an integer format
  int intDate = int.parse(date);

  // Map for payment data
  Map payemtMapUser1 = {
    'amount': expenseModel.amount,
    'paid': expenseModel.paid,
    'des': expenseModel.description,
    'date': intDate,
    'email': userModel.email,
    'status': !isDecline, // Set status based on isDecline
    'by': userModel.email,
  };

  // Current date for tracking payment updates
  String currentDate = DateTime.now().microsecondsSinceEpoch.toString();

  // Update payment records in both users' documents
  firestore.collection('payment').doc(useremail).set({
    currentDate: FieldValue.arrayUnion([payemtMapUser1])
  }, SetOptions(merge: true));

  // Adjust the paid status based on the original state
  int paid;
  if(expenseModel.paid==0){
paid=1;
  }else if(expenseModel.paid==1){
    paid=0;
  }else{
    paid=2;
  }
  payemtMapUser1['paid'] = paid ;
  payemtMapUser1['amount'] = isDecline ? expenseModel.amount * -1 : expenseModel.amount;

  firestore.collection('payment').doc(userModel.email).set({
    currentDate: FieldValue.arrayUnion([payemtMapUser1])
  }, SetOptions(merge: true));

  // Update the total again if the action was not declined
  if (!isDecline) {
    firestore
        .collection('total')
        .doc(useremail)
        .collection(userModel.email)
        .doc(date)
        .set({
      'total': FieldValue.increment(expenseModel.amount * -1)
    }, SetOptions(merge: true));
  }
}
