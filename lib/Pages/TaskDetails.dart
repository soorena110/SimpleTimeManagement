import 'package:flutter/material.dart';
import 'package:time_river/Framework/Task/TaskListItem.dart';
import 'package:time_river/Framework/Task/TaskView.dart';
import 'package:time_river/Models/Task.dart';

class TaskDetails extends StatelessWidget {
  final Task _task;

  const TaskDetails(this._task, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.cyan, title: TaskListItem(_task)),
            body: TaskView(_task)));
  }
}
