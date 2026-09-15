import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

part 'locale_state.dart';

part 'locale_cubit.freezed.dart';

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit()
    : super(const LocaleState.localeChangeLanguageState(Locale('ar')));

  Future<void> getLangCodeOnOpenApp() async {
    final _localeBox = GetStorage();
    final _languageCode = _localeBox.read<String>('langCode') ?? 'ar';
    final _locale = Locale(_languageCode);
    emit(LocaleState.localeChangeLanguageState(_locale));
    Get.updateLocale(_locale);
  }

  Future<void> changeLanguageCode(String languageCode) async {
    final _localeBox = GetStorage();
    await _localeBox.write('langCode', languageCode);
    final _locale = Locale(languageCode);
    emit(LocaleState.localeChangeLanguageState(_locale));
    Get.updateLocale(_locale);
  }
}
