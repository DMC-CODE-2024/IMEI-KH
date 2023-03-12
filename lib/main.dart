import 'package:eirs/features/launcher/data/business_logic/launcher_bloc.dart';
import 'package:eirs/persistent/database_helper.dart';
import 'package:eirs/routes/app_routes.dart';
import 'package:eirs/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'constants/strings.dart';
import 'features/launcher/presentation/launcher_screen.dart';
import 'helper/app_states_notifier.dart';

const String feature1 = 'feature1',
    feature2 = 'feature2',
    feature3 = 'feature3',
    feature4 = 'feature4',
    feature5 = 'feature5';
final dbHelper = DatabaseHelper();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //* Update statusbar theme
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

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
