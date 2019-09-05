import 'LoopingTaskBase.dart';
import 'Tick.dart';
import 'ViewableTask.dart';

class WeekTask extends LoopingTaskBase {
  int weekdays;

  WeekTask(String name,
      {int id,
      String description,
      String start,
      String end,
      double estimate,
      this.weekdays,
        String startHour,
        String endHour,
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
      : weekdays = int.parse(json['weekdays']),
        super.fromJson(json);

  Map<String, dynamic> toJson() => super.toJson()
    ..addAll({
      'weekdays': weekdays,
    });

  ViewableTask toViewableTask([Tick tick]) {
    final viewable = super.toViewableTask();
    viewable.type = ViewableTaskType.week;
    viewable.tick = tick;
    viewable.infos.addAll({
      'weekdays': weekdays,
    });
    return viewable;
  }
}
