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
      erroralert(context, "Error", 'Failed to pick image: $e.');
    }
    notifyListeners();
  }

  Future<int> getUserCount() async {
    final res = await usersdb.get();
    return res.size;
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
      erroralert(context, "Error", "Please Select the image.");
    } else if (await isNameExist(name)) {
      erroralert(context, "Error", "Name alredy exist, Try a diffrent name.");
    } else if (await isEmailExist(email)) {
      erroralert(context, "Error", "Email alredy exist, Try a diffrent email.");
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

  Future<void> deleteUser(
      BuildContext context, String id, String name, String imageUrl) async {
    usersdb.doc(id).delete().then((value) {
      susalert(context, "Deleted", "Successfully deleted user $name.");
    }).catchError((error) {
      erroralert(context, "Error", error.toString());
    });
    await deleteFile(context, imageUrl);
    notifyListeners();
  }

  Future<void> deleteMultiUser(BuildContext context, List users) async {
    for (int i = 0; i < users.length; i++) {
      usersdb.doc(users[i]["id"]).delete().then((value) {}).catchError((error) {
        erroralert(context, "Error", error.toString());
      });
      await deleteFile(context, users[i]["imageUrl"]);
    }
    notifyListeners();
  }

  Future<void> updateUser(BuildContext context, String id, String name,
      String email, String avatar) async {
    if (await isNameExist(name) && await isEmailExist(email)) {
      erroralert(context, "Error", "Name alredy exist, Try a diffrent name.");
    } else {
      final userdata = {"name": name, "email": email};

      if (imageFile != null && avatarDownloadUrl != null) {
        await deleteFile(context, avatar);
        await uploadAvatar(context, name);
        userdata["avatar"] = avatarDownloadUrl!;
      }

      usersdb.doc(id).update(userdata).then((value) {
        susalert(context, "Updated", "Successfully updated user $name.");
        Navigator.pop(context);
      }).catchError((error) {
        erroralert(context, "Error", error.toString());
      });
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

  Future<void> deleteFile(BuildContext context, String imageUrl) async {
    final ref = FirebaseStorage.instance.refFromURL(imageUrl);
    await ref.delete().then((value) => {}).catchError((error) {
      erroralert(context, "Error", error.toString());
    });
  }

  Future<void> deleteMultiFile(
      BuildContext context, List<String> imageUrls) async {
    for (int i = 0; i < imageUrls.length; i++) {
      final ref = FirebaseStorage.instance.refFromURL(imageUrls[i]);
      await ref.delete().then((value) => {}).catchError((error) {
        erroralert(context, "Error", error.toString());
      });
    }
  }

  Future<bool> isEmailExist(String email) async {
    return await usersdb
        .where("email", isEqualTo: email)
        .get()
        .then((value) => value.size > 0 ? true : false);
  }

  Future<bool> isNameExist(String name) async {
    return await usersdb
        .where("name", isEqualTo: name)
        .get()
        .then((value) => value.size > 0 ? true : false);
  }
}

//get live user data
final usersStream = StreamProvider(
  (ref) => FirebaseFirestore.instance.collection('user').snapshots(),
);
