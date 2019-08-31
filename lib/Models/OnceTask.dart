import 'package:time_river/Models/ViewableTask.dart';

import 'TaskBase.dart';
import 'Tick.dart';

class OnceTask extends TaskBase {
  OnceTask(String name,
      {int id,
        String description,
        String start,
        String end,
        double estimate,
        String lastUpdate})
      : super(
      id,
      name,
      start,
      end,
      description,
      estimate,
      lastUpdate);

  OnceTask.fromJson(Map<String, dynamic> json) : super.fromJson(json);

  Map<String, dynamic> toJson() => super.toJson();

  ViewableTask toViewableTask([Tick tick]) {
    final viewable = super.toViewableTask();
    viewable.type = ViewableTaskType.once;
    viewable.tick = tick;
    return viewable;
  }
}
