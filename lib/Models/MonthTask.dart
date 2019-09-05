import 'LoopingTaskBase.dart';
import 'Tick.dart';
import 'ViewableTask.dart';

class WeekTask extends LoopingTaskBase {
  int dayOfMonth;

  WeekTask(String name,
      {int id,
      String description,
      String start,
      String end,
      double estimate,
        String startHour,
        String endHour,
      this.dayOfMonth,
      String lastUpdate})
      : super(
      id,
      name,
      start,
      end,
      description,
      estimate,
      lastUpdate,
      startHour,
      endHour);

  WeekTask.fromJson(Map<String, dynamic> json)
      : dayOfMonth = int.parse(json['dayOfMonth']),
        super.fromJson(json);

  Map<String, dynamic> toJson() => super.toJson()
    ..addAll({
      'dayOfMonth': dayOfMonth,
    });

  ViewableTask toViewableTask([Tick tick]) {
    final viewable = super.toViewableTask();
    viewable.type = ViewableTaskType.month;
    viewable.tick = tick;
    viewable.infos.addAll({'dayOfMonth': dayOfMonth});
    return viewable;
  }
}
