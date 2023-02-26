import 'package:eirs/features/launcher/data/business_logic/launcher_bloc.dart';
import 'package:eirs/provider/app_locale.dart';
import 'package:eirs/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'features/launcher/presentation/launcher_screen.dart';

const String feature1 = 'feature1',
    feature2 = 'feature2',
    feature3 = 'feature3',
    feature4 = 'feature4',
    feature5 = 'feature5',
    feature6 = 'feature6',
    feature7 = 'feature7';

Future<void> main() async {
  //* Update statusbar theme
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AppRoutes _appRoutes = AppRoutes();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => AppLocale(),
        child: Consumer<AppLocale>(builder: (context, locale, child) {
          return MaterialApp(
              title: 'Flutter Demo',
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              // important
              supportedLocales: AppLocalizations.supportedLocales,
              locale: locale.locale,
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              //home: const LauncherScreen(title: 'Flutter Demo Home Page'),
              home: BlocProvider(
                create: (context) => LauncherBloc(),
                child: LauncherScreen(title: "Launcher screen"),
              ),
              onGenerateRoute: _appRoutes.onGenerateRoute);
        }));
  }
}
