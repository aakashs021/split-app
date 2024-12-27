import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo/presentation/controllers/add_people/search_list_getx.dart';
import 'package:demo/presentation/widgets/add_people/loading_state_peoplelist.dart';
import 'package:demo/model/user_model.dart';
import 'package:demo/presentation/controllers/login_page/new_user_login_controller.dart';
import 'package:demo/presentation/widgets/add_people/no_user_found_peoplelist.dart';
import 'package:lottie/lottie.dart';

Widget userFoundPeoplelist(
    {required AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot}) {
  final searchController = Get.find<SearchListGetx>();

  List<QueryDocumentSnapshot> users = snapshot.data!.docs;
  List<UserModel> usermodellist = [];

  for (QueryDocumentSnapshot d in users) {
    if (d['email'] == FirebaseAuth.instance.currentUser!.email) {
      continue;
    }
    UserModel userModel =
        UserModel(name: d['name'], email: d['email'], phone: d['phone']);
    usermodellist.add(userModel);
  }
  searchController.oninit(searchlist: usermodellist);

  return FutureBuilder(
    future: firestore
        .collection('friends')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .get(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Text('Loading');
      }
      if (snapshot.hasError) {
        return const Text('error');
      }

      Map<String, dynamic>? friendslist = snapshot.data?.data();
      Map<String, dynamic> friends = friendslist ?? {};
      List f = friends['email'];
      searchController.ifFreind(friends: f);

      return GetBuilder<SearchListGetx>(
        builder: (searchController) {
          if (searchController.controller.text.isEmpty ||
              searchController.controller.text == "") {
            Future<void> loadLottie() async {
              // Simulating a delay in loading the Lottie file
              await Future.delayed(
                  Duration(seconds: 0)); // Adjust this as needed
            }

            return FutureBuilder(
              future: loadLottie(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return loadingStatePeopleList();
                } else {
                  return Column(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Text('Please search the users'),
                      Lottie.asset("assets/lottie/search_users.json"),
                    ],
                  );
                }
              },
            );
          }
          return searchController.filterlist.isEmpty
              ? noUserFoundPeopleList()
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: searchController.filterlist.length,
                  itemBuilder: (context, index) {
                    return addFreind(
                        searchController: searchController, index: index);
                  },
                );
        },
      );
    },
  );
}

Widget addFreind(
    {required SearchListGetx searchController, required int index}) {
  return Card(
    color: freindColor(freind: searchController.filterlist[index].friend),
    child: ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.red.shade100,
        child: Text('A'),
      ),
      subtitle: Text(searchController.filterlist[index].email),
      title: Text(searchController.filterlist[index].name),
      trailing: Container(
          width: 50,
          height: 45,
          decoration: BoxDecoration(
              color: friendIconBGColor(
                  f: searchController.filterlist[index].friend),
              border: Border.all(
                  color: friendBorderColor(
                      f: searchController.filterlist[index].friend)),
              borderRadius: BorderRadius.circular(10)),
          child: friendIcon(f: searchController.filterlist[index].friend)
          // freindText(f: searchController.filterlist[index].friend),
          ),
      onTap: () {
        searchController.onCircleAvatartap(index: index);
      },
    ),
  );
}

Widget freindText({required bool? f}) {
  return Center(
      child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      // Text(freindTextString(f: f)),
      Icon(
        color: Colors.blue,
        Icons.person_add,
        size: 25,
      )
    ],
  ));
}

Widget friendIcon({required bool? f}) {
  if (f == null) {
    return Icon(
      color: Colors.white,
      Icons.people,
      size: 25,
    );
  }
  if (!f) {
    return Icon(
      color: Colors.green,
      Icons.person_add_alt_1_outlined,
      size: 30,
    );
  }
  return Icon(
    color: Colors.blue,
    Icons.people,
    size: 25,
  );
}

Color friendBorderColor({required bool? f}) {
  if (f == null || f) {
    return Colors.blue;
  }
  return Colors.green;
}

Color friendIconBGColor({
  required bool? f,
}) {
  if (f == null || f) {
    return Colors.blue;
  }
  return Colors.white;
}

Color freindColor({required bool? freind}) {
  // if (freind == null) {
  //   return Colors.green;
  // } else if (freind) {
  //   return Colors.blue;
  // }
  return Colors.white;
}
