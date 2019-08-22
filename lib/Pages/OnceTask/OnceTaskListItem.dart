import 'package:flutter/material.dart';
import 'package:time_river/Framework/StaggerIcon.dart';
import 'package:time_river/Models/OnceTask.dart';

class OnceTaskListItem extends StatelessWidget {
  final OnceTask _task;

  OnceTaskListItem(this._task);

  _getIsStaggering() {
    return false;
  }

  _getRemainingTime() {

    return '2 ساعت دیگر';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 1),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(blurRadius: 1, color: Colors.grey[200])]
        ),
        child: ListTile(
          title: Text(_task.name),
          leading: CircleAvatar(
            backgroundColor: _task.getColor(),
            foregroundColor: Colors.white,
            child: this._getIsStaggering()
                ? StaggerIcon(_task.getIcon())
                : Icon(_task.getIcon()),
          ),
          trailing: Text(this._getRemainingTime()),
        ));
  }
}
