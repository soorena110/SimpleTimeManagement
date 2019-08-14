import 'package:flutter/material.dart';
import 'Database/init.dart';
import 'Layout.dart';

void main() {
  databaseInit();
  runApp(Layout());
  WidgetsBinding.instance.addObserver(LifecycleEventHandler());
}

class LifecycleEventHandler extends WidgetsBindingObserver {
  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.suspending) databaseClose();
    print('=== $state');
  }
}
