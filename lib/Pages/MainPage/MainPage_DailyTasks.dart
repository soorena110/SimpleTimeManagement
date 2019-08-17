import 'package:flutter/material.dart';
import 'package:time_river/Database/TaskTable.dart';
import 'package:time_river/Framework/Task/TaskListView.dart';
import 'package:time_river/Models/Task.dart';
import 'package:colorize/colorize.dart';

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
    super.initState();

    tasks = <Task>[];
    TaskTable.queryTodayTasks().then((res) {
      setState(() => tasks = res ?? <Task>[]);
    }).catchError((r) => print(Colorize(r)..red()));
  }

  @override
  Widget build(BuildContext context) {
    return TaskListView(tasks);
  }
}
