import 'package:done/db/db.dart';
import 'package:done/localizations/cubit/locale_cubit.dart';
import 'package:done/localizations/translate_localization.dart';
import 'package:done/services/theme_services.dart';
import 'package:done/ui/pages/home_page.dart';
import 'package:done/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Db.initDb();
  await GetStorage.init();
  // final _notificationService = LocalNotificationsServices();
  // await _notificationService.initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (localeCubitContext) => LocaleCubit()..getLangCodeOnOpenApp(),
      child: BlocBuilder<LocaleCubit, LocaleState>(
        builder: (localeContext, localeState) {
          return GetMaterialApp(
            title: localeState.locale.languageCode == 'ar' ? "أنجز" : 'Done',
            debugShowCheckedModeBanner: false,
            themeMode: ThemeServices().themeMode,
            theme: localeState.locale.languageCode == 'ar'
                ? Themes.lightAr
                : Themes.lightEn,
            darkTheme: localeState.locale.languageCode == 'ar'
                ? Themes.darkAr
                : Themes.darkEn,
            home: const HomePage(),
            supportedLocales: const <Locale>[Locale('ar'), Locale('en')],
            localizationsDelegates: const [
              TranslateLocalization.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
          );
        },
      ),
    );
  }
}
