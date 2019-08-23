import 'package:flutter/material.dart';
import 'package:time_river/Framework/CircleIcon.dart';
import 'package:time_river/Framework/StaggerCircle.dart';
import 'package:time_river/Models/OnceTask.dart';

class OnceTaskListItem extends StatelessWidget {
  final OnceTask _task;
  final bool showLastEdit;

  OnceTaskListItem(this._task, {this.showLastEdit = false});

  @override
  Widget build(BuildContext context) {
    final _circleIcon = this._task.getIsCritical()
        ? StaggerCircle(this._task.getIcon(), this._task.getColor())
        : CircleIcon(this._task.getIcon(), this._task.getColor());

    final _trailing = Text(this._task.getRemainingTime(),
        style: TextStyle(
            color: this._task.getIsCritical() ? Colors.deepOrange : null));

    _subtitle() {
      if (this.showLastEdit && this._task.lastUpdate != null)
        return Text(this._task.lastUpdate.replaceFirst(' ', ' ساعت '));
      if (this._task.estimate != null)
        return Text(this._task.getEstimateString());
      return null;
    }

    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(blurRadius: 1, color: Colors.grey[200])]),
        child: ListTile(
            title: Text(_task.name),
            leading: _circleIcon,
            trailing: _trailing,
            subtitle: _subtitle()));
  }
}
