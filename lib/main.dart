import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reminder/Home/HomeScreen.dart';
import 'package:reminder/User/LoginScreen.dart';
import 'package:reminder/User/authContoller.dart';
import 'package:reminder/utils/Loder.dart';
import 'package:reminder/utils/appTheme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:uuid/uuid.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
          channelKey: "778899",
          channelName: "Reminder",
          channelDescription: "Let's forget to Remind"),
    ],
    debug: true,
  );
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Reminder',
        theme: AppTheme.theme,
        home: ref.watch(USerDetailsFormain).when(
            data: (data) {
              if (data != null) {
                return HomeScreen(
                  currLati: "",
                  currLogi: "",
                  cuuAddress: "",
                );
              }
              return LoginScreen();
            },
            error: (e, trace) {
              print(e.toString());
              return SizedBox();
            },
            loading: () => LoderScreen()));
  }
}
