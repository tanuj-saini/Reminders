import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:reminder/Home/condition.dart';

import 'package:reminder/ListScreen/ListScreen.dart';
import 'package:reminder/User/authContoller.dart';
import 'package:reminder/User/authRepositry.dart';
import 'package:reminder/map/map.dart';
import 'package:reminder/utils/Loder.dart';
import 'package:reminder/utils/Pallate.dart';

import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final String currLati;
  final String currLogi;
  final dynamic cuuAddress;
  HomeScreen(
      {required this.cuuAddress,
      required this.currLati,
      required this.currLogi,
      super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _HomeScreen();
  }
}

class _HomeScreen extends ConsumerState<HomeScreen> {
  // String reminderUid = Uuid().v1();
  Future<void> checkLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      // Location permission granted.
    } else if (status.isDenied) {
      // Location permission denied.
    } else if (status.isPermanentlyDenied) {
      // Location permission permanently denied, take the user to settings.
      openAppSettings();
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    super.initState();
    checkLocationPermission();
    updateLiveLocation();
  }

  final TextEditingController titleContoller = TextEditingController();
  final TextEditingController ReminderContoller = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void logOut() {
    ref.watch(authContoller.notifier).signOut(context);
  }

  void updateLiveLocation() async {
    final geolocator = Geolocator();

    Geolocator.getPositionStream().listen((position) {
      ref.watch(authContoller.notifier).sendCuuLocationtoFirebase(
          field: FieldValue.serverTimestamp(),
          Latitude: position.latitude.toString(),
          Longitude: position.longitude.toString());
    });

  }

  void sendReminderToFirebase(
      {required String title,
      required String ReminderText,
      required String Latitude,
      required BuildContext context,
      required String Longitude}) async {
    ref.watch(authContoller.notifier).sendReminder(
        context: context,
        title: title,
        ReminderText: ReminderText,
        Latitude: Latitude,
        Longitude: Longitude);
  }

  double Lati = 900;
  double Longi = 000;
  Future<void> getAddressCoordinates(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        Location location = locations[0];
        double latitude = location.latitude;
        double longitude = location.longitude;
        Lati = latitude;
        Longi = longitude;

        print('Latitude: $latitude, Longitude: $longitude');
       
      } else {
        print('No matching locations found for the address.');
        showSnackBar('No matching locations found for the address.', context);
      }
    } catch (e) {
      print('Error: $e');
      showSnackBar('Error: $e', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoding = ref.watch(authContoller);

    final dynamic add = widget.cuuAddress;
    final TextEditingController addressContoller =
        TextEditingController(text: add.isNotEmpty ? "$add" : "");
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello"),
      ),
      drawer: Drawer(
          child: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          ListTile(
            title: Center(
                child: Text(
              "List Of Reminders",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            )),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (ctx) => ListScreen()));
            },
          ),
          SizedBox(
            height: 20,
          ),
          TextButton.icon(
              onPressed: () => logOut(),
              icon: Icon(Icons.logout),
              label: Text("Log Out")),
          SizedBox(
            height: 20,
          ),
        ],
      )),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: addressContoller,
                  decoration: InputDecoration(
                    hintText: "Notification Location",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50)),
                    prefixIcon: IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (ctx) => MapScreen()));
                        },
                        icon: Icon(Icons.location_on_outlined)),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: titleContoller,
                  decoration: InputDecoration(
                    hintText: "Title",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50)),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: ReminderContoller,
                  decoration: InputDecoration(
                    hintText: "Which thing to Remind",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50)),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 50,
                ),
                ElevatedButton.icon(
                    onPressed: () async {
                      await getAddressCoordinates(addressContoller.text);

                      Future.delayed(Duration(seconds: 4));
                      sendReminderToFirebase(
                          context: context,
                          title: titleContoller.text,
                          ReminderText: ReminderContoller.text,
                          Latitude: Lati.toString(),
                          Longitude: Longi.toString());

                      Future.delayed(Duration(seconds: 4));
                      updateLiveLocation();
                      Future.delayed(Duration(seconds: 4));
                      await Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => Condition(
                            latitude: Lati,
                            longitude: Longi,
                            title: titleContoller.text,
                            body: ReminderContoller.text),
                      ));
                    },
                    icon: Icon(Icons.save),
                    label: Text("Set Notification")),
              ], //List
            ),
          ),
        ),
      ),
    );
  }
}
