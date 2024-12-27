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
          realtimedatabseget();
          }, child: Text('show')), 
          ElevatedButton(onPressed: (){
          realtimedatabaseadd();
          }, child: Text('add')),
        ],
      ),),
      floatingActionButton: FloatingActionButton(onPressed: (){},
      child: Icon(Icons.group_add_outlined),
      ),

    );
  }
}
final databaseReference = FirebaseDatabase.instance.ref();

realtimedatabseget(){
  databaseReference.child('users').child('user2').onValue.listen((event) {
      Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
        print(data); // Print the entire data structure
  },);
}

realtimedatabaseadd(){
  databaseReference.child('users').child('user2').set({
  'name': 'Alice',
  'age': 30,
});

}

