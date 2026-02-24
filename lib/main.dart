import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:one/core/localization/app_localizations.dart';
import 'package:one/firebase_options.dart';
import 'package:one/providers/_main.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/router/router.dart';
import 'package:one/theme/app_theme.dart';
import 'package:one/utils/shared_prefs.dart';
import 'package:one/utils/sound_helper.dart';
import 'package:one/utils/utils_keys.dart';
import 'package:one/utils/web_view_map_widget.dart';
import 'package:provider/provider.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initAsyncPrefs();
  initWebView();
  await initializeDateFormatting('ar');
  await initializeDateFormatting('en');
  await SoundHelper.initLocalFileBytes();
  runApp(const AppProvider());
}

class AppProvider extends StatelessWidget {
  const AppProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PxLocale>(
      builder: (context, l, _) {
        return MaterialApp.router(
          scaffoldMessengerKey: UtilsKeys.scaffoldMessengerKey,
          title: const String.fromEnvironment('APPLICATION_NAME'),
          routerConfig: AppRouter.router,
          debugShowCheckedModeBanner: false,
          locale: l.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          theme: AppTheme.theme,
          builder: (context, child) {
            return Overlay(
              initialEntries: [OverlayEntry(builder: (context) => child!)],
            );
          },
        );
      },
    );
  }

  //TODO: add caching for pdf.min.js via cdn "https://unpkg.com/pdfjs-dist@3.11.174/build/pdf.min.js" => no need
  //TODO: add application error codes && messages
  //TODO: implement fcm notifications into the app flow
  //todo: implement api cache over the whole app - done what can be done
  //---------------------------------------------------------------------------------//
  //todo: supply movements in table form
  //todo: bookkeeping in table form
  //todo: subscription controlles access => add entry in database
  //todo: patient documents
  //todo: notifications
  //todo: doctor visits in table form
  //todo: create / link assistant account => add permissions +/-
  //todo: patient visit progression view => listen to todays visits realtime => assistant app (same app vs another)
}


//code_nav
//@permission => navigate to permissions in app
//@SUPPLY_MOVEMENT => navigate to supply movement handling sequence
//@handle => errors that need handling
//@translate => error messages need translation