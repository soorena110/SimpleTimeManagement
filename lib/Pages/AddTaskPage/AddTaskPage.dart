import 'package:flutter/material.dart';
import 'package:time_river/Framework/InputFields/CheckBoxList.dart';
import 'package:time_river/Framework/InputFields/DateInputField.dart';
import 'package:time_river/Framework/InputFields/NumberInputField.dart';
import 'package:time_river/Framework/InputFields/TextInputField.dart';
import 'package:time_river/Framework/InputFields/TimeInputField.dart';
import 'package:time_river/Libraries/datetime.dart';
import 'package:time_river/Models/Task.dart';
import 'package:time_river/Services/TaskService.dart';

class AddTaskPage extends StatefulWidget {
  final Task task;

  AddTaskPage({Task task, TaskType taskType})
      : this.task = task ?? Task(type: taskType, infos: <String, dynamic>{}) {
    if (task == null && taskType == null)
      throw 'Both task and taskType is empty, one of them must be filled.';
  }

  @override
  State<StatefulWidget> createState() {
    return AddTaskPageState();
  }
}

class AddTaskPageState extends State<AddTaskPage> {
  final _scafold = GlobalKey<ScaffoldState>();

  TextEditingController _nameController;
  TextEditingController _descriptionController;
  TextEditingController _startDateController;
  TextEditingController _startTimeController;
  TextEditingController _endDateController;
  TextEditingController _endTimeController;
  TextEditingController _estimateController;

  TextEditingController _week_weekdaysController;
  TextEditingController _weekOrMonth_startHourController;
  TextEditingController _weekOrMonth_endHourController;
  TextEditingController _month_dayController;

  @override
  void initState() {
    super.initState();

    final t = widget.task;
    _nameController = TextEditingController(text: t == null ? null : t.name);
    _descriptionController = TextEditingController(text: t?.description ?? '');

    if ([TaskType.month, TaskType.week].contains(t.type) && t.start == null)
      t.start = getNow();

    _startDateController =
        TextEditingController(text: t.start
            ?.split(' ')
            ?.first ?? '');
    _startTimeController =
        TextEditingController(text: t.start
            ?.split(' ')
            ?.last ?? '00:00');
    _endDateController =
        TextEditingController(text: t.end
            ?.split(' ')
            ?.first ?? '');
    _endTimeController =
        TextEditingController(text: t.end
            ?.split(' ')
            ?.last ?? '24:00');
    _estimateController = TextEditingController(
        text: convertDoubleTimeToString(t.estimate) ?? '');

    _week_weekdaysController =
        TextEditingController(text: t.infos['weekdays']?.toString() ?? '0');

    _weekOrMonth_startHourController =
        TextEditingController(text: t.infos['startHour'] ?? '');
    _weekOrMonth_endHourController =
        TextEditingController(text: t.infos['endHour'] ?? '');

    _month_dayController = TextEditingController(
        text:
        (t.infos == null ? '1' : t.infos['monthday']?.toString()) ?? '1');

    _startDateController.addListener(() => setState(() {}));
    _endDateController.addListener(() => setState(() {}));
  }

  _validateJsonTask() {
    if (widget.task.name == null || widget.task.name.length < 4)
      return 'نام تسک حداقل باید 4 کاراکتر باشد.';

    if (widget.task.start != null &&
        widget.task.end != null &&
        compareDateTime(widget.task.start, widget.task.end) > 0)
      return 'تاریخ شروع باید کوچکتر از تاریخ پایان باشد.';

    if (widget.task.start != null &&
        compareDateTime(widget.task.start, getNow()) > 1)
      return 'تاریخ شروع باید بیشتر از زمان حال باشد.';

    if (widget.task.end != null &&
        compareDateTime(widget.task.end, getNow()) > 1)
      return 'تاریخ پایان باید بیشتر از زمان حال باشد.';

    if (widget.task.type == TaskType.month) {
      if (widget.task.infos == null || widget.task.infos['monthday'] == null)
        return 'روز ماه تعیین نشده است.';
      final value = int.tryParse(widget.task.infos['monthday']);
      if (value == null || value < 1 || value > 31)
        return 'روز ماه باید از 1 تا 31 باشد.';
    }

    if (widget.task.type == TaskType.week) {
      if (widget.task.infos == null || widget.task.infos['weekdays'] == 0)
        return 'حداقل یک روز هفته باید تعیین شده باشد.';
    }

    return null;
  }

  _computeEnd() {
    final date = _endDateController.text;
    var time = _endTimeController.text;
    if (date == '') return null;
    if (time == '') time = '24:00';
    return '$date $time';
  }

  _computeStart() {
    final date = _startDateController.text;
    var time = _startTimeController.text;
    if (date == '') return null;
    if (time == '') time = '00:00';
    return '$date $time';
  }

  _submit() async {
    widget.task.name = _nameController.text;
    widget.task.start = this._computeStart();
    widget.task.end = this._computeEnd();
    if (_estimateController.text != null && _estimateController.text != '')
      widget.task.estimate =
          convertStringTimeToDouble(_estimateController.text);
    widget.task.description = _descriptionController.text;
    widget.task.infos = {};

    if (widget.task.type == TaskType.month && _month_dayController.text != null)
      widget.task.infos['monthday'] = _month_dayController.text;
    if (widget.task.type == TaskType.month ||
        widget.task.type == TaskType.week) {
      if (_weekOrMonth_startHourController.text != null)
        widget.task.infos['startHour'] = _weekOrMonth_startHourController.text;
      if (_weekOrMonth_endHourController.text != null)
        widget.task.infos['endHour'] = _weekOrMonth_endHourController.text;
    }
    if (widget.task.type == TaskType.week &&
        _week_weekdaysController.text != null)
      widget.task.infos['weekdays'] = int.parse(_week_weekdaysController.text);

    final error = this._validateJsonTask();
    if (error != null) {
      _scafold.currentState.showSnackBar(
          SnackBar(backgroundColor: Colors.red, content: Text(error)));
      return;
    }

    await TaskService.saveTask(widget.task);
    Navigator.pop(context, true);
    _scafold.currentState.showSnackBar(SnackBar(
        backgroundColor: Colors.green, content: Text('با موفیت ثبت شد.')));
  }

  List<Widget> _buildTaskBaseFields(context) {
    return [
      TextInputField('عنوان', controller: this._nameController),
      DateInputField('تاریخ شروع', controller: this._startDateController),
      this._startDateController.text != ''
          ? TimeInputField('ساعت شروع', controller: this._startTimeController)
          : Container(),
      DateInputField('تاریخ پایان', controller: this._endDateController),
      this._endDateController.text != ''
          ? TimeInputField('ساعت پایان', controller: this._endTimeController)
          : Container(),
      TimeInputField('تعداد ساعات', controller: this._estimateController),
      TextInputField('توضیح', controller: this._descriptionController)
    ];
  }

  List<Widget> _buildSpecialFields() {
    switch (widget.task.type) {
      case TaskType.once:
        return [];
      case TaskType.week:
        return [
          TimeInputField('ساعت شروع اجرا',
              controller: this._weekOrMonth_startHourController),
          TimeInputField('ساعت پایان اجرا',
              controller: this._weekOrMonth_endHourController),
          CheckBoxList(
              label: 'روز',
              controller: this._week_weekdaysController,
              titles: weekDayNames)
        ];
      case TaskType.month:
        return [
          NumberInputField(
            'روز ماه',
            controller: this._month_dayController,
            minValue: 1,
            maxValue: 31,
          ),
          TimeInputField('ساعت شروع اجرا',
              controller: this._weekOrMonth_startHourController),
          TimeInputField('ساعت پایان اجرا',
              controller: this._weekOrMonth_endHourController),
        ];
    }
    return [];
  }

  _buildBodyContent() {
    return Builder(
        builder: ((context) => Column(children: [
          ..._buildTaskBaseFields(context),
          ..._buildSpecialFields(),
        ])));
  }

  _buildAppBarTaskTypeChangeIcon() {
    if (widget.task.id != null) return Container();
    return IconButton(
        icon: Icon(Icons.calendar_today),
        onPressed: () {
          setState(() {
            final enums = TaskType.values;
            Navigator.pushReplacement(
                (context),
                MaterialPageRoute(
                    builder: (context) =>
                        AddTaskPage(
                            taskType: enums[(enums.indexOf(widget.task.type) +
                                1) %
                                enums.length])));
          });
        });
  }

  _buildAppBar() {
    return AppBar(
      title: Text(
        widget.task.id == null
            ? 'ایجاد ${TaskTypeNames[widget.task.type]}'
            : 'ویرایش تسک ${widget.task.name}',
        style: TextStyle(color: Colors.white),
      ),
      actions: <Widget>[
        _buildAppBarTaskTypeChangeIcon(),
        IconButton(
          icon: Icon(Icons.check_circle),
          onPressed: () {
            this._submit();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scafold,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(child: _buildBodyContent()),
    );
  }
}
