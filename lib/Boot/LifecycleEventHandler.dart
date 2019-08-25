import 'package:flutter/material.dart';
import 'package:time_river/Database/init.dart';

class LifecycleEventHandler extends WidgetsBindingObserver {
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
