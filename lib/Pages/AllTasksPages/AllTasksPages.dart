import 'package:flutter/material.dart';
import 'package:time_river/Database/Tables/MonthTaskTable.dart';
import 'package:time_river/Database/Tables/OnceTaskTable.dart';
import 'package:time_river/Database/Tables/TaskBaseTable.dart';
import 'package:time_river/Database/Tables/WeekTaskTable.dart';
import 'package:time_river/Models/ViewableTask.dart';
import 'package:time_river/Pages/AddTaskPage/AddTaskPage.dart';
import 'package:time_river/Pages/TaskDetailsPage/TaskDetailsPage.dart';
import 'package:time_river/Pages/ViewableTask/OnceTaskListView.dart';

class AllViewableTasksPage extends StatefulWidget {
  ViewableTaskType taskType;

  AllViewableTasksPage(this.taskType);

  @override
  State<StatefulWidget> createState() {
    return AllViewableTasksPageState();
  }
}

class AllViewableTasksPageState extends State<AllViewableTasksPage> {
  List<ViewableTask> showingTasks;

  @override
  void initState() {
    super.initState();

    showingTasks = <ViewableTask>[];
    this._fetchTasksAndTheirTicks();
  }

  TaskBaseTable _getRelatedRepository() {
    switch (widget.taskType) {
      case ViewableTaskType.once:
        return onceTaskTable;
      case ViewableTaskType.week:
        return weekTaskTable;
      case ViewableTaskType.month:
        return monthTaskTable;
    }
  }

  void _fetchTasksAndTheirTicks() async {
    final repository = _getRelatedRepository();

    var tasks = (await repository.queryAllTasks())
        .map((json) => ViewableTask.fromJson(json, type: widget.taskType))
        .toList();

    setState(() {
      showingTasks = tasks;
    });
  }

  _selectATask(ViewableTask task) async {
    final taskIsChanged = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => TaskDetailsPage(task)));

    if (taskIsChanged) this._fetchTasksAndTheirTicks();
  }

  _buildBody() {
    return ViewableTaskListView(
        showingTasks.map((r) => r.toViewableTask()).toList(),
        showLastEdit: true,
        onItemSelected: (task) => this._selectATask(task));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('همه تسک‌های تکی',
              style: TextStyle(
                color: Colors.white,
              ))),
      body: this._buildBody(),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            final taskIsChanged = await Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddOnceTaskPage()));
            if (taskIsChanged) this._fetchTasksAndTheirTicks();
          }),
    );
  }
}
