import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:reminder/User/authContoller.dart';
import 'package:reminder/utils/Loder.dart';

class Condition extends ConsumerStatefulWidget {
  final double latitude;
  final double longitude;
  final String title;
  final String body;

  Condition(
      {required this.latitude,
      required this.longitude,
      required this.title,
      required this.body});

  @override
  ConsumerState<Condition> createState() => _ConditionState();
}

class _ConditionState extends ConsumerState<Condition> {
  @override
  Widget build(BuildContext context) {
    print("notification");
    bool userInRange = false;
    void triggerNotification(
        {required String text, required String reminderbody}) {
      AwesomeNotifications().createNotification(
          content: NotificationContent(
        id: 778899,
        channelKey: "778899",
        title: text,
        body: reminderbody,
      ));
    }

    return StreamBuilder(
      stream: ref.watch(authContoller.notifier).getNoti(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoderScreen();
        }
        double latii = double.parse(snapshot.data!.Latitude);
        double longii = double.parse(snapshot.data!.Longitude);
        var distanceMeter = Geolocator.distanceBetween(
            widget.latitude, widget.longitude, latii, longii);
        print(distanceMeter);
        if (distanceMeter <= 3753) {
          if (!userInRange) {
            triggerNotification(text: widget.title, reminderbody: widget.body);
            userInRange = true;
          } else {
            userInRange = false;
          }
        }
        // triggerNotification(text: widget.title, reminderbody: widget.body);
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("sucessfully"))
              ],
            ),
          ),
        );
      },
    );
  }
}
