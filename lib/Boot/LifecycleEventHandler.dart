import 'package:flutter/material.dart';
import 'package:time_river/Database/init.dart';

import 'BackgroundService.dart';

class LifecycleEventHandler extends WidgetsBindingObserver {
  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
        await databaseClose();
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.suspending:
        await BackgroundService.start();
        await databaseClose();
        break;
      case AppLifecycleState.resumed:
        await BackgroundService.stop();
        await databaseOpen();
        break;
    }
    print('=== $state');
  }
}
