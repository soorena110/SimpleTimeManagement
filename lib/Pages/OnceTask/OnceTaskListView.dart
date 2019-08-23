import 'package:flutter/material.dart';
import 'package:time_river/Models/OnceTask.dart';

import 'OnceTaskListItem.dart';

class OnceTaskListView extends StatelessWidget {
  final List<OnceTask> _onceTasks;
  final void Function(OnceTask onceTask) onItemSelected;
  final bool showLastEdit;

  const OnceTaskListView(this._onceTasks,
      {this.onItemSelected,
        this.showLastEdit = false});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(0),
        itemCount: _onceTasks.length,
        itemBuilder: (BuildContext context, int index) {
          var task = _onceTasks[index];
          return GestureDetector(
              child: OnceTaskListItem(task, showLastEdit: this.showLastEdit),
              onTap: () {
                if (this.onItemSelected != null) this.onItemSelected(task);
              });
        });
  }
}
