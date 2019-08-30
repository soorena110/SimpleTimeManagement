import 'package:flutter/material.dart';
import 'package:time_river/Database/Tables/OnceTaskTable.dart';
import 'package:time_river/Libraries/datetime.dart';
import 'package:time_river/Models/OnceTask.dart';
import 'package:time_river/Pages/OnceTask/OnceTaskListView.dart';
import 'package:time_river/Pages/TaskDetailsPage/TaskDetailsPage.dart';

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

  _selectATask(OnceTask task) async {
    final taskIsChanged = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => TaskDetails(task)));

    if (taskIsChanged) this._fetchTasksAndTheirTicks();
  }

  _buildBody() {
    return OnceTaskListView(showingTasks,
        showLastEdit: true, onItemSelected: (task) => this._selectATask(task));
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.lightGreen[200],
              title: Text('همه تسک‌های تکی')),
          body: this._buildBody(),
        ));
  }
}
