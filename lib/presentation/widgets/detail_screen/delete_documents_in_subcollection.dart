import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/model/user_model.dart';
import 'package:demo/presentation/controllers/login_page/new_user_login_controller.dart';
import 'package:demo/presentation/pages/add_expense_screen/add_expense.dart';

Future<void> deleteDocumentsInSubcollection({
  required String parentDocId,
  required String subcollectionName,
  required UserModel userModel,
}) async {
  // Fetch documents from the subcollection
  QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
      .collection('expense')
      .doc(parentDocId)
      .collection(subcollectionName)
      .get();

  List<Map> paymentListForUser = [];
  List<Map> paymentListForOtherUser = [];

  // Iterate over each document in the subcollection
  for (var doc in snapshot.docs) {
    // Create payment details for the current user
    Map paymentDetailForUser = {
      'amount': doc['amount'],
      'paid': doc['paid'],
      'des': doc['des'],
      'date': int.parse(doc.id),
      'email': subcollectionName,
      'status': true,
      'by': parentDocId,
    };

    // Determine the payment status and amount for the other user
    int paidStatus;
    if (doc['paid'] == 0) {
      paidStatus = 1;
    } else if (doc['paid'] == 1) {
      paidStatus = 0;
    } else {
      paidStatus = 2;
    }

    num adjustedAmount =
        doc['amount'] * -1; // Set the amount to negative for the other user

    // Create payment details for the other user
    Map paymentDetailForOtherUser = {
      'amount': adjustedAmount,
      'paid': paidStatus,
      'des': doc['des'],
      'date': int.parse(doc.id),
      'email': parentDocId, // Use the correct email for the other user
      'status': true,
      'by': subcollectionName, // Use the correct user for the other user
    };

    // Add details to their respective lists
    paymentListForUser.add(paymentDetailForUser);
    paymentListForOtherUser.add(paymentDetailForOtherUser);
  }

  String currentDate = DateTime.now().microsecondsSinceEpoch.toString();

  // Update payment records for the current user
  if (paymentListForUser.isNotEmpty) {
    await firestore.collection('payment').doc(parentDocId).set({
      currentDate: FieldValue.arrayUnion(paymentListForUser),
    }, SetOptions(merge: true));
  }

  // Update payment records for the other user
  if (paymentListForOtherUser.isNotEmpty) {
    await firestore.collection('payment').doc(subcollectionName).set({
      currentDate: FieldValue.arrayUnion(paymentListForOtherUser),
    }, SetOptions(merge: true));
  }

  // Reference to the subcollection
  CollectionReference subcollectionRef1 = FirebaseFirestore.instance
      .collection('expense')
      .doc(parentDocId)
      .collection(subcollectionName);

  // Fetch all documents in the subcollection
  QuerySnapshot querySnapshot1 = await subcollectionRef1.get();

  // Check if there are documents to delete
  if (querySnapshot1.docs.isNotEmpty) {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    // Loop through all documents and delete them
    for (QueryDocumentSnapshot doc in querySnapshot1.docs) {
      batch.delete(doc.reference); // Prepare the deletion in the batch
    }

    // Commit the batch write to delete all documents
    await batch.commit();

    // Reset the total value to 0 after deletion for both users
    await firestore
        .collection('total')
        .doc(parentDocId)
        .collection(subcollectionName)
        .doc('total')
        .set({'total': 0});

    // Also delete the total for the other user
    // await firestore
    //     .collection('total')
    //     .doc(userModel.email) // Use the correct user ID for the other user
    //     .collection(subcollectionName)
    //     .doc('total')
    //     .set({'total': 0});

    print(
        'All documents in $subcollectionName have been deleted successfully.');
  }
  CollectionReference subcollectionRef2 = FirebaseFirestore.instance
      .collection('expense')
      .doc(subcollectionName)
      .collection(parentDocId);

  // Fetch all documents in the subcollection
  QuerySnapshot querySnapshot2 = await subcollectionRef2.get();

  // Check if there are documents to delete
  if (querySnapshot2.docs.isNotEmpty) {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    // Loop through all documents and delete them
    for (QueryDocumentSnapshot doc in querySnapshot2.docs) {
      batch.delete(doc.reference); // Prepare the deletion in the batch
    }

    // Commit the batch write to delete all documents
    await batch.commit();

    // Reset the total value to 0 after deletion for both users
    // await firestore
    //     .collection('total')
    //     .doc(parentDocId)
    //     .collection(subcollectionName)
    //     .doc('total')
    //     .set({'total': 0});

    // Also delete the total for the other user
    await firestore
        .collection('total')
        .doc(subcollectionName) // Use the correct user ID for the other user
        .collection(parentDocId)
        .doc('total')
        .set({'total': 0});

    print(
        'All documents in $subcollectionName have been deleted successfully.');
  } else {
    print('No documents found in the subcollection.');
  }
}
