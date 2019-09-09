import 'package:time_river/Database/Tables/Tasks/WeekTaskTable.dart';
import 'package:time_river/Database/Tables/Ticks/WeekTaskTick.dart';
import 'package:time_river/Libraries/datetime.dart';
import 'package:time_river/Models/Task.dart';
import 'package:time_river/Models/Tick.dart';

import 'common.dart';

class WeekTaskService {
  static Future<Iterable<Task>> getAllWeekTasksWithTheirVirtualTicks(
      {String fromDate, String toDate}) async {
    final tasks = (await weekTaskTable.query(
            fromDate: fromDate, toDate: toDate, lastUpdateOrderAsc: true))
        .toList();

    return await _joinTasksToTheirVirtualWeekTicks(tasks,
        fromDate: fromDate, toDate: toDate);
  }

  static Future<Iterable<Task>> getAllWeekTasksWithTheirTicks() async {
    final tasks = (await weekTaskTable.query()).toList();

    final ticksDict = <int, Tick>{};
    final ticks = await weekTaskTickTable.queryForTaskIdAndTypeAndDay(
        taskIds: tasks.map((r) => r.id));
    ticks.forEach((tick) => ticksDict[tick.taskId] = tick);

    tasks.forEach((task) {
      task.type = TaskType.week;
      task.tick = ticksDict[task.id];
    });

    return tasks;
  }
}

Future<List<Task>> _joinTasksToTheirVirtualWeekTicks(List<Task> tasks,
    {List<TickType> tickType, String fromDate, String toDate}) async {
  final ticks = await weekTaskTickTable.queryForTaskIdAndTypeAndDay(
      taskIds: tasks.map((r) => r.id), types: tickType);

  final ticksDict = groupTicks(ticks);

  final ret = <Task>[];
  tasks.forEach((task) {
    task.type = TaskType.week;

    final tickList = ticksDict[task.id];

    for (int i = -6; i <= 6; i++) {
      final newTask = getTickOfDayIfExists(i, task, tickList,
          fromDateTime: fromDate, toDateTime: toDate);
      if (newTask != null) ret.add(newTask);
    }
  });

  return ret;
}

getTickOfDayIfExists(int addingDay, Task task, List<Tick> tickList,
    {String fromDateTime, String toDateTime}) {
  final theDay = DateTime.now().add(Duration(days: addingDay));
  final weekDayNumber = (theDay.weekday + 1) % 7;
  final weekDayBit = 1 << weekDayNumber;
  final weekDays = task.infos['weekdays'];
  if (weekDays & weekDayBit == 0) return null;

  final jalaliDay = getJalaliOf(theDay);
  if (compareDate(jalaliDay, toDateTime) == 1) return null;
  if (compareDate(jalaliDay, fromDateTime) == -1) return null;

  final ticksOfPrevDays =
  tickList?.where((r) => r.infos['day'] == jalaliDay)?.toList();

  final newTask = cloneTask(task);
  newTask.tick = (ticksOfPrevDays?.length ?? 0) > 0
      ? ticksOfPrevDays[0]
      : Tick(taskId: task.id, infos: {'day': jalaliDay}, taskType: task.type);

  return newTask;
}
