import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';



class GroupScreen extends StatelessWidget {
  const GroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Column(
        children: [
          ElevatedButton(onPressed: (){
          realtime_databse_get();
          }, child: Text('show')), 
          ElevatedButton(onPressed: (){
          realtime_database_add();
          }, child: Text('add')),
        ],
      ),),

    );
  }
}
final databaseReference = FirebaseDatabase.instance.ref();

realtime_databse_get(){
  databaseReference.child('users').child('user2').onValue.listen((event) {
      Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
        print(data); // Print the entire data structure
  },);
}

realtime_database_add(){
  databaseReference.child('users').child('user2').set({
  'name': 'Alice',
  'age': 30,
});

}

