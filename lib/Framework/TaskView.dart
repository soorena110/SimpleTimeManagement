import 'package:flutter/material.dart';

import 'StaggerIcon.dart';
import 'Task.dart';

class TaskView extends StatelessWidget {
  final Task _task;

  TaskView(this._task, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(_task.getTitle()),
      leading: CircleAvatar(
        backgroundColor: _task.getColor(),
        foregroundColor: Colors.white,
        child: StaggerIcon(
          _task.getIcon(),
          isActive: true  ,
        ),
      ),
    );
  }
}
