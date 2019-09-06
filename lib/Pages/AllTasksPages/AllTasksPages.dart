import 'package:flutter/material.dart';
import 'package:time_river/Models/Task.dart';
import 'package:time_river/Pages/AddTaskPage/AddTaskPage.dart';
import 'package:time_river/Pages/TaskDetailsPage/TaskDetailsPage.dart';
import 'package:time_river/Pages/ViewableTask/ViewableTaskListView.dart';
import 'package:time_river/Services/TaskService.dart';

class AllViewableTasksPage extends StatefulWidget {
  TaskType taskType;

  AllViewableTasksPage(this.taskType);

  @override
  State<StatefulWidget> createState() {
    return AllViewableTasksPageState();
  }
}

class AllViewableTasksPageState extends State<AllViewableTasksPage> {
  List<Task> showingTasks;

  @override
  void initState() {
    super.initState();

    showingTasks = <Task>[];
    this._fetchTasksAndTheirTicks();
  }

  void _fetchTasksAndTheirTicks() async {
    var tasks = (await TaskService.getAllTasksOfType(widget.taskType)).toList();
    setState(() {
      showingTasks = tasks;
    });
  }

  _selectATask(Task task) async {
    final taskIsChanged = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => TaskDetailsPage(task)));

    if (taskIsChanged) this._fetchTasksAndTheirTicks();
  }

  _buildBody() {
    return RefreshIndicator(
      onRefresh: () async => this._fetchTasksAndTheirTicks(),
      child: ViewableTaskListView(showingTasks,
          showLastEdit: true,
          onItemSelected: (task) => this._selectATask(task)),
    );
  }

  _buildFloatingActionButton() {
    return FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final taskIsChanged = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AddTaskPage(
                        taskType: widget.taskType,
                      )));
          if (taskIsChanged != null && taskIsChanged)
            this._fetchTasksAndTheirTicks();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(ViewableTaskTypeNames[widget.taskType])),
      body: this._buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }
}
