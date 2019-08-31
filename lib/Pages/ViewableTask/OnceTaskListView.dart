import 'package:flutter/material.dart';
import 'package:time_river/Models/ViewableTask.dart';

import 'OnceTaskListItem.dart';

class ViewableTaskListView extends StatelessWidget {
  final List<ViewableTask> _onceTasks;
  final void Function(ViewableTask onceTask) onItemSelected;
  final bool showLastEdit;

  const ViewableTaskListView(this._onceTasks,
      {this.onItemSelected, this.showLastEdit = false});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(0),
        itemCount: _onceTasks.length,
        itemBuilder: (BuildContext context, int index) {
          var task = _onceTasks[index];
          return GestureDetector(
              child:
                  ViewableTaskListItem(task, showLastEdit: this.showLastEdit),
              onTap: () {
                if (this.onItemSelected != null) this.onItemSelected(task);
              });
        });
  }
}
