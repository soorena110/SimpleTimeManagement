import 'package:flutter/material.dart';
import 'package:time_river/Database/init.dart';

import 'App.dart';
import 'LifecycleEventHandler.dart';

void main() async {
  await databaseInit();
  runApp(App());
  WidgetsBinding.instance.addObserver(LifecycleEventHandler());
}