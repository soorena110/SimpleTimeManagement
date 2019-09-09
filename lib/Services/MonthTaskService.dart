import 'package:time_river/Database/Tables/Tasks/MonthTaskTable.dart';
import 'package:time_river/Database/Tables/Ticks/MonthTaskTick.dart';
import 'package:time_river/Libraries/datetime.dart';
import 'package:time_river/Models/Task.dart';
import 'package:time_river/Models/Tick.dart';

import 'common.dart';

class MonthTaskService {
  static Future<Iterable<Task>> getAllMonthTasksWithTheirVirtualTicks(
      {String fromDate, String toDate}) async {
    final tasks = (await monthTaskTable.query(
            fromDate: fromDate, toDate: toDate, lastUpdateOrderAsc: true))
        .toList();

    return await _joinTasksToTheirVirtualMonthTicks(tasks);
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
    {List<TickType> tickType}) async {
  final taskIds = tasks.map((r) => r.id);
  final ticks = await monthTaskTickTable.queryForTaskIdAndTypeAndDay(
      taskIds: taskIds, types: tickType);

  final ticksDict = groupTicks(ticks);

  final todayParts = getNowDate().split('/');
  final todayMonthDay = int.parse(todayParts[2]);
  final currentMonth = '${todayParts[0]}/${todayParts[1]}';

  final oneMonthAgoParts =
      getJalaliOf(DateTime.now().add(Duration(days: -30))).split('/');
  final prevMonth = '${oneMonthAgoParts[0]}/${oneMonthAgoParts[1]}';

  final ret = <Task>[];
  tasks.forEach((task) {
    task.type = TaskType.month;

    final ticks = ticksDict[task.id];
    final taskDay = task.infos['dayOfMonth'];

    if (taskDay <= todayMonthDay) {
      final newTask = cloneTask(task);
      final ticksOfPrevMonth =
          ticks?.where((r) => r.infos['month'] == currentMonth)?.toList();
      newTask.tick = (ticksOfPrevMonth?.length ?? 0) > 0
          ? ticksOfPrevMonth[0]
          : Tick(
              taskId: task.id,
              infos: {'month': currentMonth},
              taskType: TaskType.month);
      ret.add(newTask);
    }

    if (task.start == null ||
        compareDateTime(task.start,
                '$prevMonth/$taskDay ${task.infos['startHour'] ?? '24:00'}') >
            0) {
      final ticksOfPrevMonth =
          ticks?.where((r) => r.infos['month'] == prevMonth)?.toList();
      task.tick = (ticksOfPrevMonth?.length ?? 0) > 0
          ? ticksOfPrevMonth[0]
          : Tick(
              taskId: task.id,
              infos: {'month': prevMonth},
              taskType: TaskType.month);
      ret.add(task);
    }
  });

  return ret;
}
