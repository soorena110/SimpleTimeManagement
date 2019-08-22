import 'package:flutter/material.dart';
import 'package:time_river/Database/Tables/OnceTaskTable.dart';
import 'package:time_river/Database/Tables/OnceTaskTickTable.dart';
import 'package:time_river/Models/OnceTask.dart';
import 'package:time_river/Models/OnceTaskTick.dart';
import 'package:time_river/Pages/OnceTask/OnceTaskListView.dart';
import '../TaskDetails.dart';

class MainPageDailyTasks extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainPageDailyTasksState();
  }
}

class MainPageDailyTasksState extends State<MainPageDailyTasks> {
  List<OnceTask> showingTasks;

  @override
  void initState() {
    super.initState();

    showingTasks = <OnceTask>[];
    this._fetchTasksAndTheirTicks();
  }

  void _fetchTasksAndTheirTicks() async {
    final todosOrPostpone = [OnceTaskTick.todo, OnceTaskTick.postponed];
    var todayTasks = await OnceTaskTable.queryTodayTasks();
    var todayTasksTodoOrPostpone =
        todayTasks.where((t) => todosOrPostpone.contains(t.tick));

    setState(() {
      showingTasks = todayTasksTodoOrPostpone.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return OnceTaskListView(showingTasks,
        onItemSelected: (task) => Navigator.push(context,
            MaterialPageRoute(builder: (context) => TaskDetails(task))));
  }
}
