import 'TaskBase.dart';

class WeekTask extends TaskBase {
  int weekdays;
  String hour;

  //#region Constructors

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

//#endregion
//#region Apis

//#endregion

}
