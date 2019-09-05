import 'package:flutter/material.dart';
import 'package:time_river/Models/ViewableTask.dart';

import 'ViewableTaskListItem.dart';

class ViewableTaskListView extends StatelessWidget {
  final List<ViewableTask> tasks;
  final void Function(ViewableTask task) onItemSelected;
  final bool showLastEdit;

  const ViewableTaskListView(this.tasks,
      {this.onItemSelected, this.showLastEdit = false});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(0),
        itemCount: tasks.length,
        itemBuilder: (BuildContext context, int index) {
          var task = tasks[index];
          return GestureDetector(
              child:
                  ViewableTaskListItem(task, showLastEdit: this.showLastEdit),
              onTap: () {
                if (this.onItemSelected != null) this.onItemSelected(task);
              });
        });
  }
}
