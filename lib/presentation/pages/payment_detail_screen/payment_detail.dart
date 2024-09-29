import 'package:demo/presentation/pages/add_expense_screen/add_expense.dart';
import 'package:demo/presentation/widgets/detail_screen/paid_by_string.dart';
import 'package:demo/presentation/widgets/payment_detail.dart/payment_methode.dart';
import 'package:flutter/material.dart';
import 'package:demo/model/expense_model.dart';
import 'package:demo/model/user_model.dart';

class PaymentDetail extends StatelessWidget {
  PaymentDetail(
      {super.key, required this.expenseModel, required this.userModel});
  final UserModel userModel;
  final ExpenseModel expenseModel;

  @override
  Widget build(BuildContext context) {
    print(expenseModel.paid);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        backgroundColor: Colors.green.shade400,
        actions: [
          TextButton.icon(
              icon: Icon(
                Icons.edit,
                color: Colors.white,
              ),
              onPressed: () {
                if (expenseModel.paid == 2) {
                  expenseModel.amount *= 2;
                }
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddExpense(
                    usermodel: userModel,
                    expenseModel: expenseModel,
                  ),
                ));
              },
              label: Text(
                'Edit',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ))
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              // bottom: 10,
              child: Container(
                color: Colors.green.shade400,
                height: 230,
                child: Center(
                  child: Text(
                    'Payment Summary',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            // Main content section
            Container(
              margin: const EdgeInsets.only(
                  top: 150, left: 20, right: 20, bottom: 100),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _textForPaymentPage('Description',
                      fontWeight: FontWeight.w500),
                  _textForPaymentPage('${expenseModel.description}'),
                  Divider(),
                  const SizedBox(height: 15),
                  _textForPaymentPage('Amount', fontWeight: FontWeight.w500),
                  _textForPaymentPage('\$${expenseModel.amount}'),
                  Divider(),
                  const SizedBox(height: 15),
                  _textForPaymentPage('Paid', fontWeight: FontWeight.w500),
                  _textForPaymentPage(padiByString(
                      paid: expenseModel.paid, name: '${userModel.name}')),
                  Divider(),
                  const Spacer(),
                  expenseModel.amount <= 0
                      ? Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title:
                                        Text('Are you sure you want to Pay?'),
                                    content: Text(
                                        'It will be stored in payments as paid'),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('No')),
                                      TextButton(
                                          onPressed: () async {
                                            await paymentMethod(
                                                context: context,
                                                userModel: userModel,
                                                expenseModel: expenseModel,
                                                isDecline: false);
                                          },
                                          child: Text('Yes'))
                                    ],
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 30),
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child:
                                textForElevatedButtonPaymentPage(data: 'Pay'),
                          ),
                        )
                      : SizedBox(),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title:
                                    Text('Are you sure you want to decline?'),
                                content: Text(
                                    'It will be stored in payments as declined'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('No')),
                                  TextButton(
                                      onPressed: () async {
                                        await paymentMethod(
                                            context: context,
                                            userModel: userModel,
                                            expenseModel: expenseModel,
                                            isDecline: true);
                                      },
                                      child: Text('Yes'))
                                ],
                              );
                            },
                          );
                        },
                        child: textForElevatedButtonPaymentPage(
                            data: 'Decline', color: Colors.red)),
                  ),
                  expenseModel.amount >= 0
                      ? SizedBox(
                          height: 100,
                        )
                      : const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget to display text on the Payment page
  Widget _textForPaymentPage(String data,
      {FontWeight fontWeight = FontWeight.normal}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Text(
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        data,
        style: TextStyle(
          fontSize: 22,
          color: Colors.black87,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}

Widget textForElevatedButtonPaymentPage(
    {required String data, Color color = Colors.white}) {
  bool condition = color == Colors.white;
  return Text(
    data,
    style: TextStyle(
        fontSize: condition ? 19 : 17,
        decorationThickness: 2,
        decorationColor: Colors.red,
        decoration: condition ? null : TextDecoration.underline,
        color: color),
  );
}
