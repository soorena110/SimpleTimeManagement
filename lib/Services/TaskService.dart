import 'package:time_river/Database/Tables/Tasks/MonthTaskTable.dart';
import 'package:time_river/Database/Tables/Tasks/OnceTaskTable.dart';
import 'package:time_river/Database/Tables/Tasks/WeekTaskTable.dart';
import 'package:time_river/Database/Tables/Ticks/MonthTaskTick.dart';
import 'package:time_river/Database/Tables/Ticks/OnceTaskTick.dart';
import 'package:time_river/Database/Tables/Ticks/WeekTaskTick.dart';
import 'package:time_river/Libraries/datetime.dart';
import 'package:time_river/Models/Task.dart';
import 'package:time_river/Models/Tick.dart';
import 'package:time_river/Services/OnceTaskService.dart';
import 'package:time_river/Services/WeekTaskService.dart';

import 'MonthTaskService.dart';
import 'common.dart';

class TaskService {
  static void Function() onChanged;

  static deleteTask(Task task) async {
    await getRelatedRepositoryOfType(task.type).delete(task.id);
    await getRelatedTickRepositoryOfType(task.type).deleteForTaskId(task.id);

    if (TaskService.onChanged != null) TaskService.onChanged();
  }

  static saveTask(Task task) async {
    final relatedTaskTable = getRelatedRepositoryOfType(task.type);
    relatedTaskTable.insertOrUpdate(task.toJson());

    if (TaskService.onChanged != null) TaskService.onChanged();
  }

  static saveTick(Tick tick) async {
    final relatedTickTable = getRelatedTickRepositoryOfType(tick.taskType);
    tick.id = await relatedTickTable.insertOrUpdate(tick.toJson());

    if (TaskService.onChanged != null) TaskService.onChanged();
  }


  static Future<Iterable<Task>> getAllTasksUpdatedAfter(
      String lastUpdate) async {
    return [
      ...await onceTaskTable.getAllTasksUpdatedAfter(lastUpdate),
      ...await weekTaskTable.getAllTasksUpdatedAfter(lastUpdate),
      ...await monthTaskTable.getAllTasksUpdatedAfter(lastUpdate),
    ];
  }

  static Future<Iterable<Task>> getAllTicksUpdatedAfter(
      String lastUpdate) async {
    return [
      ...await onceTaskTickTable.getAllTicksUpdatedAfter(lastUpdate),
      ...await weekTaskTickTable.getAllTicksUpdatedAfter(lastUpdate),
      ...await monthTaskTickTable.getAllTicksUpdatedAfter(lastUpdate),
    ];
  }

  static Future<Iterable<Task>> getTodayTasks() {
    final today = getNowDate();
    return getTaskWhere(fromDate: '$today 00:00', toDate: '$today 24:00');
  }

  static Future<Iterable<Task>> getTaskWhere({String fromDate, String toDate}) async {
    final onceTasks = await OnceTaskService.getOnceTasksWithTheirTicks(
        fromDateTime: fromDate, toDateTime: toDate);

    final monthTask =
    await MonthTaskService.getAllMonthTasksWithTheirVirtualTicks(
        fromDateTime: fromDate, toDateTime: toDate);

    final weekTask = await WeekTaskService.getAllWeekTasksWithTheirVirtualTicks(
        fromDate: fromDate, toDate: toDate);

    return [...onceTasks, ...monthTask, ...weekTask];
  }

  static Future<Iterable<Task>> getAllTasksOfType(TaskType type) {
    switch (type) {
      case TaskType.once:
        return OnceTaskService.getOnceTasksWithTheirTicks();
      case TaskType.week:
        return WeekTaskService.getAllWeekTasksWithTheirTicks();
      case TaskType.month:
        return MonthTaskService.getAllMonthTasksWithTheirTicks();
      default:
        throw 'Exhuastive check';
    }
  }
}
