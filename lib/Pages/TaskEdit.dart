import 'package:flutter/material.dart';
import 'package:time_river/Framework/Task/TaskEditOrCreate.dart';
import 'package:time_river/Framework/Task/TaskListItem.dart';
import 'package:time_river/Models/Task.dart';

class TaskEdit extends StatelessWidget {
  final Task _task;
  var _scaffold = GlobalKey<ScaffoldState>();

  TaskEdit(this._task);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffold,
        appBar: AppBar(
            backgroundColor: Colors.lightGreen, title: TaskListItem(_task)),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.done),
            onPressed: () {
              _scaffold.currentState
                  .showSnackBar(SnackBar(content: Text('Hmmmm ....')));
            }),
        body: TaskEditOrCreate(_task));
  }
}
