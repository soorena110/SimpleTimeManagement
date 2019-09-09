import 'package:time_river/Database/Tables/Tasks/MonthTaskTable.dart';
import 'package:time_river/Database/Tables/Ticks/MonthTaskTick.dart';
import 'package:time_river/Libraries/datetime.dart';
import 'package:time_river/Models/Task.dart';
import 'package:time_river/Models/Tick.dart';

import 'common.dart';

class MonthTaskService {
  static Future<Iterable<Task>> getAllMonthTasksWithTheirVirtualTicks(
      {String fromDateTime, String toDateTime}) async {
    final tasks = (await monthTaskTable.query(
        fromDate: fromDateTime,
        toDate: toDateTime,
        lastUpdateOrderAsc: true))
        .toList();

    return await _joinTasksToTheirVirtualMonthTicks(tasks,
        fromDateTime: fromDateTime, toDateTime: toDateTime);
  }

  static Future<Iterable<Task>> getAllMonthTasksWithTheirTicks() async {
    final tasks = (await monthTaskTable.query()).toList();

    final ticksDict = <int, Tick>{};
    final ticks = await monthTaskTickTable.queryForTaskIdAndTypeAndDay(
        taskIds: tasks.map((r) => r.id));
    ticks.forEach((tick) => ticksDict[tick.taskId] = tick);

    tasks.forEach((task) {
      task.type = TaskType.month;
      task.tick = ticksDict[task.id];
    });

    return tasks;
  }
}

Future<List<Task>> _joinTasksToTheirVirtualMonthTicks(List<Task> tasks,
    {List<TickType> tickType, String fromDateTime, String toDateTime}) async {
  final taskIds = tasks.map((r) => r.id);
  final ticks = await monthTaskTickTable.queryForTaskIdAndTypeAndDay(
      taskIds: taskIds, types: tickType);

  final ticksDict = groupTicks(ticks);

  final ret = <Task>[];
  tasks.forEach((task) {
    task.type = TaskType.month;

    final tickList = ticksDict[task.id];

    for (int i = -1; i <= 1; i++) {
      final newTask = getTickOfMonthIfExists(i, task, tickList,
          fromDateTime: fromDateTime, toDateTime: toDateTime);
      if (newTask != null) ret.add(newTask);
    }
  });

  return ret;
}

getTickOfMonthIfExists(int addingMonth, Task task, List<Tick> tickList,
    {String fromDateTime, String toDateTime}) {
  final jalaliDayParts =
  getJalaliOf(DateTime.now().add(Duration(days: addingMonth * 30))).split('/');

  final dayOfMonth = task.infos['dayOfMonth'];
  final theMonth = '${jalaliDayParts[0]}/${jalaliDayParts[1]}';
  final theDay = '$theMonth/$dayOfMonth';

  if (compareDate(theDay, toDateTime) == 1) return null;
  if (compareDate(theDay, fromDateTime) == -1) return null;


  final newTask = cloneTask(task);
  final ticksOfTheMonth =
  tickList?.where((r) => r.infos['month'] == theMonth)?.toList();

  newTask.tick = (ticksOfTheMonth?.length ?? 0) > 0
      ? ticksOfTheMonth[0]
      : Tick(
      taskId: task.id,
      infos: {'month': theMonth},
      taskType: TaskType.month);

  return newTask;
}
