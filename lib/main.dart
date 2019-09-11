import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:time_river/Services/TaskService.dart';

import 'Boot/App.dart';
import 'Boot/BackgroundService.dart';
import 'Boot/LifecycleEventHandler.dart';
import 'Boot/ServerSyncManager.dart';
import 'Database/init.dart';

void main() async {
//  SystemChrome.setEnabledSystemUIOverlays([]);

  await databaseOpen();
  await AndroidAlarmManager.initialize();

  runApp(App());

  ServerSyncManager.sync();

  await BackgroundService.searchCriticalSituationInDatabase();
  await BackgroundService.stop();
  WidgetsBinding.instance.addObserver(LifecycleEventHandler());
  TaskService.onChanged = BackgroundService.searchCriticalSituationInDatabase;
}
