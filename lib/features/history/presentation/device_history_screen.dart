import 'package:eirs/features/history/data/business_logic/device_history_bloc.dart';
import 'package:eirs/features/history/data/business_logic/device_history_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/strings.dart';
import '../../../persistent/database_helper.dart';
import '../../component/custom_progress_indicator.dart';
import '../../component/result_app_bar.dart';
import '../data/business_logic/device_history_event.dart';

class DeviceHistoryScreen extends StatefulWidget {
  const DeviceHistoryScreen({super.key});

  @override
  State<DeviceHistoryScreen> createState() => _DeviceHistoryScreenState();
}

class _DeviceHistoryScreenState extends State<DeviceHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<DeviceHistoryBloc>(context).add(DeviceHistoryInitEvent());
    return Scaffold(
      appBar:
          ResultAppBar(title: StringConstants.history, callback: (value) {}),
      body: BlocConsumer<DeviceHistoryBloc, DeviceHistoryState>(
        builder: (context, state) {
          if (state is DeviceHistoryLoadingState) {
            return const CustomProgressIndicator(textColor: Colors.black);
          }
          if (state is DeviceHistoryLoadedState) {
            return _listWidget(state.deviceHistory);
          }
          return Container();
        },
        listener: (context, state) {
          if (state is DeviceHistoryLoadedState) {}
          if (state is DeviceHistoryErrorState) {}
        },
      ),
    );
  }

  Widget _listWidget(List<Map<String, dynamic>> values) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: values.length,
      itemBuilder: (BuildContext context, int index) {
        Map<String, dynamic> deviceDetail = values.elementAt(index);
        String key = deviceDetail[DatabaseHelper.columnImei];
        return ListTile(
          title: Text("${StringConstants.imei} ${index + 1}"),
          subtitle: Container(
            margin: const EdgeInsets.only(top: 8.0),
            padding: const EdgeInsets.only(left: 10, top: 7, bottom: 7),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              borderRadius: const BorderRadius.all(
                Radius.circular(5.0),
              ),
            ),
            child: Text(key),
          ),
        );
      },
    );
  }
}
