import 'package:demo/model/user_model.dart';
import 'package:demo/presentation/controllers/detail_screen/detail_total_controller_getx.dart';
import 'package:demo/presentation/pages/add_expense_screen/add_expense.dart';
import 'package:demo/presentation/widgets/detail_screen/delete_documents_in_subcollection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

PreferredSize detail_page_appbar_bottom(
    {required UserModel user, required BuildContext context}) {
  return PreferredSize(
      preferredSize: const Size(double.infinity, 80),
      child: Column(
        children: [
          Text(user.email),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: ()async {
            var controller=  Get.put(DetailTotalControllerGetx());
        num total =    await controller.getTotal(useremail: useremail, secondUserEmail: user.email);
              
              String imagePath = total == 0
                  ? 'assets/lottie/no_bill.json'
                  : 'assets/lottie/settle_success.json';
              String contendText = total == 0
                  ? 'There is no bill to settle!'
                  : 'Are you sure you want to settle up all? This action cannot be undone.';
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    // contentPadding: EdgeInsets.symmetric(horizontal: 50),
                    titlePadding: EdgeInsets.symmetric(vertical: 10),
                    titleTextStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                        color: Colors.black),
                    actionsAlignment: MainAxisAlignment.spaceAround,
                    title: Column(
                      children: [
                        Lottie.asset(height: 170, imagePath),
                        total == 0
                            ? SizedBox()
                            : Text('You are about to settle all the amount'),
                        SizedBox(
                          height: 10,
                        ),
                        total == 0
                            ? SizedBox()
                            : settleAmountTextWidget(total: total)
                      ],
                    ),
                    content: Text(
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey.shade500),
                        contendText),
                    actions: total == 0
                        ? [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Ok',
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 16),
                                )),
                          ]
                        : [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'No',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 16),
                                )),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    fixedSize: Size.fromWidth(100),
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.green.shade300),
                                onPressed: () async {
                                  await deleteDocumentsInSubcollection(
                                      parentDocId: useremail,
                                      subcollectionName: user.email,
                                      userModel: user);
                                  Navigator.pop(context);
                                },
                                child: Text('Settle')),
                          ],
                  );
                },
              );

              // await deleteDocumentsInSubcollection(parentDocId: user.email,subcollectionName: useremail,userModel: user);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Colors.green.shade300, // Accent color for the button
              elevation: 0,
            ),
            child: const Text('Settle', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ));
}

Widget settleAmountTextWidget({required num total}) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text('total: '),
      Text(
        '\$$total',
        style: TextStyle(
          color: total < 0 ? Colors.red : Colors.green,
        ),
      ),
    ],
  );
}
