import 'package:done/localizations/translate_localization.dart';
import 'package:done/ui/theme.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({super.key, required this.label, required this.onTap});

  final String label;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: AlignmentGeometry.center,
        width: 100,
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: primaryClr,
        ),
        child: Text(
          label.t(context),
          style: Themes.bodySubTitleStyle,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
