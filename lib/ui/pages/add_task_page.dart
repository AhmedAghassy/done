import 'dart:developer';

import 'package:done/constants/constants.dart';
import 'package:done/localizations/translate_localization.dart';
import 'package:done/models/task_model.dart';
import 'package:done/services/local_notifications_services.dart';
import 'package:done/ui/size_config.dart';
import 'package:done/ui/theme.dart';
import 'package:done/ui/widgets/button_widget.dart';
import 'package:done/ui/widgets/input_field_widget.dart';
import 'package:done/ui/widgets/person_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:done/controller/task_controller.dart';
import 'package:intl/intl.dart' as intl;

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _titleTaskController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();

  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now().add(const Duration(minutes: 15));

  String _selectedRemind = Constants.fiveKey;
  final List<String> _remindList = [
    Constants.fiveKey,
    Constants.tenKey,
    Constants.fifteenKey,
    Constants.twentyKey,
  ];

  String _selectedRepeat = Constants.noneKey;
  final List<String> _repeatList = [
    Constants.noneKey,
    Constants.dailyKey,
    Constants.weeklyKey,
    Constants.monthlyKey,
  ];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return LayoutBuilder(
      builder: (layoutContext, constraint) {
        return Scaffold(
          appBar: constraint.maxWidth < 100
              ? AppBar()
              : AppBar(
                  leading: IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back_ios),
                  ),
                  actions: [
                    const PersonImageWidget(),
                    const SizedBox(width: 20),
                  ],
                ),
          body: SafeArea(
            child: constraint.maxWidth < 200
                ? Container()
                : Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Container(
                      alignment: AlignmentGeometry.topCenter,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Column(
                          children: [
                            Text(
                              Constants.addTaskKey.t(context),
                              style: Themes.headingStyle,
                            ),
                            InputFieldWidget(
                              title: Constants.taskKey,
                              hint: Constants.hintTaskKey.t(context),
                              controller: _titleTaskController,
                              validator: (inputValue) {
                                if (inputValue == null ||
                                    inputValue.isEmpty ||
                                    inputValue.trim().length < 3 ||
                                    inputValue.trim().length > 30) {
                                  return Constants.errorTaskTitleKey.t(context);
                                }
                                return null;
                              },
                              keyboardType: TextInputType.name,
                              textCapitalization: TextCapitalization.sentences,
                              textInputAction: TextInputAction.next,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                            ),
                            InputFieldWidget(
                              title: Constants.noteKey,
                              hint: Constants.hintNoteKey.t(context),
                              controller: _noteController,
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.sentences,
                              textInputAction: TextInputAction.done,
                            ),
                            InputFieldWidget(
                              title: Constants.dateKey,
                              hint: intl.DateFormat(
                                TranslateLocalization.of(
                                          context,
                                        )?.locale.languageCode ==
                                        'ar'
                                    ? 'yyy/MM/dd'
                                    : 'dd/MM/yyy',
                                TranslateLocalization.of(
                                  context,
                                )?.locale.languageCode,
                              ).format(_selectedDate),
                              widget: IconButton(
                                onPressed: () => _getDateFromUser(context),
                                icon: const Icon(
                                  Icons.calendar_today_outlined,
                                  color: grey,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: InputFieldWidget(
                                    title: Constants.startTimeKey,
                                    hint: intl.DateFormat(
                                      'hh:mm a',
                                      TranslateLocalization.of(
                                        context,
                                      )?.locale.languageCode,
                                    ).format(_startTime),
                                    widget: IconButton(
                                      onPressed: () => _getTimeFromUser(
                                        context,
                                        isStartTime: true,
                                      ),
                                      icon: const Icon(
                                        Icons.access_time_rounded,
                                        color: grey,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: InputFieldWidget(
                                    title: Constants.endTimeKey,
                                    hint: intl.DateFormat(
                                      'hh:mm a',
                                      TranslateLocalization.of(
                                        context,
                                      )?.locale.languageCode,
                                    ).format(_endTime),
                                    widget: IconButton(
                                      onPressed: () => _getTimeFromUser(
                                        context,
                                        isStartTime: false,
                                      ),
                                      icon: const Icon(
                                        Icons.access_time_rounded,
                                        color: grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            InputFieldWidget(
                              title: Constants.remindKey,
                              hint:
                                  TranslateLocalization.of(
                                        context,
                                      )?.locale.languageCode ==
                                      'ar'
                                  ? '${_selectedRemind.t(context)} دقيقة باكراً'
                                  : '${_selectedRemind.t(context)} minutes early',
                              widget: DropdownButton<String>(
                                value: _selectedRemind,
                                menuWidth: 70,
                                underline: Container(height: 0),
                                borderRadius: BorderRadius.circular(10),
                                style:
                                    TranslateLocalization.of(
                                          context,
                                        )?.locale.languageCode ==
                                        'ar'
                                    ? Themes.dropDownStyleAr
                                    : Themes.dropDownStyleEn,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: grey,
                                ),
                                iconSize: 34,
                                selectedItemBuilder: (itemContext) =>
                                    _remindList
                                        .map((remind) => Container())
                                        .toList(),
                                items: _remindList
                                    .map(
                                      (remind) => DropdownMenuItem<String>(
                                        value: remind,
                                        child: Text(remind.t(context)),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (newValue) {
                                  if (newValue == null) return;
                                  setState(() {
                                    _selectedRemind = newValue;
                                  });
                                },
                              ),
                            ),
                            InputFieldWidget(
                              title: Constants.repeatKey,
                              hint: _selectedRepeat.t(context),
                              widget: DropdownButton<String>(
                                value: _selectedRepeat,
                                menuWidth: 100,
                                underline: Container(height: 0),
                                borderRadius: BorderRadius.circular(10),
                                style:
                                    TranslateLocalization.of(
                                          context,
                                        )?.locale.languageCode ==
                                        'ar'
                                    ? Themes.dropDownStyleAr
                                    : Themes.dropDownStyleEn,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: grey,
                                ),
                                iconSize: 34,
                                selectedItemBuilder: (itemContext) =>
                                    _repeatList
                                        .map((repeat) => Container())
                                        .toList(),
                                items: _repeatList
                                    .map(
                                      (repeat) => DropdownMenuItem<String>(
                                        value: repeat,
                                        child: Text(repeat.t(context)),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (newValue) {
                                  if (newValue == null) return;
                                  setState(() {
                                    _selectedRepeat = newValue;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 18),
                            ButtonWidget(
                              label: Constants.createTaskKey,
                              onTap: () => _validateTask(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }

  Future<void> _getDateFromUser(BuildContext context) async {
    final DateTime? _pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 36500)),
      lastDate: DateTime.now().add(const Duration(days: 36500)),
      helpText: Constants.dateHelperTextKey.t(context),
      cancelText: Constants.cancelKey.t(context),
      confirmText: Constants.confirmKey.t(context),
      locale: TranslateLocalization.of(context)?.locale,
      textDirection:
          TranslateLocalization.of(context)?.locale.languageCode == 'ar'
          ? TextDirection.rtl
          : TextDirection.ltr,
    );
    if (_pickedDate == null) return;

    setState(() {
      _selectedDate = _pickedDate;
    });
  }

  Future<void> _getTimeFromUser(
    BuildContext context, {
    required bool isStartTime,
  }) async {
    final TimeOfDay? _pickedTime = await showTimePicker(
      context: context,
      initialTime: isStartTime
          ? TimeOfDay.fromDateTime(_startTime)
          : TimeOfDay.fromDateTime(_endTime),
      helpText: Constants.dateHelperTextKey.t(context),
      cancelText: Constants.cancelKey.t(context),
      confirmText: Constants.confirmKey.t(context),
      orientation: SizeConfig.orientation,
    );
    if (_pickedTime == null) return;

    if (isStartTime) {
      setState(() {
        _startTime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          _pickedTime.hour,
          _pickedTime.minute,
        );
      });
    } else {
      setState(() {
        _endTime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          _pickedTime.hour,
          _pickedTime.minute,
        );
      });
    }
  }

  void _validateTask(BuildContext context) {
    if (_formKey.currentState?.validate() != true) {
      Get.snackbar(
        Constants.requiredKey.t(context),
        Constants.validateTitleKey.t(context),
        colorText: redClr,
        snackPosition: SnackPosition.BOTTOM,
        icon: const Icon(Icons.warning_amber_rounded, color: redClr),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      );
      return;
    }
    _addTaskToDb();
    Get.back();
  }

  Future<void> _addTaskToDb() async {
    final TaskModel _aTask = TaskModel(
      title: _titleTaskController.text,
      note: _noteController.text,
      isCompleted: 0,
      date: intl.DateFormat('dd/MM/yyyy', 'en').format(_selectedDate),
      startTime: intl.DateFormat('hh:mm a', 'en').format(_startTime),
      endTime: intl.DateFormat('hh:mm a', 'en').format(_endTime),
      remind: int.parse(_selectedRemind),
      repeat: _selectedRepeat,
    );
    final int _id = await _taskController.insertTask(_aTask);
    final TaskModel _task = TaskModel(
      id: _id,
      title: _titleTaskController.text,
      note: _noteController.text,
      isCompleted: 0,
      date: intl.DateFormat('dd/MM/yyyy', 'en').format(_selectedDate),
      startTime: intl.DateFormat('hh:mm a', 'en').format(_startTime),
      endTime: intl.DateFormat('hh:mm a', 'en').format(_endTime),
      remind: int.parse(_selectedRemind),
      repeat: _selectedRepeat,
    );
    final DateTime _toDate = intl.DateFormat.jm().parse(_task.startTime);
    final String _toTime = intl.DateFormat('HH:mm').format(_toDate);
    final int _hour = int.parse(_toTime.split(':')[0]);
    final int _minutes = int.parse(_toTime.split(':')[1]);
    LocalNotificationsServices.instance.scheduledNotification(
      hour: _hour,
      minutes: _minutes,
      task: _task,
    );
    log('time: ${_hour.toString()}:${_minutes.toString()}');
    log('id: ${_id.toString()}');
    log('title: ${_titleTaskController.text.toString()}');
    log('note: ${_noteController.text.toString()}');
    log('isCompleted: 0');
    log(
      'date: ${intl.DateFormat('dd/MM/yyyy', 'en').format(_selectedDate).toString()}',
    );
    log(
      'startTime: ${intl.DateFormat('hh:mm a', 'en').format(_startTime).toString()}',
    );
    log(
      'endTime: ${intl.DateFormat('hh:mm a', 'en').format(_endTime).toString()}',
    );
    log('remind: ${int.parse(_selectedRemind).toString()}');
    log('repeat: ${_selectedRepeat.toString()}');
  }
}
