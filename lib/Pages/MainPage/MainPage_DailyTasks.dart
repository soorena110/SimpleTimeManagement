import 'package:flutter/material.dart';
import 'package:time_river/Database/TaskTable.dart';
import 'package:time_river/Models/Task.dart';
import 'package:time_river/Framework/Task/TaskListView.dart';

class MainPage_DailyTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    var tasks = TaskTable.queryTodayTasks() ?? [];
    return TaskListView([]);
  }
}
