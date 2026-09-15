import 'package:done/localizations/translate_localization.dart';
import 'package:done/ui/size_config.dart';
import 'package:done/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InputFieldWidget extends StatefulWidget {
  const InputFieldWidget({
    super.key,
    required this.title,
    required this.hint,
    this.controller,
    this.widget,
    this.validator,
    this.keyboardType,
    this.textCapitalization,
    this.textInputAction,
    this.autovalidateMode,
  });

  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextCapitalization? textCapitalization;
  final TextInputAction? textInputAction;
  final AutovalidateMode? autovalidateMode;

  @override
  State<InputFieldWidget> createState() => _InputFieldWidgetState();
}

class _InputFieldWidgetState extends State<InputFieldWidget> {
  TextDirection? _direction;

  bool _isArabic(String text, BuildContext context) {
    if (text.isEmpty) {
      if (TranslateLocalization.of(context)?.locale.languageCode == 'ar') {
        return true;
      } else {
        return false;
      }
    }
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text[0]);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title.t(context), style: Themes.bodyTitleStyle),
          Container(
            padding:
                TranslateLocalization.of(context)?.locale.languageCode == 'ar'
                ? const EdgeInsets.only(right: 14, left: 6)
                : const EdgeInsets.only(left: 14, right: 6),
            margin: const EdgeInsets.only(top: 8),
            width: SizeConfig.screenWidth,
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: grey),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: widget.controller,
                    style: Themes.bodySubTitleStyle,
                    autofocus: false,
                    readOnly: widget.widget == null ? false : true,
                    cursorColor: Get.isDarkMode ? grey100 : grey700,
                    validator: widget.validator,
                    keyboardType: widget.keyboardType,
                    textCapitalization:
                        widget.textCapitalization ?? TextCapitalization.none,
                    textInputAction: widget.textInputAction,
                    autovalidateMode: widget.autovalidateMode,
                    decoration: InputDecoration(
                      hintText: widget.hint,
                      hintStyle: widget.widget == null
                          ? Themes.hintFieldStyle
                          : Themes.bodySubTitleStyle,
                      errorMaxLines: widget.widget == null ? 1 : null,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          width: 0,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          width: 0,
                        ),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          width: 0,
                        ),
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          width: 0,
                        ),
                      ),
                    ),
                    textDirection: widget.widget == null ? _direction : null,
                    onChanged: widget.widget == null
                        ? (String inputText) => setState(() {
                            _direction = _isArabic(inputText, context)
                                ? TextDirection.rtl
                                : TextDirection.ltr;
                          })
                        : null,
                  ),
                ),
                widget.widget ?? Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
