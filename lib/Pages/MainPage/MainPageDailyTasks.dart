import 'package:flutter/material.dart';
import 'package:time_river/Database/Tables/OnceTaskTable.dart';
import 'package:time_river/Libraries/datetime.dart';
import 'package:time_river/Models/OnceTask.dart';
import 'package:time_river/Pages/OnceTask/OnceTaskListView.dart';

import '../TaskDetailsPage/TaskDetailsPage.dart';

class MainPageDailyTasks extends StatefulWidget {
  final Function(bool isCritical) onStateChanged;

  const MainPageDailyTasks(this.onStateChanged);

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
    todayTasks.where((t) => todosOrPostpone.contains(t.tick)).toList();

    todayTasksTodoOrPostpone.sort((r, s) {
      final endDateDiff = compareDateTime(r.end, s.end);
      if (endDateDiff != 0) return endDateDiff;

      final startDateDiff = compareDateTime(r.start, s.start);
      if (startDateDiff != 0) return startDateDiff;

      return ((r.estimate ?? 0) - (s.estimate ?? 0))
          .toInt()
          .sign;
    });

    setState(() {
      showingTasks = todayTasksTodoOrPostpone;
    });
    widget.onStateChanged(
        showingTasks
            .where((t) => t.getIsCritical())
            .length > 0);
  }

  _selectATask(OnceTask task) async {
    final taskIsChanged = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => TaskDetails(task)));

    if (taskIsChanged) this._fetchTasksAndTheirTicks();
  }

  @override
  Widget build(BuildContext context) {
    return OnceTaskListView(showingTasks,
        onItemSelected: (task) => this._selectATask(task));
  }
}
