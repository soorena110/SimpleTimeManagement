import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_river/Database/Provider.dart';
import 'package:time_river/Models/Task.dart';
import 'package:time_river/Services/TaskService.dart';

import 'NotificationCenter.dart';

class BackgroundService {
  static bool isCriticalState;
  static List<Task> tasks;
  static int day = DateTime
      .now()
      .day;

  static getStatusFromSharedPrefrence() async {
    if (isCriticalState == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      isCriticalState = prefs.getBool('isCritical') ?? false;
    }
    return isCriticalState;
  }

  static setStatusFromSharedPrefrence(bool status) async {
    if (status == isCriticalState) return;

    isCriticalState = status;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isCritical', true);
  }

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

    Fluttertoast.showToast(
        msg: criticalTasks.length.toString().toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        fontSize: 5);
    setStatusFromSharedPrefrence(status);
  }

  static _notifyIfItIsCriticalStatus() async {
    if (await getStatusFromSharedPrefrence()) await NotificationCenter.blink();
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

  static int ticks = 0;

  static checkCriticalSituationInTimer() async {
    ticks++;

    if (ticks % 6 == 1) await searchCriticalSituationInDatabase();
    await _notifyIfItIsCriticalStatus();

    Fluttertoast.showToast(
        msg: ticks.toString() +
            ' -> ' +
            (await getStatusFromSharedPrefrence()).toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        fontSize: 5);
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
    await setStatusFromSharedPrefrence(false);
    await AndroidAlarmManager.cancel(1000);
  }
}
