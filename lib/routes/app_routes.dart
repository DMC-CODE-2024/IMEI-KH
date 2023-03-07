import 'package:eirs/constants/routes.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/check_imei/data/business_logic/check_imei_bloc.dart';
import '../features/check_imei/presentation/check_imei_screen.dart';
import '../features/check_imei/presentation/imei_info.dart';

class AppRoutes {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      /* case Routes.IMEI_RESULT:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: ImeiResultBloc(),
            child: ImeiResultScreen(
              title: "Home Screen",
            ),
          ),
        );*/
      case Routes.IMEI_SCREEN:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: CheckImeiBloc(),
            child: const FeatureDiscovery.withProvider(
                persistenceProvider: NoPersistenceProvider(),
                child: CheckImeiScreen(title: 'Home Screen')),
          ),
        );
      case Routes.IMEI_INFO:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: CheckImeiBloc(),
            child: const FeatureDiscovery.withProvider(
              persistenceProvider: NoPersistenceProvider(),
              child: ImeiInfoScreen(title: 'Home Screen'),
            ),
          ),
        );
      case Routes.THIRD:

      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
