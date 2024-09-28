import 'package:demo/model/user_model.dart';
import 'package:demo/presentation/pages/add_expense_screen/add_expense.dart';
import 'package:demo/presentation/widgets/detail_screen/delete_documents_in_subcollection.dart';
import 'package:flutter/material.dart';

PreferredSize detail_page_appbar_bottom({required UserModel user}){
  return PreferredSize(
            preferredSize: const Size(double.infinity, 80),
            child: Column(
              children: [
                Text(user.email),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () async {
                    await deleteDocumentsInSubcollection(parentDocId: useremail,subcollectionName: user.email,userModel: user);
                    // await deleteDocumentsInSubcollection(parentDocId: user.email,subcollectionName: useremail,userModel: user);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.green.shade300, // Accent color for the button
                    elevation: 0,
                  ),
                  child: const Text('Settle',
                      style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ));
}