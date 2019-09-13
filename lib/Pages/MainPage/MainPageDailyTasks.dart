import 'package:flutter/material.dart';
import 'package:time_river/Libraries/datetime.dart';
import 'package:time_river/Models/Task.dart';
import 'package:time_river/Models/Tick.dart';
import 'package:time_river/Pages/TaskDetailsPage/TaskDetailsPage.dart';
import 'package:time_river/Pages/ViewableTask/ViewableTaskListView.dart';
import 'package:time_river/Services/TaskService.dart';

class MainPageDailyTasks extends StatefulWidget {
  final Function(bool isCritical) onStateChanged;
  final bool showDoneOrCanceled;
  final String start;
  final String end;
  final List<TaskType> filterTaskTypes;

  const MainPageDailyTasks({this.onStateChanged,
    this.start,
    this.end,
    this.filterTaskTypes,
    this.showDoneOrCanceled});

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
        fromDateTime: widget.start, toDateTime: widget.end);

    if (widget.filterTaskTypes != null)
      tasks = tasks.where((task) => widget.filterTaskTypes.contains(task.type));

    setState(() {
      showingTasks = tasks.toList()
        ..sort((a, b) {
          final aDate = a.computeRealTaskEndDateTime();
          final bDate = b.computeRealTaskEndDateTime();
          if (aDate == null) return 1;
          if (bDate == null) return -1;
          final firstCompare = compareDateTime(aDate, bDate);
          if (firstCompare != 0) return firstCompare;
          return compareDateTime(a.lastUpdate, b.lastUpdate);
        });
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
    List<Task> tasks = showingTasks;

    if (!widget.showDoneOrCanceled)
      tasks = tasks
          .where((task) =>
          [
            null,
            TickType.todo,
            TickType.doing,
            TickType.postponed
          ].contains(task.tick?.type))
          .toList();

    return RefreshIndicator(
        onRefresh: () async => this._fetchTasksAndTheirTicks(),
        child: ViewableTaskListView(tasks,
            onItemSelected: (task) => this._selectATask(task)));
  }
}
