import 'package:flutter/material.dart';
import 'package:time_river/Framework/Task.dart';
import 'package:time_river/Framework/TaskView.dart';

class TaskDetails extends StatelessWidget {
  final Task _task;

  const TaskDetails(this._task, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton:
            FloatingActionButton(child: Icon(Icons.edit), onPressed: null),
        body: Column(
          children: <Widget>[TaskView(_task), Text('More Details')],
        ));
  }
}
