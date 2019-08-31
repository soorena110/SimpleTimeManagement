import 'TaskBase.dart';
import 'Tick.dart';
import 'ViewableTask.dart';

class WeekTask extends TaskBase {
  int dayOfMonth;
  String hour;

  WeekTask(String name,
      {int id,
      String description,
      String start,
      String end,
      double estimate,
      this.dayOfMonth,
      this.hour,
      String lastUpdate})
      : super(id, name, start, end, description, estimate, lastUpdate);

  WeekTask.fromJson(Map<String, dynamic> json)
      : dayOfMonth = int.parse(json['dayOfMonth']),
        hour = json['hour'],
        super.fromJson(json);

  Map<String, dynamic> toJson() => super.toJson()
    ..addAll({
      'dayOfMonth': dayOfMonth,
      'hour': hour,
    });

  ViewableTask toViewableTask([Tick tick]) {
    final viewable = super.toViewableTask();
    viewable.type = ViewableTaskType.month;
    viewable.tick = tick;
    viewable.infos = {'dayOfMonth': dayOfMonth, 'hour': hour};
    return viewable;
  }
}
