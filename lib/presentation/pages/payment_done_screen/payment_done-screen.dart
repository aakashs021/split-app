import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/presentation/controllers/login_page/new_user_login_controller.dart';
import 'package:demo/presentation/pages/add_expense_screen/add_expense.dart';
import 'package:flutter/material.dart';

class PaymentDoneScreen extends StatelessWidget {
  const PaymentDoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payments'),
      ),
      body: SafeArea(child: paymentDoneStreamBuilder1()),
    );
  }
}

Widget paymentDoneStreamBuilder1() {
  return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
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

      var data = snapshot.data!.data()! as Map<String, dynamic>;

      // Group payments by date
      Map<String, List<Map<String, dynamic>>> groupedPayments = {};
      data.forEach((dateStr, payments) {
        // Convert the date string (microseconds) to DateTime
        int microseconds = int.parse(dateStr);
        DateTime dateTime = DateTime.fromMicrosecondsSinceEpoch(microseconds);
        String formattedDate =
            '${dateTime.day}/${dateTime.month}/${dateTime.year}';

        // If the date is not already in the map, add it
        if (!groupedPayments.containsKey(formattedDate)) {
          groupedPayments[formattedDate] = [];
        }

        // Add payments to the respective date
        groupedPayments[formattedDate]!
            .addAll(List<Map<String, dynamic>>.from(payments));
      });

      List<String> dates = groupedPayments.keys.toList();

      return ListView.builder(
        itemCount: dates.length,
        itemBuilder: (context, index) {
          String date = dates[index];
          List<Map<String, dynamic>> payments = groupedPayments[date]!;

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
                itemBuilder: (context, paymentIndex) {
                  var payment = payments[paymentIndex];

                  return ListTile(
                    leading: paymentDoneStreamListTileCircleWidget(
                        status: payment['status']),
                    title: paymentDoneStreamListTileTitleWidget(
                        email: payment['email']),
                    subtitle: Text(
                        'Description: ${payment['des'] ?? 'No description'}'),
                    trailing: Text(
                      '\$${payment['amount']}',
                      style: TextStyle(fontSize: 20),
                    ),
                  );
                },
              ),
            ],
          );
        },
      );
    },
  );
}

Widget paymentDoneStreamListTileCircleWidget({required bool status}) {
  return CircleAvatar(
    backgroundColor: status ? Colors.green : Colors.red,
    foregroundColor: Colors.white,
    child: Icon(status ? Icons.done : Icons.close),
  );
}

Widget paymentDoneStreamListTileTitleWidget({required String email}) {
  return FutureBuilder(
    future: firestore.collection('users').doc(email).get(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Text('');
      }
      if (snapshot.hasError) {
        return Text('Unknown');
      }
      var data = snapshot.data?.data();
      if (!snapshot.hasData || data == null) {
        return Text('Unknown');
      }
      return ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 100), // Set max width
        child: Text(
          data['name'],
          overflow: TextOverflow.ellipsis, // Handle overflow
          maxLines: 1, // Limit to one line
        ),
      );
    },
  );
}
