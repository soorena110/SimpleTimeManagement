import 'dart:io';

import 'package:flutter/material.dart';

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
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  _getBackgroundColor() {
    return this._isCritical ? Colors.orange : Colors.lightGreen[200];
  }

  Future<bool> _handlePopScopePop() {
    return showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
                title: Text('Exit ??!'),
                content: Text('Wanna Exit ??'),
                actions: <Widget>[
                  FlatButton(
                      child: Text('Yes',
                          style: TextStyle(color: Colors.orangeAccent)),
                      onPressed: () {
                        exit(0);
                      }),
                  FlatButton(
                      child: Text('No'),
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ]));
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
              title: Text('Time is a river with many eddies'),
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
                    ),
                    Column(
                      children: <Widget>[Icon(Icons.alarm), Text('')],
                    )
                  ]),
            ),
          ];
        },
        body: TabBarView(controller: this._tabController, children: [
          MainPageDailyTasks(this._handleStateChange),
          Text('hellow !!'),
          Text('hellow !!'),
          Text('hellow !!')
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _handlePopScopePop,
        child: Scaffold(body: this._buildBody()));
  }
}
