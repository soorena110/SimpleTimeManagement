import 'package:flutter/material.dart';
import 'package:time_river/Libraries/datetime.dart';
import 'package:time_river/Models/Task.dart';
import 'package:time_river/Pages/AddTaskPage/AddTaskPage.dart';

import 'MainPageDailyTasks.dart';
import '_appBar.dart';
import '_drawer.dart';

class MainPage extends StatefulWidget {
  MainPage();

  @override
  State<StatefulWidget> createState() {
    return new MainPageState();
  }
}

class MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  bool _isCritical = false;

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
        onStateChanged: this._handleStateChange, start: start, end: end);
  }

  _getTomorrowView() {
    final tomorrow = getJalaliOf(DateTime.now().add(Duration(days: 1)));
    final start = '$tomorrow 00:00';
    final end = '$tomorrow 24:00';

    return MainPageDailyTasks(
        onStateChanged: this._handleStateChange, start: start, end: end);
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
        onStateChanged: this._handleStateChange, start: start, end: end);
  }

  _buildBody() {
    return this._getTodayView();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildMainPageAppBar(),
        body: this._buildBody(),
        endDrawer: getMainPageDrawer(context),
        floatingActionButton: _buildFloatingActionButton());
  }
}
