import 'package:educational_complex_director_app/l10n/app_localizations.dart';
// import 'package:educational_complex_director_app/view/pages/splash_screen.dart';

import 'package:educational_complex_director_app/services/local_storage_services.dart';
import 'package:educational_complex_director_app/routes/routes.dart';
import 'package:educational_complex_director_app/utils/s_config.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageService.init();
  // await AppLocalizations.delegate.load(const Locale('en'));
  // await AppLocalizations.delegate.load(const Locale('ar'));

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    
  ]);

  runApp(
    ProviderScope(
      child: const MyApp(),
      retry: (retryCount, error) {
        if (retryCount > 3) {
          return null;
        }
        return const Duration(seconds: 2);
      },
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GetMaterialApp(
      title: 'Siraj',
      debugShowCheckedModeBanner: false,
      theme: SConfig.lightTheme,

      initialRoute: Sroutes.auth,
      getPages: SAppRoute.pages,
      darkTheme: SConfig.darkTheme,
      locale: const Locale('ar'),

      fallbackLocale: const Locale('ar'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      themeMode: ThemeMode.light,
      // builder: (context, child) {
      //   return settingsAsync.when(
      //     data: (_) {
      //       return child!;
      //     },
      //     loading: () => const SplashScreen(),
      //     error: (err, _) => Scaffold(
      //       body: Center(child: Text('Error loading settings: $err')),
      //     ),
      //   )
      //}
    );
  }
}
