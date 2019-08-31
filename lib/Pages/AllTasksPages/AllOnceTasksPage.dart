import 'package:flutter/material.dart';
import 'package:time_river/Database/Tables/OnceTaskTable.dart';
import 'package:time_river/Libraries/datetime.dart';
import 'package:time_river/Models/OnceTask.dart';
import 'package:time_river/Models/ViewableTask.dart';
import 'package:time_river/Pages/ViewableTask/OnceTaskListView.dart';

class AllOnceTasksPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AllOnceTasksPageState();
  }
}

class AllOnceTasksPageState extends State<AllOnceTasksPage> {
  List<OnceTask> showingTasks;

  @override
  void initState() {
    super.initState();

    showingTasks = <OnceTask>[];
    this._fetchTasksAndTheirTicks();
  }

  void _fetchTasksAndTheirTicks() async {
    var tasks = (await OnceTaskTable.queryAllTasks()).toList();

    tasks.sort((r, s) {
      return compareDateTime(r.lastUpdate, s.lastUpdate);
    });

    setState(() {
      showingTasks = tasks;
    });
  }

  _selectATask(ViewableTask task) async {
//    final taskIsChanged = await Navigator.push(
//        context, MaterialPageRoute(builder: (context) => TaskDetails(task)));
//
//    if (taskIsChanged) this._fetchTasksAndTheirTicks();
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
          backgroundColor: Colors.lightGreen[200],
          title: Text('همه تسک‌های تکی')),
      body: this._buildBody(),
    );
  }
}
