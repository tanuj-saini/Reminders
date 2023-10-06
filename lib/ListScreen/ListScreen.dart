import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reminder/Home/userReminderModel.dart';
import 'package:reminder/User/authContoller.dart';
import 'package:reminder/utils/Loder.dart';
import 'package:reminder/utils/Pallate.dart';
import 'package:swipe_to/swipe_to.dart';

class ListScreen extends ConsumerStatefulWidget {
  ListScreen({super.key});
  @override
  ConsumerState<ListScreen> createState() {
    return _ListScreen();
  }
}

class _ListScreen extends ConsumerState<ListScreen> {
  List<UserReminderModel> deletedItems = [];
  void deleteReminder({required String reminderUId}) async {
    await ref
        .watch(authContoller.notifier)
        .getDeletedReminder(context: context, reminderUId: reminderUId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reminders"),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: ref.watch(authContoller.notifier).getListRE(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoderScreen();
          }
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(child: Text("No reminders available."));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              UserReminderModel listREminderr = snapshot.data![index];
              return SwipeTo(
                  child: ListTile(
                    title: Text(listREminderr.title),
                    subtitle: Text(
                      listREminderr.ReminderText,
                    ),
                    trailing: IconButton(
                        onPressed: () => deleteReminder(
                            reminderUId: listREminderr.reminderUid),
                        icon: Icon(
                          Icons.delete,
                          color: Colors.redAccent,
                        )),
                  ),
                  onLeftSwipe: () {
                    deleteReminder(reminderUId: listREminderr.reminderUid);

                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Reminder"),
                            content: Text(""),
                            actions: <Widget>[
                              Row(
                                children: [
                                  TextButton(
                                    child: Text("Close"),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    },
                                  ),
                                  TextButton.icon(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      icon: Icon(Icons.undo),
                                      label: Text("Undo"))
                                ],
                              ),
                            ],
                          );
                        });
                  },
                  onRightSwipe: () {
                    deleteReminder(reminderUId: listREminderr.reminderUid);
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Reminder"),
                            content: Text(""),
                            actions: <Widget>[
                              Row(
                                children: [
                                  TextButton(
                                    child: Text("Close"),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    },
                                  ),
                                  TextButton.icon(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      icon: Icon(Icons.undo),
                                      label: Text("Undo")),
                                ],
                              ),
                            ],
                          );
                        });
                  });
            },
          );
        },
      ),
    );
  }
}
