import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/model/user_model.dart';
import 'package:demo/presentation/controllers/detail_screen/detail_total_controller_getx.dart';
import 'package:demo/presentation/pages/add_expense_screen/add_expense.dart';
import 'package:demo/presentation/pages/detail_screen/detail_screen.dart';
import 'package:demo/presentation/widgets/detail_screen/amount_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.red, // Background color for delete action
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      alignment: Alignment.centerLeft,
      child: const Padding(
        padding: EdgeInsets.all(12.0), // Inner padding
        child: Icon(Icons.delete, color: Colors.white, size: 30), // Delete icon
      ),
    ),
    secondaryBackground: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.red, // Background color for delete action
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      alignment: Alignment.centerRight,
      child: const Padding(
        padding: EdgeInsets.all(12.0), // Inner padding
        child: Icon(Icons.delete, color: Colors.white, size: 30), // Delete icon
      ),
    ),
    key: ValueKey<int>(index),
    confirmDismiss: (direction) async {
      // Show confirmation dialog
      return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Rounded corners
            ),
            backgroundColor: Colors.white, // Background color
            title: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Are you sure you want to delete?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10), // Spacing
                const Text(
                  'This action cannot be undone and the amount details will not be deleted.',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog without deleting
                },
                child: const Text(
                  'No',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size.fromWidth(100),
                  foregroundColor: Colors.white,
                  backgroundColor:
                      Colors.red, // Change to red for delete action
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                ),
                onPressed: () async {
                  // Remove the friend's email from the list in Firebase
                  await FirebaseFirestore.instance
                      .collection('friends') // Specify the collection
                      .doc(useremail) // The user's document ID
                      .update({
                    'friendList': FieldValue.arrayRemove(
                        [userDetail.email]) // The field that contains the list
                  });

                  Navigator.pop(context); // Close the dialog
                  // Optionally show a snackbar or a message indicating success
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User deleted successfully')),
                  );
                },
                child:
                    const Text('Delete'), // Changed from "Settle" to "Delete"
              ),
            ],
          );
        },
      );
    },
    child: Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: () {
          if (Get.isRegistered<DetailTotalControllerGetx>()) {
            Get.delete<DetailTotalControllerGetx>();
            print("Controller deleted on Home Page");
          } else {
            print('nothing');
          }

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
              stream: FirebaseFirestore.instance
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
