import 'package:flutter/material.dart';
import 'package:time_river/Models/OnceTask.dart';
import 'OnceTask/OnceTaskListItem.dart';
import 'OnceTask/OnceTaskView.dart';

class TaskDetails extends StatelessWidget {
  final OnceTask _task;

  const TaskDetails(this._task, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.cyan, title: OnceTaskListItem(_task)),
            body: OnceTaskView(_task)));
  }
}
