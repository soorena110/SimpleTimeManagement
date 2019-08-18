import 'package:flutter/material.dart';
import 'package:time_river/Framework/StaggerIcon.dart';
import 'package:time_river/Models/OnceTask.dart';

class OnceTaskListItem extends StatelessWidget {
  final OnceTask _task;

  OnceTaskListItem(this._task, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(_task.name),
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
