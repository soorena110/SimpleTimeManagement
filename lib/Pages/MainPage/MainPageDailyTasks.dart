import 'package:flutter/material.dart';
import 'package:time_river/Models/Task.dart';
import 'package:time_river/Pages/TaskDetailsPage/TaskDetailsPage.dart';
import 'package:time_river/Pages/ViewableTask/ViewableTaskListView.dart';
import 'package:time_river/Services/TaskService.dart';

class MainPageDailyTasks extends StatefulWidget {
  final Function(bool isCritical) onStateChanged;
  final String start;
  final String end;
  final List<TaskType> filterTaskTypes;

  const MainPageDailyTasks(
      {this.onStateChanged, this.start, this.end, this.filterTaskTypes});

  @override
  State<StatefulWidget> createState() {
    return MainPageDailyTasksState();
  }
}

class MainPageDailyTasksState extends State<MainPageDailyTasks> {
  List<Task> showingTasks;

  @override
  void initState() {
    super.initState();

    showingTasks = <Task>[];
    this._fetchTasksAndTheirTicks();
  }

  @override
  void didUpdateWidget(MainPageDailyTasks oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.start != oldWidget.start || widget.end != oldWidget.end)
      _fetchTasksAndTheirTicks();
  }

  void _fetchTasksAndTheirTicks() async {
    var tasks = await TaskService.getTaskWhere(
        fromDate: widget.start, toDate: widget.end);

    if (widget.filterTaskTypes != null)
      tasks = tasks.where((task) => widget.filterTaskTypes.contains(task.type));

    setState(() {
      showingTasks = tasks.toList();
    });
    widget.onStateChanged(
        showingTasks.where((t) => t.getIsCritical()).length > 0);
  }

  _selectATask(Task task) async {
    final taskIsChanged = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => TaskDetailsPage(task)));

    if (taskIsChanged) this._fetchTasksAndTheirTicks();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () async => this._fetchTasksAndTheirTicks(),
        child: ViewableTaskListView(showingTasks,
            onItemSelected: (task) => this._selectATask(task)));
  }
}
