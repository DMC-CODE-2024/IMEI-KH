import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants/image_path.dart';
import '../../../constants/strings.dart';
import '../../../theme/colors.dart';
import '../../component/app_bar_with_title.dart';
import '../../component/button.dart';
import '../../component/custom_progress_indicator.dart';
import '../../imei_result/presentation/imei_result_screen.dart';
import '../data/business_logic/check_imei_bloc.dart';
import '../data/business_logic/check_imei_state.dart';

class ImeiListPage extends StatefulWidget {
  ImeiListPage({
    Key? key,
    required this.data,
  }) : super(key: key);

  Map<String, int> data = <String, int>{};

  @override
  State<ImeiListPage> createState() => _ImeiListPageState();
}

class _ImeiListPageState extends State<ImeiListPage> {
  int selectedIndex = -1;
  String selectedImei = "";

  @override
  void initState() {
    super.initState();
    if (widget.data.isNotEmpty) {
      selectedIndex = 0;
      selectedImei = widget.data.keys.elementAt(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const AppBarWithTitleOnly(title: StringConstants.scanCode),
      body: BlocConsumer<CheckImeiBloc, CheckImeiState>(
        builder: (context, state) {
          if (state is CheckImeiLoadingState) {
            return const CustomProgressIndicator(textColor: Colors.white);
          }
          return showImeiDialog(widget.data);
        },
        listener: (context, state) {
          if (state is CheckImeiLoadedState) {
            _navigateResultScreen(state.checkImeiRes.result?.deviceDetails,
                state.checkImeiRes.result?.validImei ?? false);
          }
          if (state is CheckImeiErrorState) {
            _navigateResultScreen(null, false);
          }
        },
      ),
    );
  }

  Widget showImeiDialog(Map<String, dynamic> data) {
    return Dialog(
      elevation: 0,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      StringConstants.selectImei,
                      style: TextStyle(
                          fontSize: 16.0,
                          color: AppColors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: SvgPicture.asset(ImageConstants.crossIcon)),
                )
              ],
            ),
            _listWidget(data),
            Container(height: 20),
            AppButton(
              width: 200,
              isLoading: false,
              child: const Text(StringConstants.check),
              onPressed: () => _checkImei(context),
            )
          ],
        ),
      ),
    );
  }

  Widget _listWidget(Map<String, dynamic> values) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: values.length,
      itemBuilder: (BuildContext context, int index) {
        String key = values.keys.elementAt(index);
        return InkWell(
          onTap: () => _getSelectedItem(index, values.keys.elementAt(index)),
          child: ListTile(
            title: Text("${StringConstants.imei} ${index + 1}"),
            subtitle: Container(
              margin: const EdgeInsets.only(top: 8.0),
              padding: const EdgeInsets.only(left: 10, top: 7, bottom: 7),
              decoration: BoxDecoration(
                border: Border.all(
                    color:
                        (selectedIndex == index) ? Colors.blue : Colors.grey),
                borderRadius: const BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              child: Text(key),
            ),
          ),
        );
      },
    );
  }

  void _getSelectedItem(int index, String selectedImei) {
    this.selectedImei = selectedImei;
    setState(() => {selectedIndex = index});
  }

  void _checkImei(BuildContext context) {
    BlocProvider.of<CheckImeiBloc>(context)
        .add(CheckImeiInitEvent(inputImei: selectedImei));
  }

  void _navigateResultScreen(Map<String, dynamic>? data, bool isValidImei) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ImeiResultScreen(
            title: StringConstants.result,
            scanImei: selectedImei,
            data: data,
            isValidImei: isValidImei)));
  }
}
