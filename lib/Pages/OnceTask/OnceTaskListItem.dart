import 'package:flutter/material.dart';
import 'package:time_river/Framework/CircleIcon.dart';
import 'package:time_river/Framework/StaggerCircle.dart';
import 'package:time_river/Models/OnceTask.dart';

class OnceTaskListItem extends StatelessWidget {
  final OnceTask _task;

  OnceTaskListItem(this._task);

  @override
  Widget build(BuildContext context) {
    final leading = this._task.getIsCritical()
        ? StaggerCircle(this._task.getIcon(), this._task.getColor())
        : CircleIcon(this._task.getIcon(), this._task.getColor());

    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(blurRadius: 1, color: Colors.grey[200])]),
        child: ListTile(
          title: Text(_task.name),
          leading: leading,
          trailing: Text(this._task.getRemainingTime()),
          subtitle: this._task.estimate != null
              ? Text(this._task.getEstimateString())
              : null,
        ));
  }
}
