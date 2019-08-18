import 'package:flutter/material.dart';
import 'Database/init.dart';
import 'Layout.dart';

void main() async {
  await databaseInit();
  runApp(Layout());
  WidgetsBinding.instance.addObserver(LifecycleEventHandler());
}

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
