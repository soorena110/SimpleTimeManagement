import 'package:time_river/Database/Tables/Tasks/WeekTaskTable.dart';
import 'package:time_river/Libraries/datetime.dart';

import 'Tick.dart';

enum TaskType { once, week, month }

final TaskTypeNames = {
  TaskType.once: 'تسک تکی',
  TaskType.week: 'تسک هفتگی',
  TaskType.month: 'تسک ماهانه',
};

class Task {
  int id;
  String name;
  String start;
  String end;
  double estimate;
  String description;
  String lastUpdate;

  TaskType type;
  Map<String, dynamic> infos;
  Tick tick;

  Task({this.id,
    this.name,
    this.start,
    this.end,
    this.description,
    this.estimate,
    this.lastUpdate,
    this.type,
    this.infos = const <String, dynamic>{},
    this.tick});

  bool getIsCritical() {
    if ([TickType.done, TickType.canceled, TickType.doing].contains(tick?.type))
      return false;

    final realTaskEnd = computeRealTaskEndDateTime();
    if (realTaskEnd == null) return false;

    final now = getNow();
    final remainingTime = getDateTimeDiff(realTaskEnd, now).inMinutes;
    return remainingTime - (estimate ?? 0) * 60 < 20;
  }

  String computeRealTaskDateTime([bool isStartNotEnd = false]) {
    String defaultHour = isStartNotEnd ? '00:00' : '24:00';

    switch (this.type) {
      case TaskType.once:
        return isStartNotEnd ? this.start : this.end;

      case TaskType.month:
        final month = (tick?.infos ?? {})['month'];
        if (month != null) {
          final theHour = tick.infos[isStartNotEnd ? 'startHour' : 'endHour'] ??
              defaultHour;
          return '$month/${infos['dayOfMonth']} $theHour';
        }
        return null;

      case TaskType.week:
        final day = (tick?.infos ?? {})['day'];
        if (day != null) {
          final theHour = tick.infos[isStartNotEnd ? 'startHour' : 'endHour'] ??
              defaultHour;
          return '$day $theHour';
        }
        return null;

      default:
        throw 'Task type is not valid !';
    }
  }

  String computeRealTaskStartDateTime() => computeRealTaskDateTime(true);

  String computeRealTaskEndDateTime() => computeRealTaskDateTime(false);

  String getRemainingTime() {
    final realTaskStart = computeRealTaskStartDateTime();
    if (realTaskStart != null) {
      final now = getNow();
      if (getDateDiff(realTaskStart, now).inMilliseconds > 0)
        return getStartDateDiffText();
    }

    final realTaskEnd = computeRealTaskEndDateTime();
    if (realTaskEnd != null) return getEndDateDiff();

    return '';
  }

  String getEstimateString() => convertDoubleTimeToString(this.estimate);

  String getStartDateDiffText() {
    final now = getNow();
    final realTaskStart = computeRealTaskStartDateTime();

    if (realTaskStart != null)
      return 'شروع : ' + getDiffrenceText(realTaskStart, now);
    return '';
  }

  String getEndDateDiff() {
    final now = getNow();
    final realTaskEnd = computeRealTaskEndDateTime();

    if (realTaskEnd != null)
      return 'پایان : ' + getDiffrenceText(realTaskEnd, now);
    return '';
  }

  String getMoreInfo() {
    switch (type) {
      case TaskType.once:
        return null;
      case TaskType.week:
        final String day = tick.infos['day'];
        final weekDay = getGregorian(day).weekday + 1 % 7;
        return weekDayNames[weekDay];
      case TaskType.month:
        if (tick == null) return null;
        final month = int.parse(tick.infos['month']
            .split('/')
            .last);
        return '$month/${infos['dayOfMonth'].toString()}';

      default:
        throw 'Task type is not valid !';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'start': start,
      'end': end,
      'estimate': estimate,
      'lastUpdate': getNow()
    }
      ..addAll(infos);
  }

  Task.fromJson(Map<String, dynamic> json, {this.type})
      : id = json['id'],
        name = json['name'],
        description = json['description'],
        start = json['start'],
        end = json['end'],
        estimate = json['estimate'] is String
            ? double.parse(json['estimate'])
            : json['estimate'],
        lastUpdate = json['lastUpdate'] {
    this.infos = <String, dynamic>{};
    json.forEach((key, value) {
      if (!taskBaseKeys.contains(key)) infos[key] = value;
    });
  }

  @override
  String toString() {
    return '$id $name';
  }
}

const taskBaseKeys = const [
  'id',
  'name',
  'start',
  'end',
  'description',
  'estimate',
  'lastUpdate'
];
