import 'package:flutter/material.dart';
import 'package:time_river/Database/Tables/OnceTaskTable.dart';
import 'package:time_river/Models/OnceTask.dart';
import 'package:colorize/colorize.dart';
import 'package:time_river/Pages/OnceTask/OnceTaskListView.dart';

class MainPageDailyTasks extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainPageDailyTasksState();
  }
}

class MainPageDailyTasksState extends State<MainPageDailyTasks> {
  var tasks;

  @override
  void initState() {
    super.initState();

    tasks = <OnceTask>[];
    OnceTaskTable.queryTodayTasks().then((res) {
      setState(() => tasks = res ?? <OnceTask>[]);
    }).catchError((r) => print(Colorize(r)..red()));
  }

  @override
  Widget build(BuildContext context) {
    return OnceTaskListView(tasks);
  }
}
