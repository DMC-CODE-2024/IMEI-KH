import 'package:eirs/features/launcher/data/business_logic/launcher_bloc.dart';
import 'package:eirs/helper/shared_pref.dart';
import 'package:eirs/persistent/database_helper.dart';
import 'package:eirs/routes/app_routes.dart';
import 'package:eirs/theme/colors.dart';
import 'package:eirs/theme/hex_color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants/strings.dart';
import 'features/launcher/presentation/launcher_screen.dart';
import 'helper/app_screen_privacy.dart';
import 'helper/app_states_notifier.dart';

const String feature1 = 'feature1',
    feature2 = 'feature2',
    feature3 = 'feature3',
    feature4 = 'feature4',
    feature5 = 'feature5';
const platform = MethodChannel('kh.eirs.mobileapp/deviceInfo');
final dbHelper = DatabaseHelper();
final appScreenPrivacy = AppScreenPrivacyService();
String selectedLng = StringConstants.khmerCode;
late final SharedPreferences sharedPref;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  //* Update statusbar theme
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.white,
    ),
  );
  sharedPref = await SharedPreferences.getInstance();
  selectedLng = await getLocale();
  // initialize the database
  await dbHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final AppRoutes _appRoutes = AppRoutes();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      appScreenPrivacy.enableScreenPrivacy();
    } else if (state == AppLifecycleState.resumed) {
      appScreenPrivacy.disableScreenPrivacy();
    }
  }

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
            home: BlocProvider(
              create: (context) => LauncherBloc(),
              child: const LauncherScreen(title: "Launcher screen"),
            ),
            onGenerateRoute: _appRoutes.onGenerateRoute));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
