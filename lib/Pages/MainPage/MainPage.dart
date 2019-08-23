import 'dart:io';

import 'package:flutter/material.dart';
import 'package:time_river/Libraries/datetime.dart';

import 'MainPageDailyTasks.dart';
import '_Drawer.dart';

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
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  _getBackgroundColor() {
    return this._isCritical ? Colors.orange : Colors.lightGreen[200];
  }

  Future<bool> _handlePopScopePop() async {
    return await showDialog(
        context: context,
        builder: (context) =>
            Directionality(
                textDirection: TextDirection.rtl,
                child: AlertDialog(
                    title: Text('خروج ??!'),
                    content: Text('آیا میخواهید خارج شوید ??'),
                actions: <Widget>[
                  FlatButton(
                      child: Text('بله',
                          style: TextStyle(color: Colors.orangeAccent)),
                      onPressed: () {
                        exit(0);
                      }),
                  FlatButton(
                      child: Text('خیر'),
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ])));
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
    return NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: this._getBackgroundColor(),
              title: Text('Time is a river with many eddies',
                  style: TextStyle(fontSize: 18),
                  textDirection: TextDirection.ltr),
              pinned: true,
              floating: true,
              bottom: TabBar(
                  indicatorColor: Colors.white,
                  controller: this._tabController,
                  tabs: [
                    Column(
                      children: <Widget>[
                        Icon(Icons.calendar_today),
                        Text('امروز')
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Icon(Icons.calendar_today),
                        Text('فردا')
                      ],
                    ),
                    Column(
                      children: <Widget>[Icon(Icons.date_range), Text('هفته')],
                    )
                  ]),
            ),
          ];
        },
        body: TabBarView(controller: this._tabController, children: [
          this._getTodayView(),
          this._getTomorrowView(),
          this._getCurrentWeekView()
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _handlePopScopePop,
        child: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
                body: this._buildBody(),
                endDrawer: getMainPageDrawer(context))));
  }
}
