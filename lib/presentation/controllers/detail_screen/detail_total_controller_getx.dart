import 'package:get/get.dart';
import 'package:demo/presentation/controllers/login_page/new_user_login_controller.dart'; // Assuming you need this

class DetailTotalControllerGetx extends GetxController {
  num total = 0;

  Future<num> getTotal({
    required String useremail,
    required String secondUserEmail,
  }) async {
    try {
      // Fetch document snapshot
      var snapshot = await firestore
          .collection('total')
          .doc(useremail)
          .collection(secondUserEmail)
          .doc('total')
          .get();

      // Ensure data is not null before accessing fields
      if (snapshot.exists && snapshot.data() != null) {
        var totalData = snapshot.data() as Map<String, dynamic>;
        // Access the field properly
        num data = totalData['total'] ?? 0; // Use correct field name
        total = data; // Assign the fetched value to the total variable
      } else {
        total = 0; // Default value if document or data is missing
      }
      print(total);
      return total;
    } catch (e) {
      print("Error fetching total: $e");
      total = 0; // Handle error case
      return total;
    }
  }
}
