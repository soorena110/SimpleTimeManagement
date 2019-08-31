import 'TaskBase.dart';
import 'Tick.dart';
import 'ViewableTask.dart';

class WeekTask extends TaskBase {
  int weekdays;
  String hour;

  WeekTask(String name,
      {int id,
      String description,
      String start,
      String end,
      double estimate,
      this.weekdays,
      this.hour,
      String lastUpdate})
      : super(id, name, start, end, description, estimate, lastUpdate);

  WeekTask.fromJson(Map<String, dynamic> json)
      : weekdays = int.parse(json['weekdays']),
        hour = json['hour'],
        super.fromJson(json);

  Map<String, dynamic> toJson() => super.toJson()
    ..addAll({
      'weekdays': weekdays,
      'hour': hour,
    });


  ViewableTask toViewableTask([Tick tick]) {
    final viewable = super.toViewableTask();
    viewable.type = ViewableTaskType.month;
    viewable.tick = tick;
    viewable.infos = {'weekdays': weekdays, 'hour': hour};
    return viewable;
  }
}
