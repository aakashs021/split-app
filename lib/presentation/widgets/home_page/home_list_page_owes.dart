import 'package:demo/model/user_model.dart';
import 'package:demo/presentation/controllers/login_page/new_user_login_controller.dart';
import 'package:demo/presentation/pages/add_expense_screen/add_expense.dart';
import 'package:demo/presentation/pages/detail_screen/detail_screen.dart';
import 'package:demo/presentation/widgets/detail_screen/amount_text.dart';
import 'package:flutter/material.dart';

Widget homePageListOwes({
  required userSnapshot,
  required int index,
  required BuildContext context,
}) {
  var userData = userSnapshot.data?.data();

  if (userData == null) {
    return const ListTile(
      title: Text('User not found'),
    );
  }

  UserModel userDetail = UserModel(
    name: userData['name'] ?? 'Unknown',
    email: userData['email'] ?? 'Unknown',
    phone: userData['phone'] ?? 'Unknown',
  );

  // List of light colors for CircleAvatar background
  List<Color> avatarColors = [
    Colors.red.shade100,
    Colors.blue.shade100,
    Colors.green.shade100,
    Colors.orange.shade100,
    Colors.purple.shade100,
    Colors.yellow.shade100,
    Colors.teal.shade100,
    Colors.brown.shade100,
  ];

  // Function to get color based on user name
  Color getAvatarColor(String name) {
    int colorIndex = name.hashCode % avatarColors.length;
    return avatarColors[
        colorIndex < 0 ? -colorIndex : colorIndex]; // Ensure positive index
  }

  return Dismissible(
    background: Container(
      color: Colors.red,
      child: const Icon(Icons.delete),
    ),
    key: ValueKey<int>(index),
    onDismissed: (direction) {
      // Handle the dismissal
    },
    child: Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DetailScreen(
              user: userDetail,
            ),
          ));
        },
        leading: CircleAvatar(
          backgroundColor: getAvatarColor(
              userDetail.name), // Set the avatar background color
          child: Text(
            userDetail.name[0].toUpperCase(),
            style: const TextStyle(
                color:
                    Colors.black), // Set the text color to black for visibility
          ),
        ),
        title: Text(
          userDetail.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(userDetail.email),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 5),
            StreamBuilder(
              stream: firestore
                  .collection('total')
                  .doc(useremail)
                  .collection(userDetail.email)
                  .doc('total')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('0');
                } else if (snapshot.hasError) {
                  return const Text('0');
                }

                var total = snapshot.data?.data();
                num data = total == null ? 0 : total['total'];
                return amountText(
                    data: data.toString(), amount: data, isPage: '');
              },
            ),
          ],
        ),
      ),
    ),
  );
}