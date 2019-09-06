import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:time_river/Framework/CircleIcon.dart';
import 'package:time_river/Framework/InputFields/DateInputField.dart';
import 'package:time_river/Framework/InputFields/TextInputField.dart';
import 'package:time_river/Framework/InputFields/TimeInputField.dart';
import 'package:time_river/Models/Task.dart';
import 'package:time_river/Models/Tick.dart';
import 'package:time_river/Pages/AddTaskPage/AddTaskPage.dart';
import 'package:time_river/Pages/TaskDetailsPage/ViewableTaskView.dart';
import 'package:time_river/Services/TaskService.dart';
import 'package:time_river/Services/methods.dart';

final defaultTick = Tick(type: TickType.todo);

class TaskDetailsPage extends StatefulWidget {
  final Task task;

  const TaskDetailsPage(this.task);

  @override
  State<StatefulWidget> createState() {
    return TaskDetailsPageState();
  }
}

class TaskDetailsPageState extends State<TaskDetailsPage> {
  TextEditingController tickDescriptionController;
  TextEditingController tickDateController;
  TextEditingController tickTimeController;
  bool _taskIsChanged = false;

  Future<bool> _handlePopScopePop() async {
    Navigator.pop(context, this._taskIsChanged);
    return false;
  }

  _changeTick(TickType tickType) async {
    final tickDescription = tickDescriptionController.value.text;

    if (widget.task.tick == null)
      widget.task.tick =
          Tick(taskType: widget.task.type, taskId: widget.task.id);

    this.setState(() {
      widget.task.tick.type = tickType;
      widget.task.tick.description =
          tickDescription != '' ? tickDescription : null;

      if (widget.task.tick.type == TickType.postponed) {
        widget.task.end =
            tickDateController.value.text + ' ' + tickTimeController.value.text;
      }

      _taskIsChanged = true;
    });

    TaskService.saveTick(widget.task.tick);
  }

  RaisedButton _renderTickChangeButton(TickType tickType) {
    return RaisedButton(
        textColor: Colors.white,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(TickIcons[tickType]),
              Text(tickType.toString().split('.')[1])
            ]),
        color: TickColors[tickType],
        onPressed: () {
          this._changeTick(tickType);
          Navigator.pop(context);
        });
  }

  _resetInputControllers() {
    if (tickDescriptionController != null) tickDescriptionController.dispose();
    tickDescriptionController =
        TextEditingController(text: widget.task.tick?.description);
    if (tickDateController != null) tickDateController.dispose();
    tickDateController =
        TextEditingController(text: (widget.task.end?.split(' ') ?? [''])[0]);
    if (tickTimeController != null) tickTimeController.dispose();
    tickTimeController = TextEditingController(
        text: (widget.task.end?.split(' ') ?? ['', ''])[1]);
  }

  _showChangingTickDialogBox(TickType tick) {
    this._resetInputControllers();

    final title = Row(
      children: <Widget>[
        Text('تغییر تیک'),
        Expanded(child: Container()),
        Icon(Icons.arrow_forward),
        CircleIcon(TickIcons[tick], TickColors[tick])
      ],
    );

    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: title,
            contentPadding: const EdgeInsets.all(20),
            children: <Widget>[
              tick == TickType.postponed
                  ? DateInputField(
                      'تاریخ تعویق',
                      controller: tickDateController,
                    )
                  : Container(),
              tick == TickType.postponed
                  ? TimeInputField(
                      'زمان تعویق',
                      controller: tickTimeController,
                    )
                  : Container(),
              TextInputField('توضیح تیک',
                  controller: tickDescriptionController,
                  minLines: 2,
                  maxLines: 3),
              this._renderTickChangeButton(tick)
            ],
          );
        });
  }

  Widget _buildFloatingActionButton() {
    final tick = widget.task.tick ?? defaultTick;
    final availableTicks = TickType.values
        .where((v) => v != tick.type || v == TickType.postponed)
        .where((v) => v != TickType.postponed || widget.task.end != null);

    final subItems = availableTicks
        .map((v) => SpeedDialChild(
        child: Icon(TickIcons[v]),
        backgroundColor: TickColors[v],
        label: v.toString().split('.').last,
        labelStyle: TextStyle(fontSize: 18.0),
        onTap: () => this._showChangingTickDialogBox(v)))
        .toList();

    return Directionality(
        textDirection: TextDirection.ltr,
        child: SpeedDial(
          child: Icon(tick.getIcon()),
          backgroundColor: tick.getColor(),
          foregroundColor: Colors.white,
          marginRight: 35,
          marginBottom: 35,
          overlayOpacity: 0,
          children: subItems,
        ));
  }

  _buildAppBar() {
    final tick = widget.task.tick ?? defaultTick;
    return AppBar(
      backgroundColor: tick.getColor(),
      title: Text(widget.task.name),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              final isChanged = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                    return AddTaskPage(task: widget.task);
                  }));
              if (isChanged != null && isChanged) setState(() {});
            }),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) =>
                    AlertDialog(
                      title:
                      Text('آیا مطمئنید میخواهید این آیتم را حذف کنید ؟'),
                      actions: <Widget>[
                        FlatButton(
                            child: Text('خیر'),
                            onPressed: () => Navigator.pop(context)),
                        FlatButton(
                            child: Text('بله',
                                style: TextStyle(color: Colors.orange)),
                            onPressed: () async {
                              await getRelatedRepositoryOfType(widget.task.type)
                                  .delete(widget.task.id);
                              Navigator.pop(context);
                              Navigator.pop(context, true);
                            }),
                      ],
                    ));
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: this._handlePopScopePop,
      child: Scaffold(
          appBar: _buildAppBar(),
          body: ViewableTaskView(widget.task),
          floatingActionButton: this._buildFloatingActionButton()),
    );
  }
}
