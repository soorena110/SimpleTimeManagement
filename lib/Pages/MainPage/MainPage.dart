import 'dart:io';

import 'package:flutter/material.dart';
import 'package:time_river/Framework/CircleIcon.dart';
import 'package:time_river/Pages/AllOnceTasksPage/AllOnceTasksPage.dart';

import 'MainPageDailyTasks.dart';

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

  _buildDrawer() {
    return Drawer(
      child: ListView(children: [
        ListTile(
          title: Text('همه تسک‌های تکی'),
          leading: CircleIcon(Icons.done_all, Colors.pinkAccent),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AllOnceTasksPage()));
          },
        )
      ]),
    );
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

  _buildBody() {
    return NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: this._getBackgroundColor(),
              title: Text('Time is a river with many eddies',
                  style: TextStyle(fontSize: 15)),
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
          MainPageDailyTasks(this._handleStateChange),
          Text('hellow !!'),
          Text('hellow !!')
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _handlePopScopePop,
        child:
        Scaffold(body: this._buildBody(), endDrawer: this._buildDrawer()));
  }
}
