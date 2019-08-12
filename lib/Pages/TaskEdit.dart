import 'package:flutter/material.dart';
import 'package:time_river/Framework/Task/TaskListItem.dart';
import 'package:time_river/Models/Task.dart';

class TaskEdit extends StatelessWidget {
  final Task task;
  var _scaffold = GlobalKey<ScaffoldState>();

  TaskEdit(this.task);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffold,
        appBar: AppBar(
            backgroundColor: Colors.lightGreen, title: TaskListItem(task)),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.done),
            onPressed: () {
              _scaffold.currentState
                  .showSnackBar(SnackBar(content: Text('Hmmmm ....')));
            }),
        body: Text('sss'));
//        body: TaskEditOrCreate(toMap(task)));
  }
}
