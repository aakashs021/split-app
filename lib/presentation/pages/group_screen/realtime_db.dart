import 'package:firebase_database/firebase_database.dart';

class RealtimeDb {
 static  final  databaseReference = FirebaseDatabase.instance.ref();
 createGroup({required String groupName}){
  databaseReference.child('group').child("123").set({
    "groupname":groupName,
    'members':{
      1:{
        'name':"aakash",
      },
      2:{
        'name':"george",
      },
      3:{
        "name": "rayan"
      },
      4:{
        "name":"fourth"
      }
    },
    'split':{
      "splitId":{
        "paid":4,
        "description":"cafe",
      'total':100,
        "status":{
           1:{
        "amount":40,
        "status": false,
      },
      2:{
        "a,mount":30,
                "status": true,

      },
      3:{
        "amount":40,
                "status": false,

      }
        }
      },
     
    }

  });

 }

}
