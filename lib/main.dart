import 'package:flutter/material.dart';

import 'Boot/App.dart';
import 'Boot/LifecycleEventHandler.dart';
import 'Database/init.dart';

void main() async {
  await databaseInit();
  runApp(App());
  WidgetsBinding.instance.addObserver(LifecycleEventHandler());
}