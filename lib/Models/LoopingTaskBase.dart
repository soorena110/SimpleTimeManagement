import 'package:time_river/Models/TaskBase.dart';

import 'Tick.dart';
import 'ViewableTask.dart';

class LoopingTaskBase extends TaskBase {
  String startHour;
  String endHour;

  LoopingTaskBase(
      int id,
      String name,
      String start,
      String end,
      String description,
      double estimate,
      String lastUpdate,
      this.startHour,
      this.endHour)
      : super(id, name, start, end, description, estimate, lastUpdate);

  LoopingTaskBase.fromJson(Map<String, dynamic> json)
      : startHour = json['startHour'],
        endHour = json['endHour'],
        super.fromJson(json);

  Map<String, dynamic> toJson() => super.toJson()
    ..addAll({
      'startHour': startHour,
      'endHour': endHour,
    });

  ViewableTask toViewableTask([Tick tick]) {
    final viewable = super.toViewableTask();
    viewable.tick = tick;
    viewable.infos = {'startHour': startHour, 'endHour': endHour};
    return viewable;
  }
}
