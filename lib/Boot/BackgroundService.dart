import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:time_river/Database/Provider.dart';
import 'package:time_river/Models/Task.dart';
import 'package:time_river/Services/TaskService.dart';

import 'NotificationCenter.dart';

class BackgroundService {
  static bool isCriticalState = false;
  static List<Task> tasks;
  static int day = DateTime
      .now()
      .day;

  static _refreshStatusInSharedPreference() async {
    if (tasks == null || day != DateTime
        .now()
        .day) {
      tasks = await TaskService.getTodayTasks();
      day = DateTime
          .now()
          .day;
    }

    final criticalTasks = tasks.where((task) => task.getIsCritical()).toList();
    final status = criticalTasks.length > 0;

    if (isCriticalState)
      Fluttertoast.showToast(
          msg: criticalTasks.length.toString().toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          fontSize: 5);
    isCriticalState = status;
  }

  static _notifyIfItIsCriticalStatus() async {
    if (isCriticalState) await NotificationCenter.blink();
  }

  static searchCriticalSituationInDatabase() async {
    try {
      await databaseProvider.open();
      await _refreshStatusInSharedPreference();
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Opps",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          fontSize: 8.0);
    }
  }

  static checkCriticalSituationInTimer() async {
    await searchCriticalSituationInDatabase();
    await _notifyIfItIsCriticalStatus();
  }

  static start() async {
    await AndroidAlarmManager.periodic(
      Duration(seconds: 10),
      1000,
      checkCriticalSituationInTimer,
      wakeup: true,
    );
  }

  static stop() async {
    isCriticalState = false;
    await AndroidAlarmManager.cancel(1000);
  }
}
