import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/model/expense_model.dart';
import 'package:demo/presentation/controllers/expense_split/expense_split_getx.dart';
import 'package:demo/presentation/pages/expense_split_screen/expense_split.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo/model/user_model.dart';
import 'package:demo/presentation/controllers/login_page/new_user_login_controller.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

String useremail = FirebaseAuth.instance.currentUser!.email!;

class AddExpense extends StatefulWidget {
  AddExpense({super.key, required this.usermodel, this.expenseModel});
  UserModel usermodel;
  ExpenseModel? expenseModel;

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  final expensedemo = Get.put(ExpenseSplitGetx());

  TextEditingController descriptioncontroller = TextEditingController();

  TextEditingController amountcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    descriptioncontroller.text = widget.expenseModel?.description ?? "";
    String amountText = '';
    if (widget.expenseModel != null) {
      amountText = widget.expenseModel!.amount.toString();
    }
    amountcontroller.text = amountText;
  }

  @override
  Widget build(BuildContext context) {
    print(widget.usermodel?.name);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add expense'),
          // actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.add))],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('You  with  '),
                  widget.usermodel != null
                      ? Text(widget.usermodel!.name)
                      : const Text('no')
                ],
              ),
              SizedBox(
                height: 100,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt,
                    size: 75,
                    color: Colors.grey.shade500,
                  ),
                  SizedBox(
                      width: 200,
                      child: TextField(
                        controller: descriptioncontroller,
                        decoration:
                            const InputDecoration(hintText: 'Description'),
                      )),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.currency_bitcoin,
                    size: 75,
                    color: Colors.grey.shade500,
                  ),
                  SizedBox(
                      width: 200,
                      child: TextField(
                        controller: amountcontroller,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(hintText: 'Amount'),
                      )),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('Select the payment options :'),
              GetBuilder<ExpenseSplitGetx>(
                builder: (controller) {
                  return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade300,
                          foregroundColor: Colors.white,
                          fixedSize: Size.fromWidth(200)),
                      onPressed: () {
                        Get.to(
                            () => ExpenseSplit(paid: paidBy[controller.index]));
                      },
                      child: Text(paidBy[controller.index]));
                },
              ),
              const SizedBox(height: 20), // Use a fixed height spacing
              // Remove Expanded and directly add the button
              AddExpenseSubmitButton(
                  context: context,
                  descriptioncontroller: descriptioncontroller,
                  amountcontroller: amountcontroller,
                  usermodel: widget.usermodel,
                  isedit: widget.expenseModel != null,
                  expenseModel: widget.expenseModel),
              const SizedBox(
                height: 40,
              )
            ],
          ),
        ));
  }
}

Widget AddExpenseSubmitButton(
    {required BuildContext context,
    required TextEditingController descriptioncontroller,
    required TextEditingController amountcontroller,
    required UserModel usermodel,
    required bool isedit,
    ExpenseModel? expenseModel}) {
  return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black, foregroundColor: Colors.white),
          onPressed: () async {
            // Validate input before proceeding
            if (descriptioncontroller.text.isEmpty &&
                amountcontroller.text.isEmpty) {
              _showSnackBar(context, 'Description and amount cannot be empty!');
              return;
            } else if (descriptioncontroller.text.isEmpty) {
              _showSnackBar(context, 'Description cannot be empty!');
              return;
            } else if (amountcontroller.text.isEmpty) {
              _showSnackBar(context, 'Amount cannot be empty!');
              return;
            }

            num? amount = num.tryParse(amountcontroller.text);
            if (amount == null) {
              _showSnackBar(context, 'Please enter a valid numeric amount!');
              return;
            }
            String text = isedit
                ? 'Do you want to continue? Please click on edit to continue else click on no.'
                : 'Do you want to continue? Please click on add to continue else click on no.';
            String confirmBtnText = isedit ? 'Edit' : 'Add';
            QuickAlert.show(
              context: context,
              type: QuickAlertType.confirm,
              text: text,
              confirmBtnText: confirmBtnText,
              cancelBtnText: 'No',
              confirmBtnColor: Colors.white,
              backgroundColor: Colors.black,
              headerBackgroundColor: Colors.grey,
              confirmBtnTextStyle: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              // barrierColor: Colors.white,
              titleColor: Colors.white,
              textColor: Colors.white,
              onCancelBtnTap: () => Navigator.pop(context),
              onConfirmBtnTap: () {
                expenseAddToFirebase(
                    expenseModel: expenseModel,
                    context: context,
                    amount: amount,
                    descriptioncontroller: descriptioncontroller,
                    usermodel: usermodel);
              },
            );
          },
          child: Text(isedit ? 'Edit' : 'ADD')));
}

// Method to show snackbar
void _showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      margin: const EdgeInsets.only(bottom: 650, left: 20, right: 20),
      behavior: SnackBarBehavior.floating,
      content: Center(child: Text(message)),
      backgroundColor: Colors.red,
    ),
  );
}

expenseAddToFirebase(
    {required BuildContext context,
    required num amount,
    required TextEditingController descriptioncontroller,
    required UserModel usermodel,
    ExpenseModel? expenseModel}) {
  bool isedit = expenseModel != null;
  String dateTime = DateTime.now().microsecondsSinceEpoch.toString();
  // print(dateTime);
  String date = isedit
      ? expenseModel.dateTime.microsecondsSinceEpoch.toString()
      : dateTime;

  int demo = Get.find<ExpenseSplitGetx>().index;
  if (demo == 2) {
    amount = amount / 2;
  } else if (demo == 1) {
    amount = -amount;
  }

  Map<String, dynamic> data = {
    'paid': demo,
    'des': descriptioncontroller.text,
    'amount': amount,
  };
  // String dateTime = DateTime.now().microsecondsSinceEpoch.toString();
  if (isedit) {
    Navigator.pop(context);
  }
  Navigator.pop(context);
  Navigator.pop(context);

  // Save data for current user
  // var firstUser = firestore
  //     .collection('expense')
  //     .doc(useremail)
  //     .collection(usermodel.email)
  //     .doc(date);

  // isedit ? firstUser.update(data) : firstUser.set(data);
  firestore
      .collection('expense')
      .doc(useremail)
      .collection(usermodel.email)
      .doc(date)
      .set(data);
  firestore
      .collection('total')
      .doc(useremail)
      .collection(usermodel.email)
      .doc('total')
      .set(
    {'total': FieldValue.increment(amount)},
    SetOptions(
        merge:
            true), // Merges with existing data, or creates if it doesn't exist
  );
  // Adjust amount and save for friend
  int frienddemo = (demo == 2) ? 2 : (demo == 0 ? 1 : 0);
  amount = -amount; // Flip amount for the friend
  data['amount'] = amount;
  data['paid'] = frienddemo;
  // var secondUser = firestore
  //     .collection('expense')
  //     .doc(usermodel.email)
  //     .collection(useremail)
  //     .doc(dateTime);
  // isedit ? secondUser.update(data) : secondUser.set(data);

  firestore
      .collection('expense')
      .doc(usermodel.email)
      .collection(useremail)
      .doc(date)
      .set(data);

  firestore
      .collection('total')
      .doc(usermodel.email)
      .collection(useremail)
      .doc('total')
      .set(
    {'total': FieldValue.increment(amount)},
    SetOptions(
        merge:
            true), // Merges with existing data, or creates if it doesn't exist
  );
}
