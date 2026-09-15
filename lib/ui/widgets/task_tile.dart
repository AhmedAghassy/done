import 'package:done/constants/constants.dart';
import 'package:done/localizations/translate_localization.dart';
import 'package:done/models/task_model.dart';
import 'package:done/ui/size_config.dart';
import 'package:done/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class TaskTile extends StatelessWidget {
  const TaskTile({super.key, required this.task});

  final TaskModel task;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      margin: EdgeInsets.only(
        bottom: SizeConfig.orientation == Orientation.landscape ? 5 : 10,
      ),
      padding: TranslateLocalization.of(context)?.locale.languageCode == 'ar'
          ? const EdgeInsets.only(right: 20)
          : const EdgeInsets.only(left: 20),
      width: SizeConfig.screenWidth,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: task.isCompleted == 0 ? orangeClr : primaryClr,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: Themes.taskTitleStyle,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 16,
                          color: grey100,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${intl.DateFormat('hh:mm a', TranslateLocalization.of(context)?.locale.languageCode).format(intl.DateFormat.jm().parse(task.startTime))} - ${intl.DateFormat('hh:mm a', TranslateLocalization.of(context)?.locale.languageCode).format(intl.DateFormat.jm().parse(task.endTime))}',
                            style: Themes.taskTimeStyle,
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                    task.note.isEmpty
                        ? Container()
                        : const SizedBox(height: 12),
                    task.note.isEmpty
                        ? Container()
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.notes_rounded,
                                size: 16,
                                color: grey100,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  task.note,
                                  style: Themes.taskNoteStyle,
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: 60,
              width: 0.5,
              color: grey100,
            ),
            RotatedBox(
              quarterTurns: 3,
              child: Text(
                task.isCompleted == 0
                    ? Constants.waitingKey.t(context)
                    : Constants.completedKey.t(context),
                style: Themes.taskStateStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
