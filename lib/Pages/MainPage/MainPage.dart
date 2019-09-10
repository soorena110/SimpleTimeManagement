import 'package:flutter/material.dart';
import 'package:time_river/Libraries/datetime.dart';
import 'package:time_river/Models/Task.dart';
import 'package:time_river/Pages/AddTaskPage/AddTaskPage.dart';

import 'MainPageDailyTasks.dart';
import '_drawer.dart';

enum _PresetDateRanges { today, tomorrow, week }

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MainPageState();
  }
}

class MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  bool _isCritical = false;
  bool _showDoneOrCanceled = false;
  _PresetDateRanges _dateRange = _PresetDateRanges.today;

  _getBackgroundColor() {
    return this._isCritical ? Colors.orange : null;
  }

  _handleStateChange(bool isCritical) {
    setState(() {
      this._isCritical = isCritical;
    });
  }

  _getTodayView() {
    final today = getNowDate();
    final start = '$today 00:00';
    final end = '$today 24:00';

    return MainPageDailyTasks(
        showDoneOrCanceled: _showDoneOrCanceled,
        onStateChanged: this._handleStateChange,
        start: start,
        end: end);
  }

  _getTomorrowView() {
    final tomorrow = getJalaliOf(DateTime.now().add(Duration(days: 1)));
    final start = '$tomorrow 00:00';
    final end = '$tomorrow 24:00';

    return MainPageDailyTasks(
        showDoneOrCanceled: _showDoneOrCanceled,
        onStateChanged: this._handleStateChange,
        start: start,
        end: end);
  }

  _getCurrentWeekView() {
    final now = DateTime.now();
    final currentWeekDay = (now.weekday + 1) % 7;

    final saturday =
        getJalaliOf(DateTime.now().add(Duration(days: -currentWeekDay)));
    final start = '$saturday 00:00';

    final friday =
        getJalaliOf(DateTime.now().add(Duration(days: 6 - currentWeekDay)));
    final end = '$friday 24:00';

    return MainPageDailyTasks(
        showDoneOrCanceled: _showDoneOrCanceled,
        onStateChanged: this._handleStateChange,
        start: start,
        end: end,
        filterTaskTypes: [TaskType.once, TaskType.month]);
  }

  String _getTitle() {
    switch (_dateRange) {
      case _PresetDateRanges.today:
        return 'تسک‌های امروز';
      case _PresetDateRanges.tomorrow:
        return 'تسک‌های فردا';
      case _PresetDateRanges.week:
        return 'تسک‌های این هفته';
      default:
        throw 'Exhaustive Check !';
    }
  }

  _buildBody() {
    switch (_dateRange) {
      case _PresetDateRanges.today:
        return this._getTodayView();
      case _PresetDateRanges.tomorrow:
        return this._getTomorrowView();
      case _PresetDateRanges.week:
        return this._getCurrentWeekView();
      default:
        throw 'Exhaustive Check !';
    }
  }

  _buildFloatingActionButton() {
    return FloatingActionButton(
        backgroundColor: this._getBackgroundColor(),
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddTaskPage(taskType: TaskType.once);
          }));
        });
  }

  _buildMainPageAppBar() {
    return AppBar(
      title: Text(_getTitle()),
      backgroundColor: this._getBackgroundColor(),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.calendar_today),
          onPressed: () {
            setState(() {
              final enums = _PresetDateRanges.values;
              _dateRange =
              enums[(enums.indexOf(_dateRange) + 1) % enums.length];
            });
          },
        ),
        IconButton(
          icon: Icon(
              _showDoneOrCanceled ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              _showDoneOrCanceled = !_showDoneOrCanceled;
            });
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildMainPageAppBar(),
        body: this._buildBody(),
        drawer: getMainPageDrawer(context),
        floatingActionButton: _buildFloatingActionButton());
  }
}
