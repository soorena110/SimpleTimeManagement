import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_river/Database/init.dart';

import 'NotificationCenter.dart';

const methodChannel = const MethodChannel('com.example');
var lightsOn = false;

class LifecycleEventHandler extends WidgetsBindingObserver {
  LifecycleEventHandler() {
    methodChannel.setMethodCallHandler((call) async {
      if (lightsOn)
        NotificationCenter().turnFlashOff();
      else
        NotificationCenter().turnFlashOn();

      lightsOn = !lightsOn;
    });
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
