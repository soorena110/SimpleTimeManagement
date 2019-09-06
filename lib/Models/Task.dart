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
    if (this.end == null) return false;

    final now = getNow();
    final remainingTime = getDateTimeDiff(this.end, now).inMinutes;
    return remainingTime - (estimate ?? 0) * 60 < 30;
  }

  String getRemainingTime() {
    var ret = this.getEndDateDiff();

    if (this.start != null) {
      final now = getNow();
      if (getDateDiff(this.start, now).inMilliseconds > 0)
        ret = this.getStartDateDiff();
    }
    return ret;
  }

  String getEstimateString() {
    return convertDoubleTimeToString(this.estimate);
  }

  String getStartDateDiff() {
    final now = getNow();
    if (this.start != null) {
      final diff = getDiffrenceText(this.start, now);
      return 'شروع: ' + diff;
    }
    return '';
  }

  String getEndDateDiff() {
    final now = getNow();
    if (this.end != null) {
      final diff = getDiffrenceText(this.end, now);
      return 'پایان: ' + diff;
    }
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
    return '${id ?? name}';
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
