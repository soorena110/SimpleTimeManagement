import 'package:time_river/Models/ViewableTask.dart';

import 'MonthTaskTable.dart';
import 'OnceTaskTable.dart';
import 'TaskBaseTable.dart';
import 'WeekTaskTable.dart';

TaskBaseTable getRelatedRepositoryOfType(ViewableTaskType type) {
  switch (type) {
    case ViewableTaskType.once:
      return onceTaskTable;
    case ViewableTaskType.week:
      return weekTaskTable;
    case ViewableTaskType.month:
      return monthTaskTable;
  }
  return null;
}
