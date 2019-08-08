import 'package:flutter/material.dart';
import 'package:time_river/Framework/Task/TaskListItem.dart';
import 'package:time_river/Framework/Task/TaskView.dart';
import 'package:time_river/Models/Task.dart';

import 'TaskEdit.dart';

class TaskDetails extends StatelessWidget {
  final Task _task;

  const TaskDetails(this._task, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(backgroundColor: Colors.cyan, title: TaskListItem(_task)),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TaskEdit(_task)));
            }),
        body: TaskView(_task));
  }
}
