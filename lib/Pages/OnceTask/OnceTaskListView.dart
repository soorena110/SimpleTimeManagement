import 'package:flutter/material.dart';
import 'package:time_river/Models/OnceTask.dart';
import 'OnceTaskListItem.dart';

class OnceTaskListView extends StatelessWidget {
  final List<OnceTask> _onceTasks;
  final void Function(OnceTask onceTask) onItemSelected;

  const OnceTaskListView(this._onceTasks, {this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _onceTasks.length,
        itemBuilder: (BuildContext context, int index) {
          var task = _onceTasks[index];
          return GestureDetector(
              child: OnceTaskListItem(task),
              onTap: () {
                if(this.onItemSelected != null)
                  this.onItemSelected(task);
              });
        });
  }
}
