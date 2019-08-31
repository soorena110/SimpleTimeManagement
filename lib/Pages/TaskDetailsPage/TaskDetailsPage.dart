//import 'package:flutter/material.dart';
//import 'package:flutter_speed_dial/flutter_speed_dial.dart';
//import 'package:time_river/Database/Tables/OnceTaskTable.dart';
//import 'package:time_river/Framework/CircleIcon.dart';
//import 'package:time_river/Framework/InputFields/DateInputField.dart';
//import 'package:time_river/Framework/InputFields/TextInputField.dart';
//import 'package:time_river/Framework/InputFields/TimeInputField.dart';
//import 'package:time_river/Models/OnceTask.dart';
//import 'package:time_river/Pages/AddTaskPage/AddOnceTaskPage.dart';
//import 'package:time_river/Pages/OnceTask/ViewableTaskView.dart';
//
//class TaskDetails extends StatefulWidget {
//  final OnceTask _task;
//
//  const TaskDetails(this._task);
//
//  @override
//  State<StatefulWidget> createState() {
//    return TaskDetailsState();
//  }
//}
//
//class TaskDetailsState extends State<TaskDetails> {
//  TextEditingController tickDescriptionController;
//  TextEditingController tickDateController;
//  TextEditingController tickTimeController;
//  bool _taskIsChanged = false;
//
//  Future<bool> _handlePopScopePop() async {
//    Navigator.pop(context, this._taskIsChanged);
//    return false;
//  }
//
//  _changeTick(TickType tickType) async {
//    final tickDescription = tickDescriptionController.value.text;
//
//    this.setState(() {
//      widget._task.tick = tickType;
//      widget._task.tickDescription =
//      tickDescription != '' ? tickDescription : null;
//      if (widget._task.tick == TickType.postponed) {
//        widget._task.end =
//            tickDateController.value.text + ' ' + tickTimeController.value.text;
//      }
//      _taskIsChanged = true;
//    });
//    OnceTaskTable.insertOrUpdate(widget._task.toJson());
//  }
//
//  RaisedButton _renderTickChangeButton(TickType tickType) {
//    return RaisedButton(
//        textColor: Colors.white,
//        child: Row(
//            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//            children: <Widget>[
//              Icon(TickTypeIcons[tickType]),
//              Text(tickType.toString().split('.')[1])
//            ]),
//        color: TickTypeColors[tickType],
//        onPressed: () {
//          this._changeTick(tickType);
//          Navigator.pop(context);
//        });
//  }
//
//  _resetInputControllers() {
//    if (tickDescriptionController != null) tickDescriptionController.dispose();
//    tickDescriptionController =
//        TextEditingController(text: widget._task.tickDescription);
//    if (tickDateController != null) tickDateController.dispose();
//    tickDateController =
//        TextEditingController(text: widget._task.end.split(' ')[0]);
//    if (tickTimeController != null) tickTimeController.dispose();
//    tickTimeController =
//        TextEditingController(text: widget._task.end.split(' ')[1]);
//  }
//
//  _showChangingTickDialogBox(TickType tick) {
//    this._resetInputControllers();
//
//    final title = Row(
//      children: <Widget>[
//        Text('تغییر تیک'),
//        Expanded(child: Container()),
//        Icon(Icons.arrow_forward),
//        CircleIcon(TickTypeIcons[tick], TickTypeColors[tick])
//      ],
//    );
//
//    showDialog(
//        context: context,
//        builder: (context) {
//          return Directionality(
//              textDirection: TextDirection.rtl,
//              child: SimpleDialog(
//                title: title,
//                contentPadding: const EdgeInsets.all(20),
//                children: <Widget>[
//                  tick == TickType.postponed
//                      ? DateInputField(
//                    'تاریخ تعویق',
//                    controller: tickDateController,
//                  )
//                      : Container(),
//                  tick == TickType.postponed
//                      ? TimeInputField(
//                    'زمان تعویق',
//                    controller: tickTimeController,
//                  )
//                      : Container(),
//                  TextInputField('توضیح تیک',
//                      controller: tickDescriptionController,
//                      minLines: 2,
//                      maxLines: 3),
//                  this._renderTickChangeButton(tick)
//                ],
//              ));
//        });
//  }
//
//  Widget _tickStateFloatingButton() {
//    final availableTicks = TickType.values
//        .where((v) => v != widget._task.tick || v == TickType.postponed);
//
//    final subItems = availableTicks
//        .map((v) =>
//        SpeedDialChild(
//            child: Icon(TickTypeIcons[v]),
//            backgroundColor: OnceTaskTickColors[v],
//            label: v
//                .toString()
//                .split('.')
//                .last,
//            labelStyle: TextStyle(fontSize: 18.0),
//            onTap: () => this._showChangingTickDialogBox(v)))
//        .toList();
//
//    return Directionality(
//        textDirection: TextDirection.ltr,
//        child: SpeedDial(
//          child: Icon(widget._task.getIcon()),
//          backgroundColor: widget._task.getColor(),
//          foregroundColor: Colors.white,
//          marginRight: 35,
//          marginBottom: 35,
//          overlayOpacity: 0,
//          children: subItems,
//        ));
//  }
//
//  _buildFloatingActionButton() {
//    return FloatingActionButton(
//        backgroundColor: widget._task.getColor(),
//        child: Icon(Icons.edit),
//        onPressed: () async {
//          final isChanged = await Navigator.push(context,
//              MaterialPageRoute(builder: (context) {
//                return AddOnceTaskPage(widget._task);
//              }));
//          if (isChanged) setState(() {});
//        });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return WillPopScope(
//        onWillPop: this._handlePopScopePop,
//        child: Directionality(
//            textDirection: TextDirection.rtl,
//            child: Stack(alignment: Alignment.bottomLeft, children: [
//              Scaffold(
//                  appBar: AppBar(
//                      backgroundColor: widget._task.getColor(),
//                      title: Text(widget._task.name)),
//                  body: OnceTaskView(widget._task),
//                  floatingActionButton: this._buildFloatingActionButton()),
//              this._tickStateFloatingButton()
//            ])));
//  }
//}
