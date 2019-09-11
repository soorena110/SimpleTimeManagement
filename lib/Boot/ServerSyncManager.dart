import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_river/Services/TaskService.dart';

class ServerSyncManager {
  static String lastSyncDateTime;

  static getLastSyncDateTime() async {
    if (lastSyncDateTime == null) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      lastSyncDateTime =
          pref.getString('lastSyncDateTime') ?? '1398/06/01 00:00';
    }
    return lastSyncDateTime;
  }

  static setLastSyncDateTime(String dateTime) async {
    if (dateTime == lastSyncDateTime) return true;

    SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.setString('lastSyncDateTime', dateTime);
  }

  static sync() async {
    final lastUpdate = getLastSyncDateTime();

    final tasks = TaskService.getAllTasksUpdatedAfter(lastUpdate);
    await http.post('http://time.sainapedia.ir/tasks', body: {'tasks': tasks});

    final ticks = TaskService.getAllTicksUpdatedAfter(lastUpdate);
    await http.post('http://time.sainapedia.ir/ticks', body: {'tasks': ticks});

    final taskHttpResponse = await http
        .get('http://time.sainapedia.ir/tasks?fromLastUpdate=$lastUpdate');
    final fetchedTasks = json.decode(taskHttpResponse.body);

    final tickHttpResponse = await http
        .get('http://time.sainapedia.ir/ticks?fromLastUpdate=$lastUpdate');
    final fetchedTicks = json.decode(tickHttpResponse.body);

//    await setLastSyncDateTime(getNow());
  }
}
