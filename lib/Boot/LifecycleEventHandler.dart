import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_river/Database/init.dart';
import 'package:time_river/Services/TaskService.dart';

import 'NotificationCenter.dart';

const methodChannel = const MethodChannel('com.example.timerTick');
var lightsOn = false;

class LifecycleEventHandler extends WidgetsBindingObserver {
  LifecycleEventHandler() {
    TaskService.onChanged = checkCriticalSituation;
    methodChannel.setMethodCallHandler((call) async {
      checkCriticalSituation();
    });
  }

  checkCriticalSituation() async {
    final tasks = await TaskService.getTodayTasks();
    final criticalTasks = tasks.where((task) => task.getIsCritical()).toList();
    if (criticalTasks.length > 0)
      NotificationCenter().turnFlashOn();
    else
      NotificationCenter().turnFlashOff();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.suspending:
        await databaseClose();
        break;
      case AppLifecycleState.resumed:
        await databaseOpen();
    }
    print('=== $state');
  }
}
