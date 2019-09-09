import 'package:time_river/Libraries/datetime.dart';

import 'Tick.dart';

enum TaskType { once, week, month }

final ViewableTaskTypeNames = {
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

  String computeRealTaskDateTime(String defaultHour) {
    switch (this.type) {
      case TaskType.once:
        return this.start;

      case TaskType.month:
        final month = (tick?.infos ?? {})['month'];
        if (month != null) {
          final startHour = tick.infos['startHour'] ?? defaultHour;
          return '$month/${infos['dayOfMonth']} $startHour';
        }
        return null;

      case TaskType.week:
        final day = (tick?.infos ?? {})['day'];
        if (day != null) {
          final startHour = tick.infos['startHour'] ?? defaultHour;
          return '$day $startHour';
        }
        return null;

      default:
        throw 'Task type is not valid !';
    }
  }

  String computeRealTaskStartDateTime() => computeRealTaskDateTime('00:00');

  String computeRealTaskEndDateTime() => computeRealTaskDateTime('24:00');

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

  String getEstimateString() {
    return convertDoubleTimeToString(this.estimate);
  }

  String getStartDateDiffText() {
    final now = getNow();
    final realTaskStart = computeRealTaskStartDateTime();

    if (realTaskStart != null)
      return 'شروع : ' + getDiffrenceText(realTaskStart, now);
    return '';
  }

  String getEndDateDiff() {
    final now = getNow();
    final realTaskEnd = computeRealTaskStartDateTime();

    if (realTaskEnd != null)
      return 'پایان : ' + getDiffrenceText(realTaskEnd, now);
    return '';
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
