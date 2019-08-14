import 'package:flutter/material.dart';
import 'package:time_river/Database/TaskTable.dart';
import 'package:time_river/Framework/Task/TaskListView.dart';
import 'package:time_river/Models/Task.dart';

class MainPage_DailyTasks extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainPage_DailyTasksState();
  }
}

class MainPage_DailyTasksState extends State<MainPage_DailyTasks> {
  var tasks;

  @override
  void initState() {
    tasks = <Task>[];
    TaskTable.queryTodayTasks().then((res) {
      setState(() => tasks = res ?? <Task>[]);
    }).catchError((r) => print(r));
  }

  @override
  Widget build(BuildContext context) {
    print(tasks);
    return TaskListView(tasks);
  }
}
