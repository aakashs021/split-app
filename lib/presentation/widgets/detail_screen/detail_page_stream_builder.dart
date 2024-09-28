import 'package:demo/model/expense_model.dart';
import 'package:demo/model/user_model.dart';
import 'package:demo/presentation/controllers/login_page/new_user_login_controller.dart';
import 'package:demo/presentation/widgets/detail_screen/inner_detail_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

Widget detailPageStreamBuilder({required UserModel usermodel}) {
  String useremail = FirebaseAuth.instance.currentUser!.email!;
  return StreamBuilder(
    stream: firestore
        .collection('expense')
        .doc(useremail)
        .collection(usermodel.email)
        .snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        // Adding AnimatedSwitcher for smoother loading transitions
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: const Center(
            child: CircularProgressIndicator(), // Loading indicator
          ),
        );
      }
      if (snapshot.hasError) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: const Center(
            child: Text(
              'Snapshot has error',
              style: TextStyle(color: Colors.red),
            ),
          ),
        );
      }

      var entireExpense = snapshot.data?.docs ?? [];
      List<ExpenseModel> expenseList = [];

      // Group the expenses by date
      Map<String, List<ExpenseModel>> groupedUserModelList = {};
      for (var d in entireExpense) {
        Map<String, dynamic> expensemap = d.data();
        DateTime dateTime = DateTime.fromMicrosecondsSinceEpoch(
            int.parse(d.id)); // Your ID is in microseconds
        ExpenseModel expenseModel = ExpenseModel(
          description: expensemap['des'],
          paid: expensemap['paid'],
          amount: expensemap['amount'],
          dateTime: dateTime,
        );
        expenseList.add(expenseModel);

        String datetimeString =
            "${dateTime.day}/${dateTime.month}/${dateTime.year}";
        if (groupedUserModelList.containsKey(datetimeString)) {
          groupedUserModelList[datetimeString]!.add(expenseModel);
        } else {
          groupedUserModelList[datetimeString] = [expenseModel];
        }
      }

      // Sort dates in descending order based on dateTime
      List<String> sortedDates = groupedUserModelList.keys.toList()
        ..sort((a, b) {
          // Parse the date string in "day/month/year" format
          List<String> dateAParts = a.split('/');
          DateTime dateA = DateTime(
            int.parse(dateAParts[2]), // Year
            int.parse(dateAParts[1]), // Month
            int.parse(dateAParts[0]), // Day
          );

          List<String> dateBParts = b.split('/');
          DateTime dateB = DateTime(
            int.parse(dateBParts[2]), // Year
            int.parse(dateBParts[1]), // Month
            int.parse(dateBParts[0]), // Day
          );

          return dateB.compareTo(dateA); // Sorts from recent to oldest
        });

      // Main ListView to display grouped expenses by date
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: expenseList.isEmpty
            ? Column(
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  Lottie.asset('assets/lottie/no_data_available.json'),
                  const SizedBox(
                    height: 50,
                  ),
                  const Text('Please click on add expense')
                ],
              )
            : Column(
                children: [
                  const SizedBox(height: 10), // Added spacing
                  const Icon(Icons.horizontal_rule_rounded, color: Colors.blue),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0), // Adjusted padding
                      child: ListView.separated(
                        separatorBuilder: (context, index) {
                          return Divider(
                            thickness: 1,
                            color: Colors.grey.shade300, // Subtle divider color
                          );
                        },
                        itemCount: sortedDates.length,
                        itemBuilder: (context, index) {
                          String date = sortedDates[index];
                          List<ExpenseModel> expensesForDate =
                              groupedUserModelList[date]!;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Display date
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  date,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              // Display expenses for each date
                              ...expensesForDate.map((expenseModel) {
                                return innerDetailingWidget(
                                    usermodel: usermodel,
                                    expenseModel: expenseModel);
                              }),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
      );
    },
  );
}
