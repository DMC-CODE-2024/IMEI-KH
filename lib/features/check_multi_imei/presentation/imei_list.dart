import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../constants/image_path.dart';
import '../../../constants/strings.dart';
import '../../../helper/app_states_notifier.dart';
import '../../../helper/shared_pref.dart';
import '../../../theme/colors.dart';
import '../../component/app_bar_with_title.dart';
import '../../component/button.dart';
import '../../component/custom_progress_indicator.dart';
import '../../component/error_page.dart';
import '../../imei_result/presentation/multi_imei_result_screen.dart';
import '../../launcher/data/models/device_details_res.dart';
import '../data/business_logic/check_multi_imei_bloc.dart';
import '../data/business_logic/check_multi_imei_event.dart';
import '../data/business_logic/check_multi_imei_state.dart';
import '../data/models/multi_imei_res.dart';

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
  String emptyString = "";
  LabelDetails? labelDetails;
  String selectedLng = StringConstants.englishCode;

  @override
  void initState() {
    super.initState();
    getLocale().then((languageCode) {
      selectedLng = languageCode;
    });
    if (widget.data.isNotEmpty) {
      selectedIndex = 0;
      selectedImei = widget.data.keys.elementAt(0);
    } else {
      selectedImei = "";
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    labelDetails = Provider.of<AppStatesNotifier>(context).value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBarWithTitleOnly(title: labelDetails?.scanCode ?? emptyString),
      body: BlocConsumer<CheckMultiImeiBloc, CheckMultiImeiState>(
        builder: (context, state) {
          if (state is CheckMultiImeiLoadingState) {
            return CustomProgressIndicator( labelDetails: labelDetails,textColor: Colors.white);
          }
          if (state is CheckMultiImeiErrorState) {
            return Container(
              color: Colors.white,
              child: ErrorPage(labelDetails: labelDetails),
            );
          }

          return showImeiDialog(widget.data);
        },
        listener: (context, state) {
          if (state is CheckMultiImeiLoadedState) {
            _navigateResultScreen(state.multiImeiResList);
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
        padding: const EdgeInsets.only(bottom: 15.0, top: 5, right: 5, left: 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      labelDetails?.selectOnImei ?? "",
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
                      padding: const EdgeInsets.all(10),
                      child: SvgPicture.asset(ImageConstants.crossIcon)),
                )
              ],
            ),
            _listWidget(data),
            Container(height: 20),
            AppButton(
              width: 200,
              isLoading: false,
              child: Text(labelDetails?.check ?? emptyString),
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
            subtitle: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                    ),
                    child: Text(key),
                  )),
                  InkWell(
                    onTap: () => _removeItemFromMap(key),
                    child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: SvgPicture.asset(ImageConstants.crossIcon)),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _removeItemFromMap(String key) {
    widget.data.remove(key);
    if (widget.data.isNotEmpty) {
      selectedIndex = 0;
      selectedImei = widget.data.keys.elementAt(0);
    } else {
      selectedImei = "";
      return Navigator.pop(context);
    }
    setState(() => {});
  }

  void _getSelectedItem(int index, String selectedImei) {
    this.selectedImei = selectedImei;
    setState(() => {selectedIndex = index});
  }

  void _checkImei(BuildContext context) {
    if (selectedImei.isEmpty) {
      return _showErrorMsg(labelDetails?.noImeiSelected ?? emptyString);
    }
    BlocProvider.of<CheckMultiImeiBloc>(context).add(CheckMultiImeiInitEvent(
        imeiMap: widget.data, languageType: selectedLng));
  }

  void _showErrorMsg(String errorMsg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.red,
      content: Text(
        errorMsg,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    ));
  }

  void _navigateResultScreen(List<MultiImeiRes> imeiResList) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => MultiImeiResultScreen(
            imeiResList: imeiResList, labelDetails: labelDetails)));
  }
}
