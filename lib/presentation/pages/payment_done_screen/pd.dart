import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/presentation/pages/payment_done_screen/payment_done-screen.dart';
import 'package:flutter/material.dart';

import 'package:demo/presentation/controllers/login_page/new_user_login_controller.dart';
import 'package:demo/presentation/pages/add_expense_screen/add_expense.dart';

Widget payment_history_details() {
  return StreamBuilder(
    stream: firestore.collection('payment').doc(useremail).snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      }

      if (!snapshot.hasData || snapshot.data!.data() == null) {
        return Center(child: Text('No data available.'));
      }
      var data = snapshot.data!.data()!;
      if (data.isEmpty) {
        return Center(child: Text('No History'));
      }
      Map<String, List<PayemtHistoryModel>> groupedPayments = {};
      data.forEach(
        (key, payment) {
          int microseconds = int.parse(key);
          DateTime dateTime = DateTime.fromMicrosecondsSinceEpoch(microseconds);

          String formattedDate =
              '${dateTime.day}/${dateTime.month < 10 ? 0 : ''}${dateTime.month}/${dateTime.year}';
          if (!groupedPayments.containsKey(formattedDate)) {
            groupedPayments[formattedDate] = [];
          }
          for (var pay in payment) {
            // print(pay);
            PayemtHistoryModel payments = PayemtHistoryModel(
                id: key,
                amount: pay['amount'],
                by: pay['by'],
                date: pay['date'],
                des: pay['des'] ?? 'No description',
                email: pay['email'],
                paid: pay['paid'],
                donedate: pay['donedate'],
                status: pay['status']);

            groupedPayments[formattedDate]!.add(payments);
          }
        },
      );
      List<String> dates = groupedPayments.keys.toList();
      dates.sort((a, b) {
        DateTime dateA = DateTime.parse(a.split('/').reversed.join('-'));
        DateTime dateB = DateTime.parse(b.split('/').reversed.join('-'));
        return dateB.compareTo(dateA); // Sort descending
      });
      // print(groupedPayments.values.);
      for (var paymentList in groupedPayments.values) {
        paymentList.sort((a, b) {
          if (a.donedate == null && b.donedate == null) {
            return 0; // Both are null, considered equal
          } else if (a.donedate == null) {
            return 1; // `a` is less recent because `a.donedate` is null
          } else if (b.donedate == null) {
            return -1; // `b` is less recent because `b.donedate` is null
          } else {
            return b.donedate!
                .compareTo(a.donedate!); // Compare non-null values
          }
        });
      }
      print(0.00 == 0.000000);

      return ListView.builder(
        itemCount: dates.length,
        itemBuilder: (context, index) {
          String date = dates[index];
          List<PayemtHistoryModel> payments = groupedPayments[date]!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  date, // Display the formatted date
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: payments.length,
                itemBuilder: (context, index) {
                  PayemtHistoryModel payment = payments[index];
                  return ListTile(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Are you sure you want to delete?'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('No')),
                              TextButton(
                                  onPressed: () {
                                    print(payment.id);
                                    Navigator.pop(context);

                                    firestore
                                        .collection('payment')
                                        .doc(useremail)
                                        .update(
                                            {payment.id: FieldValue.delete()});
                                  },
                                  child: Text('Yes')),
                            ],
                          );
                        },
                      );
                    },
                    leading: paymentDoneStreamListTileCircleWidget(
                        status: payment.status),
                    title: paymentDoneStreamListTileTitleWidget(
                        email: payment.email),
                    subtitle: Text('Description: ${payment.des}'),
                    trailing: Text(
                      '\$${payment.amount}',
                      style: TextStyle(fontSize: 20),
                    ),
                  );
                },
              )
            ],
          );
        },
      );
    },
  );
}

class PayemtHistoryModel {
  String id;
  num amount;
  String by;
  int date;
  String des;
  String email;
  int paid;
  bool status;
  String? donedate;
  PayemtHistoryModel(
      {required this.id,
      required this.amount,
      required this.by,
      required this.date,
      required this.des,
      required this.email,
      required this.paid,
      required this.status,
      this.donedate});
}
