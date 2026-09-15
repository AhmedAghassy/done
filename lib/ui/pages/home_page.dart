import 'dart:io';
import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:done/constants/constants.dart';
import 'package:done/controller/task_controller.dart';
import 'package:done/localizations/cubit/locale_cubit.dart';
import 'package:done/localizations/translate_localization.dart';
import 'package:done/models/task_model.dart';
import 'package:done/services/local_notifications_services.dart';
import 'package:done/services/theme_services.dart';
import 'package:done/ui/pages/add_task_page.dart';
import 'package:done/ui/size_config.dart';
import 'package:done/ui/theme.dart';
import 'package:done/ui/widgets/button_widget.dart';
import 'package:done/ui/widgets/task_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const platform = MethodChannel('samples.flutter.dev/battery');
  String _batteryLevel = 'wait';
  Timer? _batteryTimer;

  final _taskController = Get.put(TaskController());

  final _themeServices = ThemeServices();

  DateTime _selectedDate = DateTime.now();

  //related with native
  Future<void> _getBatteryLevel() async {
    String batteryLevel = 'wait';
    try {
      final int? result = await platform.invokeMethod<int>('getBatteryLevel');
      if (result == null) {
        batteryLevel = 'unknown';
      } else {
        batteryLevel = '$result';
      }
    } catch (_) {
      batteryLevel = 'failed';
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  @override
  void initState() {
    if (Platform.isAndroid) {
      LocalNotificationsServices.instance.requestAndroidPermission();
    }
    if (Platform.isIOS) {
      LocalNotificationsServices.instance.requestIOSPermission();
    }
    if (Platform.isMacOS) {
      LocalNotificationsServices.instance.requestMacOSPermission();
    }
    LocalNotificationsServices.instance.initNotifications();
    _taskController.queryTasks();

    _batteryTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        _getBatteryLevel();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _batteryTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    bool _isDark = _themeServices.loadThemeFromBox();
    return LayoutBuilder(
      builder: (layoutContext, constraint) {
        return Scaffold(
          appBar: constraint.maxWidth < 200
              ? AppBar()
              : AppBar(
                  leading: IconButton(
                    onPressed: () async {
                      await _themeServices.switchTheme();
                      setState(() {
                        _isDark = _themeServices.loadThemeFromBox();
                      });
                    },
                    icon: Icon(
                      _isDark
                          ? Icons.wb_sunny_outlined
                          : Icons.nightlight_outlined,
                    ),
                  ),
                  actions: [
                    const Spacer(flex: 6),
                    Text(
                      (_batteryLevel == 'wait' ||
                              _batteryLevel == 'unknown' ||
                              _batteryLevel == 'failed')
                          ? _batteryLevel.t(context)
                          : TranslateLocalization.of(
                                  context,
                                )?.locale.languageCode ==
                                'ar'
                          ? '% $_batteryLevel'
                          : '$_batteryLevel %',
                      style: Themes.batteryLevelStyle,
                    ),
                    const SizedBox(width: 2),
                    Icon(_getBatteryIcon(_batteryLevel)),
                    const SizedBox(width: 4),
                    const Spacer(),
                    BlocBuilder<LocaleCubit, LocaleState>(
                      builder: (localeContext, localeState) {
                        return TextButton.icon(
                          onPressed: () =>
                              context.read<LocaleCubit>().changeLanguageCode(
                                localeState.locale.languageCode == 'ar'
                                    ? 'en'
                                    : 'ar',
                              ),
                          label: Text(
                            localeState.locale.languageCode == 'ar'
                                ? 'اللغة الإنجليزية'
                                : 'Arabic',
                          ),
                          icon: const Icon(Icons.language_rounded),
                        );
                      },
                    ),
                  ],
                ),
          body: SafeArea(
            child: (constraint.maxWidth < 240 || constraint.maxHeight < 220)
                ? Container()
                : Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _addTaskBar(context),
                        _dateBar(context),
                        const SizedBox(height: 8),
                        _taskController.taskList.isEmpty
                            ? Container()
                            : _deleteAllIcon(context),
                        _showTasks(context),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }

  IconData _getBatteryIcon(String batteryLevel) {
    if (batteryLevel == 'wait' || batteryLevel == 'unknown') {
      return Icons.battery_unknown_rounded;
    }
    if (int.tryParse(batteryLevel) != null) {
      if (int.parse(batteryLevel) < 20) {
        return Icons.battery_alert_rounded;
      }
      if (int.parse(batteryLevel) == 20) {
        return Icons.battery_1_bar_rounded;
      }
      if (int.parse(batteryLevel) > 20 && int.parse(batteryLevel) < 50) {
        return Icons.battery_2_bar_rounded;
      }
      if (int.parse(batteryLevel) == 50) {
        return Icons.battery_3_bar_rounded;
      }
      if (int.parse(batteryLevel) > 50 && int.parse(batteryLevel) <= 75) {
        return Icons.battery_4_bar_rounded;
      }
      if (int.parse(batteryLevel) > 75 && int.parse(batteryLevel) < 90) {
        return Icons.battery_5_bar_rounded;
      }
      if (int.parse(batteryLevel) >= 90 && int.parse(batteryLevel) < 100) {
        return Icons.battery_6_bar_rounded;
      }
      if (int.parse(batteryLevel) == 100) {
        return Icons.battery_full_rounded;
      }
    } else {
      return Icons.error_rounded;
    }
    return Icons.error_rounded;
  }

  Widget _deleteAllIcon(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: FadeIn(
        duration: const Duration(milliseconds: 700),
        child: IconButton(
          onPressed: () => showAdaptiveDialog(
            context: context,
            builder: (dialogContext) => _dialogSureDelete(context),
            barrierDismissible: true,
            animationStyle: const AnimationStyle(
              curve: Curves.easeIn,
              reverseCurve: Curves.easeOut,
              duration: Duration(milliseconds: 200),
              reverseDuration: Duration(milliseconds: 200),
            ),
          ),
          icon: const Icon(Icons.clear_all_rounded),
        ),
      ),
    );
  }

  Widget _dialogSureDelete(BuildContext context) {
    return AlertDialog.adaptive(
      backgroundColor: Theme.of(context).secondaryHeaderColor,
      titlePadding: const EdgeInsets.only(left: 18, right: 18, top: 24),
      title: Text(
        Constants.sureKey.t(context),
        style: Themes.bodyTitleRedStyle,
      ),
      content: Text(
        Constants.deleteAllMsgKey.t(context),
        style: Themes.bodySubTitleStyle,
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text(Constants.cancelKey.t(context)),
        ),
        TextButton(
          onPressed: () {
            LocalNotificationsServices.instance.cancelAllNotifications();
            _taskController.deleteAllTasks();
            Get.back();
          },
          child: Text(Constants.confirmKey.t(context)),
        ),
      ],
    );
  }

  Widget _addTaskBar(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 20,
        right: 20,
        top: SizeConfig.orientation == Orientation.landscape ? 0 : 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                intl.DateFormat.yMMMMd(
                  TranslateLocalization.of(context)?.locale.languageCode == 'ar'
                      ? 'ar'
                      : 'en',
                ).format(DateTime.now()),
                style: Themes.headingStyle,
              ),
              Text(
                Constants.todayKey.t(context),
                style: Themes.bigHeadingStyle,
              ),
            ],
          ),
          ButtonWidget(
            label: Constants.addTaskWithPlusKey,
            onTap: () async {
              await Get.to(() => const AddTaskPage());
              _taskController.queryTasks();
            },
          ),
        ],
      ),
    );
  }

  Widget _dateBar(BuildContext context) {
    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (localeContext, localeState) {
        return Container(
          margin: EdgeInsets.only(
            top: SizeConfig.orientation == Orientation.landscape ? 2 : 8,
            left: TranslateLocalization.of(context)?.locale.languageCode == 'ar'
                ? 0
                : 20,
            right:
                TranslateLocalization.of(context)?.locale.languageCode == 'ar'
                ? 20
                : 0,
          ),
          child: DatePicker(
            DateTime.now(),
            initialSelectedDate: _selectedDate,
            onDateChange: (newDate) => setState(() {
              _selectedDate = newDate;
            }),
            locale: localeState.locale.languageCode,
            directionality: localeState.locale.languageCode == 'ar'
                ? TextDirection.rtl
                : TextDirection.ltr,
            width: 80,
            height: SizeConfig.orientation == Orientation.landscape ? 90 : 100,
            daysCount: 365,
            selectionColor: primaryClr,
            selectedTextColor: white,
            dateTextStyle: Themes.dateStyle,
            dayTextStyle: Themes.dayStyle,
            monthTextStyle: Themes.monthStyle,
          ),
        );
      },
    );
  }

  Widget _showTasks(BuildContext context) {
    return Expanded(
      child: Obx(() {
        if (_taskController.taskList.isEmpty) {
          return _noTasksWidget(context);
        } else {
          return _tasks(context);
        }
      }),
    );
  }

  Widget _noTasksWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.only(left: 20, right: 20, bottom: 10),
      child: RefreshIndicator.adaptive(
        onRefresh: () => _taskController.queryTasks(),
        child: Center(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Wrap(
              direction: SizeConfig.orientation == Orientation.landscape
                  ? Axis.horizontal
                  : Axis.vertical,
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                FadeIn(
                  duration: const Duration(milliseconds: 250),
                  child: SvgPicture.asset(
                    'assets/images/task.svg',
                    semanticsLabel: 'Task',
                    height: 100,
                    colorFilter: ColorFilter.mode(
                      primaryClr.withAlpha(128),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                SizeConfig.orientation == Orientation.landscape
                    ? const SizedBox(width: 8)
                    : const SizedBox(height: 8),
                FadeIn(
                  duration: const Duration(milliseconds: 250),
                  child: Text(
                    Constants.noTasksKey.t(context),
                    style: Themes.hintFieldStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _tasks(BuildContext context) {
    return Padding(
      padding: TranslateLocalization.of(context)?.locale.languageCode == 'ar'
          ? const EdgeInsets.only(left: 20)
          : const EdgeInsets.only(right: 20),
      child: RefreshIndicator.adaptive(
        onRefresh: () => _taskController.queryTasks(),
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          scrollDirection: SizeConfig.orientation == Orientation.landscape
              ? Axis.horizontal
              : Axis.vertical,
          itemCount: _taskController.taskList.length,
          itemBuilder: (contextBuilder, index) {
            final task = _taskController.taskList[index];
            if ((task.repeat == Constants.dailyKey) ||
                (task.date ==
                    intl.DateFormat(
                      'dd/MM/yyyy',
                      'en',
                    ).format(_selectedDate)) ||
                (task.repeat == Constants.weeklyKey &&
                    _selectedDate
                                .difference(
                                  intl.DateFormat(
                                    'dd/MM/yyyy',
                                    'en',
                                  ).parse(task.date),
                                )
                                .inDays %
                            7 ==
                        0) ||
                (task.repeat == Constants.monthlyKey &&
                    _selectedDate.day ==
                        intl.DateFormat(
                          'dd/MM/yyyy',
                          'en',
                        ).parse(task.date).day)) {
              return AnimationConfiguration.staggeredList(
                duration: const Duration(milliseconds: 400),
                delay: const Duration(milliseconds: 25),
                position: index,
                child: FadeInAnimation(
                  duration: const Duration(milliseconds: 700),
                  child: SlideAnimation(
                    verticalOffset: 0,
                    horizontalOffset: SizeConfig.screenWidth * 0.9,
                    child: GestureDetector(
                      onTap: () => _showBottomSheet(context, task),
                      child: TaskTile(task: task),
                    ),
                  ),
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  Widget _buildBottomSheetButton({
    required BuildContext context,
    required String label,
    required void Function() onTap,
    required Color clr,
    bool isClose = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        height: 65,
        width: SizeConfig.screenWidth * 0.9,
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: isClose ? grey100! : clr),
          borderRadius: BorderRadius.circular(20),
          color: isClose ? Colors.transparent : clr,
        ),
        child: Center(
          child: Text(
            label.t(context),
            style: isClose
                ? Themes.bodyTitleStyle
                : Themes.bodyTitleStyle.copyWith(color: white),
          ),
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context, TaskModel task) {
    Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 4),
          width: SizeConfig.screenWidth,
          height: (SizeConfig.orientation == Orientation.landscape)
              ? (task.isCompleted == 1
                    ? SizeConfig.screenHeight * 0.6
                    : SizeConfig.screenHeight * 0.8)
              : (task.isCompleted == 1
                    ? SizeConfig.screenHeight * 0.30
                    : SizeConfig.screenHeight * 0.39),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: Theme.of(context).secondaryHeaderColor,
          ),
          child: Column(
            children: [
              Flexible(
                child: Container(
                  height: 6,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: grey,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              task.isCompleted == 1
                  ? Container()
                  : _buildBottomSheetButton(
                      context: context,
                      label: Constants.taskCompletedKey,
                      onTap: () {
                        LocalNotificationsServices.instance.cancelNotification(
                          task,
                        );
                        _taskController.updateToComplete(task.id!);
                        Get.back();
                      },
                      clr: primaryClr,
                    ),
              _buildBottomSheetButton(
                context: context,
                label: Constants.deleteTaskKey,
                onTap: () {
                  LocalNotificationsServices.instance.cancelNotification(task);
                  _taskController.deleteSingleTask(task.id!);
                  Get.back();
                },
                clr: redClr400!,
              ),
              Divider(
                indent: 25,
                endIndent: 25,
                thickness: 2,
                radius: BorderRadius.circular(10),
                color: grey,
              ),
              _buildBottomSheetButton(
                context: context,
                label: Constants.cancelKey,
                onTap: () => Get.back(),
                clr: primaryClr,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
