import 'package:eirs/features/launcher/data/business_logic/launcher_bloc.dart';
import 'package:eirs/persistent/database_helper.dart';
import 'package:eirs/routes/app_routes.dart';
import 'package:eirs/theme/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants/strings.dart';
import 'features/launcher/presentation/launcher_screen.dart';
import 'helper/app_states_notifier.dart';

const String feature1 = 'feature1',
    feature2 = 'feature2',
    feature3 = 'feature3',
    feature4 = 'feature4',
    feature5 = 'feature5';
final dbHelper = DatabaseHelper();
late final SharedPreferences sharedPref;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  //* Update statusbar theme
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  sharedPref = await SharedPreferences.getInstance();
  // initialize the database
  await dbHelper.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AppRoutes _appRoutes = AppRoutes();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppStatesNotifier>(
        create: (context) => AppStatesNotifier(),
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: StringConstants.openSansFontFamily,
              primarySwatch: AppColors.primaryColor,
            ),
            //home: const LauncherScreen(title: 'Flutter Demo Home Page'),
            home: BlocProvider(
              create: (context) => LauncherBloc(),
              child: const LauncherScreen(title: "Launcher screen"),
            ),
            onGenerateRoute: _appRoutes.onGenerateRoute));
  }
}
