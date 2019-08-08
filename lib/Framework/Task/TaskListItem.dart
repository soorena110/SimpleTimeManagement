import 'package:flutter/material.dart';
import 'package:time_river/Models/Task.dart';
import '../StaggerIcon.dart';

class TaskListItem extends StatelessWidget {
  final Task _task;

  TaskListItem(this._task, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(_task.title),
      leading: CircleAvatar(
        backgroundColor: _task.getColor(),
        foregroundColor: Colors.white,
        child: StaggerIcon(
          _task.getIcon(),
          isActive: true,
        ),
      ),
    );
  }
}
