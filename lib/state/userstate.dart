// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import '../components/alerts.dart';

final userState = ChangeNotifierProvider.autoDispose<UserState>(
  (ref) => UserState(),
);

class UserState extends ChangeNotifier {
  CollectionReference usersdb = FirebaseFirestore.instance.collection('user');
  List user = [];

  File? imageFile;
  String? avatarDownloadUrl;
  Future pickImage(BuildContext context) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);

      imageFile = imageTemp;
    } on PlatformException catch (e) {
      erroralert(context, "Error", 'Failed to pick image: $e');
    }
    notifyListeners();
  }

  //get all user data on request
  Future<void> setUsers() async {
    QuerySnapshot querySnapshot = await usersdb.get();
    user = querySnapshot.docs.map((doc) => doc.data()).toList();
    notifyListeners();
  }

//add new user data
  Future<void> addUser(BuildContext context, String name, String email) async {
    if (imageFile == null) {
      erroralert(context, "Error", "Please Select the image");
    } else if (name == "") {
      erroralert(context, "Error", "Please Fill the name..");
    } else if (email == "") {
      erroralert(context, "Error", "Please Fill the email..");
    } else {
      await uploadAvatar(context, name);
      usersdb.add({
        "name": name,
        "email": email,
        "avatar": avatarDownloadUrl
      }).then((value) {
        susalert(context, "New User", "Successfully added new user $name.");
        Navigator.pop(context);
      }).catchError((error) {
        erroralert(context, "Error", error.toString());
      });
    }
  }

  Future<void> deleteUser(BuildContext context, String id, String name) async {
    usersdb.doc(id).delete().then((value) {
      susalert(context, "Deleted", "Successfully deleted user $name.");
    }).catchError((error) {
      erroralert(context, "Error", error.toString());
    });
    notifyListeners();
  }

  Future<void> updateUser(
      BuildContext context, String id, String name, String email) async {
    if (name == "") {
      erroralert(context, "Error", "Please Fill the name..");
    } else if (email == "") {
      erroralert(context, "Error", "Please Fill the email..");
    } else {
      if (imageFile != null) {
        await uploadAvatar(context, name);
        usersdb.doc(id).update({
          "name": name,
          "email": email,
          "avatar": avatarDownloadUrl,
        }).then((value) {
          susalert(context, "Updated", "Successfully updated user $name.");
          Navigator.pop(context);
        }).catchError((error) {
          erroralert(context, "Error", error.toString());
        });
      } else {
        usersdb.doc(id).update({"name": name, "email": email}).then((value) {
          susalert(context, "Updated", "Successfully updated user $name.");
          Navigator.pop(context);
        }).catchError((error) {
          erroralert(context, "Error", error.toString());
        });
      }
    }
  }

  Future<DocumentSnapshot> getUserById(BuildContext context, String id) async {
    final userdata = await usersdb.doc(id).get();
    return userdata;
  }

  Future<void> uploadAvatar(BuildContext context, String name) async {
    String imagename = imageFile!.path.toString().split("/").last;
    String path = "/avatar/$name/$imagename";
    final ref = FirebaseStorage.instance.ref().child(path);
    UploadTask uploadTask = ref.putFile(imageFile!);
    final snapshot = await uploadTask.whenComplete(() => null);

    final urlDownload = await snapshot.ref.getDownloadURL();
    avatarDownloadUrl = urlDownload;
  }
}

//get live user data
final usersStream = StreamProvider(
  (ref) => FirebaseFirestore.instance.collection('user').snapshots(),
);
