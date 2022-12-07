import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../components/alerts.dart';

final userState = ChangeNotifierProvider<UserState>(
  (ref) => UserState(),
);

class UserState extends ChangeNotifier {
  CollectionReference usersdb = FirebaseFirestore.instance.collection('user');
  List user = [];

  //get all user data on request
  Future<void> setUsers() async {
    QuerySnapshot querySnapshot = await usersdb.get();
    user = querySnapshot.docs.map((doc) => doc.data()).toList();
    notifyListeners();
  }

  Future<void> addUser(BuildContext context, String name, String email) async {
    if (name == "") {
      erroralert(context, "Error", "Please Fill the name..");
    } else if (email == "") {
      erroralert(context, "Error", "Please Fill the email..");
    } else {
      usersdb.add({"name": name, "email": email}).then((value) {
        susalert(context, "New User", "Successfully added new user $name.");
      }).catchError((error) {
        erroralert(context, "Error", error.toString());
      });
    }

    notifyListeners();
  }

  Future<void> deleteUser(BuildContext context, String id, String name) async {
    usersdb.doc(id).delete().then((value) {
      susalert(context, "Deleted", "Successfully deleted user $name.");
    }).catchError((error) {
      erroralert(context, "Error", error.toString());
    });
    notifyListeners();
  }

  Future<DocumentSnapshot> getUserById(BuildContext context, String id) async {
    final userdata = await usersdb.doc(id).get();
    return userdata;
  }
}

//get live user data
final usersStream = StreamProvider(
  (ref) => FirebaseFirestore.instance.collection('user').snapshots(),
);
