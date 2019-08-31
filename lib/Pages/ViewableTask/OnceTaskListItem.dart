import 'package:flutter/material.dart';
import 'package:time_river/Framework/CircleIcon.dart';
import 'package:time_river/Framework/StaggerCircle.dart';
import 'package:time_river/Models/ViewableTask.dart';

class ViewableTaskListItem extends StatelessWidget {
  final ViewableTask task;
  final bool showLastEdit;

  ViewableTaskListItem(this.task, {this.showLastEdit = false});

  @override
  Widget build(BuildContext context) {
    final _circleIcon = this.task.getIsCritical()
        ? StaggerCircle(this.task.tick?.getIcon(), this.task.tick?.getColor())
        : CircleIcon(this.task.tick?.getIcon(), this.task.tick?.getColor());

    final _trailing = Text(this.task.getRemainingTime(),
        style: TextStyle(
            color: this.task.getIsCritical() ? Colors.deepOrange : null));

    _subtitle() {
      if (this.showLastEdit && this.task.lastUpdate != null)
        return Text(this.task.lastUpdate.replaceFirst(' ', ' ساعت '));
      if (this.task.estimate != null)
        return Text(this.task.getEstimateString());
      return null;
    }

    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(blurRadius: 1, color: Colors.grey[200])]),
        child: ListTile(
            title: Text(task.name),
            leading: _circleIcon,
            trailing: _trailing,
            subtitle: _subtitle()));
  }
}
