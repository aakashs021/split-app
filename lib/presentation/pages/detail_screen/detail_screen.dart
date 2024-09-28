import 'package:demo/presentation/widgets/detail_screen/detail_page_appbar_bottom.dart';
import 'package:demo/presentation/widgets/detail_screen/detail_page_stream_builder.dart';
import 'package:flutter/material.dart';
import 'package:demo/model/user_model.dart';
import 'package:demo/presentation/widgets/detail_screen/floating_add_expense.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.user});
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade200,
        title: Column(
          children: [
            Text(user.name, style: const TextStyle(color: Colors.white)),
          ],
        ),
        bottom: detail_page_appbar_bottom(user: user),
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              color: Colors.blue.shade200,
            ),
          ),
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(40)),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Shrink-wrap the children
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Wrap the child widgets with ConstrainedBox to give height constraints
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: 0,
                            maxHeight: MediaQuery.of(context).size.height -
                                100, // Set appropriate max height
                          ),
                          child: detailPageStreamBuilder(usermodel: user),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: floatingAddExpense(usermodel: user),
    );
  }
}
