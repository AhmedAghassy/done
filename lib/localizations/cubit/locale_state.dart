part of 'locale_cubit.dart';

@freezed
abstract class LocaleState with _$LocaleState {
  const factory LocaleState.localeChangeLanguageState(Locale locale) =
      _LocaleChangeLanguageState;
}
