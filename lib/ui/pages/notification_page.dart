import 'package:done/constants/constants.dart';
import 'package:done/localizations/translate_localization.dart';
import 'package:done/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key, required this.payload});

  final String payload;

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  String _payload = '';

  @override
  void initState() {
    _payload = widget.payload;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text(Constants.notificationKey.t(context)),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (layoutContext, constraint) {
            return constraint.maxHeight < 145
                ? Container()
                : Column(
                    children: [
                      const SizedBox(height: 30),
                      Text(
                        Constants.newReminderKey.t(context),
                        style: Themes.headingStyle,
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(30),
                          margin: const EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            color: primaryClr,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                constraint.maxWidth < 230
                                    ? Container()
                                    : Row(
                                        children: [
                                          const Icon(Icons.task_alt_outlined),
                                          const SizedBox(width: 10),
                                          Text(
                                            Constants.taskKey.t(context),
                                            style: Themes.bodyTitleStyle,
                                          ),
                                        ],
                                      ),
                                const SizedBox(height: 15),
                                Text(
                                  _payload.split('|')[0],
                                  style: Themes.bodySubTitleStyle,
                                ),
                                const SizedBox(height: 50),
                                constraint.maxWidth < 230
                                    ? Container()
                                    : _payload.split('|')[1].isEmpty
                                    ? Container()
                                    : Row(
                                        children: [
                                          const Icon(
                                            Icons.description_outlined,
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            Constants.descKey.t(context),
                                            style: Themes.bodyTitleStyle,
                                          ),
                                        ],
                                      ),
                                _payload.split('|')[1].isEmpty
                                    ? Container()
                                    : const SizedBox(height: 15),
                                _payload.split('|')[1].isEmpty
                                    ? Container()
                                    : Text(
                                        _payload.split('|')[1],
                                        style: Themes.bodySubTitleStyle,
                                      ),
                                _payload.split('|')[1].isEmpty
                                    ? Container()
                                    : const SizedBox(height: 50),
                                constraint.maxWidth < 230
                                    ? Container()
                                    : Row(
                                        children: [
                                          const Icon(Icons.timer_outlined),
                                          const SizedBox(width: 10),
                                          Text(
                                            Constants.timeKey.t(context),
                                            style: Themes.bodyTitleStyle,
                                          ),
                                        ],
                                      ),
                                const SizedBox(height: 15),
                                Text(
                                  '${intl.DateFormat(TranslateLocalization.of(context)?.locale.languageCode == 'ar' ? 'yyy/MM/dd' : 'dd/MM/yyy', TranslateLocalization.of(context)?.locale.languageCode).format(intl.DateFormat('dd/MM/yyy', 'en').parse(_payload.split('|')[2]))} | ${intl.DateFormat('hh:mm a', TranslateLocalization.of(context)?.locale.languageCode).format(intl.DateFormat('hh:mm a', 'en').parse(_payload.split('|')[3]))} - ${intl.DateFormat('hh:mm a', TranslateLocalization.of(context)?.locale.languageCode).format(intl.DateFormat('hh:mm a', 'en').parse(_payload.split('|')[4]))}',
                                  style: Themes.bodySubTitleStyle,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
          },
        ),
      ),
    );
  }
}
