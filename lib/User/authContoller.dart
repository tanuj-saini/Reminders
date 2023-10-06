import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:reminder/CurrLocation/currLocation.dart';
import 'package:reminder/Home/HomeScreen.dart';
import 'package:reminder/Home/userReminderModel.dart';
import 'package:reminder/User/LoginScreen.dart';
import 'package:reminder/User/UserModel.dart';
import 'package:reminder/User/UserModelSign.dart';
import 'package:reminder/User/authRepositry.dart';
import 'package:reminder/main.dart';
import 'package:reminder/utils/Pallate.dart';
import 'package:uuid/uuid.dart';

final authContoller = StateNotifierProvider<AuthContoller, bool>((ref) {
  final auth = ref.watch(authRepositry);
  return AuthContoller(authRepositry: auth, ref: ref);
});

final USerDetailsFormain = FutureProvider((ref) {
  final authRepo = ref.watch(authRepositry);
  return authRepo.getUserDetails();
});

class AuthContoller extends StateNotifier<bool> {
  final AuthRepositry authRepositry;
  final Ref ref;

  AuthContoller({required this.authRepositry, required this.ref})
      : super(false);

  void sendLogin(
      {required String password,
      required String email,
      required BuildContext context}) async {
    state = true;
    UserModel userModelSign = UserModel(password: password, email: email);
    authRepositry.sendLoginToFirebase(
        userModel: userModelSign, password: password, context: context);

    state = false;
  }

  Stream<UserReminderModel> getDeletedReminder(
      {required BuildContext context, required String reminderUId}) {
    return authRepositry.deleteReminderCollection(
        reminderUId: reminderUId, context: context);
  }

  void sendCuuLocationtoFirebase(
      {required String Latitude,
      required String Longitude,
      required field}) async {
    state = true;
    String locationUid = Uuid().v1();
    LocationModel locationModel = LocationModel(
        LocationUid: locationUid,
        Latitude: Latitude,
        Longitude: Longitude,
        createdAt: field);
    authRepositry.updateLiveLocation(locationModel: locationModel);
    state = false;
  }

  void signOut(BuildContext context) async {
    authRepositry.logOutUser(context);
  }

  Stream<List<UserReminderModel>> getListRE() {
    return authRepositry.getListReminder(DateTimre: DateTime.now().toString());
  }

  Stream<LocationModel> getNoti() {
    return authRepositry.getListNotification();
  }

  void sendReminder({
    required String title,
    required BuildContext context,
    required String ReminderText,
    required String Latitude,
    required String Longitude,
  }) async {
    try {
      state = true;
      String remiderUId = Uuid().v1();
      UserReminderModel userReminderModel = UserReminderModel(
        reminderUid: remiderUId,
        title: title,
        ReminderText: ReminderText,
        Latitude: Latitude,
        Longitude: Longitude,
      );

      authRepositry.sendReminderToFirebase(
          userReminderModel: userReminderModel, remiderUid: remiderUId);
      showSnackBar("Set Nottification Successfully", context);
      state = false;
    } catch (e) {}
  }

  Future<UserModel?> getUserDetails() async {
    UserModel? user = await authRepositry.getUserDetails();

    return user;
  }

  void sendSign(
      {required String name,
      required String password,
      required BuildContext context,
      required String email}) async {
    state = true;

    authRepositry.sendSign(
        name: name, email: email, password: password, context: context);
    state = false;
  }
}
