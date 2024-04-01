import 'package:eirs/constants/routes.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/check_imei/data/business_logic/check_imei_bloc.dart';
import '../features/check_imei/data/business_logic/home_imei_bloc.dart';
import '../features/check_imei/presentation/check_imei_screen.dart';

class AppRoutes {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.IMEI_SCREEN:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<HomeImeiBloc>(
            create:(BuildContext context) =>  HomeImeiBloc(),
            child: const FeatureDiscovery.withProvider(
                persistenceProvider: NoPersistenceProvider(),
                child: CheckImeiScreen(title: 'Home Screen')),
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
