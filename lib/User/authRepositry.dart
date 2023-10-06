import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:location/location.dart' as loc;
import 'package:reminder/CurrLocation/currLocation.dart';
import 'package:reminder/Home/HomeScreen.dart';
import 'package:reminder/Home/userReminderModel.dart';
import 'package:reminder/User/LoginScreen.dart';
import 'package:reminder/User/UserModel.dart';
import 'package:reminder/User/UserModelSign.dart';
import 'package:reminder/utils/Pallate.dart';
import 'package:uuid/uuid.dart';

final authRepositry = Provider((ref) => AuthRepositry(
    firebaseAuth: FirebaseAuth.instance,
    firebaseFirestore: FirebaseFirestore.instance));

class AuthRepositry {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;

  AuthRepositry({required this.firebaseAuth, required this.firebaseFirestore});

  void sendLoginToFirebase(
      {required UserModel userModel,
      required String password,
      required BuildContext context}) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: userModel.email, password: password);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => HomeScreen(
                currLati: "",
                currLogi: "",
                cuuAddress: "",
              )));
    } on FirebaseAuthException catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  void sendUserCollectionm({required UserModelSign userModelSign}) async {
    await firebaseFirestore
        .collection("users")
        .doc(userModelSign.userUid)
        .set(userModelSign.toMap());
  }

  Future<UserModel?> getUserDetails() async {
    var userData = await firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser?.uid)
        .get();
    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }

    return user;
  }

  void logOutUser(BuildContext context) async {
    await firebaseAuth.signOut();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => LoginScreen()));
  }

  void sendReminderToFirebase(
      {required UserReminderModel userReminderModel,
      required String remiderUid}) async {
    await firebaseFirestore
        .collection("users")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("reminders")
        .doc(remiderUid)
        .set(userReminderModel.toMap());
  }

  void updateLiveLocation({
    required LocationModel locationModel,
  }) async {
    await firebaseFirestore
        .collection("location")
        .doc(firebaseAuth.currentUser!.uid)
        .set(locationModel.toMap());
    // Use Geolocator to get the current location.
  }

  Stream<List<UserReminderModel>> getListReminder({required String DateTimre}) {
    return firebaseFirestore
        .collection("users")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("reminders")
        .snapshots()
        .map((event) {
      final List<UserReminderModel> listREminder = [];
      for (var document in event.docs) {
        listREminder.add(UserReminderModel.fromMap(document.data()));
      }
      return listREminder;
    });
  }

  Stream<UserReminderModel> deleteReminderCollection(
      {required String reminderUId, required BuildContext context}) {
    firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .collection("reminders")
        .doc(reminderUId)
        .delete();
    return showSnackBar("Successfully Deleted", context);
  }

  Stream<LocationModel> getListNotification() {
    return firebaseFirestore
        .collection("location")
        .doc(firebaseAuth.currentUser!.uid)
        .snapshots()
        .map((event) => LocationModel.fromMap(event.data()!));
  }

  void sendSign(
      {required String email,
      required String name,
      required String password,
      required BuildContext context}) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => HomeScreen(
                currLati: "",
                currLogi: "",
                cuuAddress: "",
              )));
      UserModelSign userModelSign = UserModelSign(
          name: name, userUid: firebaseAuth.currentUser!.uid, email: email);
      sendUserCollectionm(userModelSign: userModelSign);
    } on FirebaseException catch (e) {
      showSnackBar(e.toString(), context);
    }
  }
}
