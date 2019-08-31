import 'package:time_river/Libraries/datetime.dart';

import 'TaskBase.dart';
import 'Tick.dart';

enum ViewableTaskType { once, week, month }

class ViewableTask extends TaskBase {
  ViewableTaskType type;
  Map<String, dynamic> infos;
  Tick tick;

  ViewableTask(int id, String name, String start, String end,
      String description, double estimate, String lastUpdate,
      [this.type, this.infos = const <String, dynamic>{}, this.tick])
      : super(id, name, start, end, description, estimate, lastUpdate);

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
}