import 'package:time_river/Database/Tables/Tasks/MonthTaskTable.dart';
import 'package:time_river/Database/Tables/Tasks/OnceTaskTable.dart';
import 'package:time_river/Database/Tables/Tasks/TaskBaseTable.dart';
import 'package:time_river/Database/Tables/Tasks/WeekTaskTable.dart';
import 'package:time_river/Models/Task.dart';

TaskBaseTable getRelatedRepositoryOfType(TaskType type) {
  switch (type) {
    case TaskType.once:
      return onceTaskTable;
    case TaskType.week:
      return weekTaskTable;
    case TaskType.month:
      return monthTaskTable;
  }
  return null;
}
