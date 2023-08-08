import 'package:eirs/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../constants/image_path.dart';
import '../../../constants/strings.dart';
import '../../../helper/app_states_notifier.dart';
import '../../../helper/shared_pref.dart';
import '../../../theme/colors.dart';
import '../../component/app_bar_with_title.dart';
import '../../component/button_opacity.dart';
import '../../component/custom_progress_indicator.dart';
import '../../component/error_page.dart';
import '../../component/input_borders.dart';
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
  String emptyString = "";
  bool enableCheckImeiButton = true;
  LabelDetails? labelDetails;
  String selectedLng = StringConstants.englishCode;
  final Map<String, TextEditingController> _controllerMap = {};

  @override
  void initState() {
    super.initState();
    getLocale().then((languageCode) {
      selectedLng = languageCode;
    });
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
            return CustomProgressIndicator(
                labelDetails: labelDetails, textColor: Colors.white);
          }
          if (state is CheckMultiImeiErrorState) {
            return Container(
              color: Colors.white,
              child: ErrorPage(
                  labelDetails: labelDetails,
                  callback: (value) {
                    _reloadPage();
                  }),
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
            (widget.data.length > 3)
                ? SingleChildScrollView(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height / 3,
                      child: _listWidget(data),
                    ),
                  )
                : SingleChildScrollView(
                    child: _listWidget(data),
                  ),
            Container(height: 20),
            AppButtonOpacity(
              width: 200,
              isLoading: false,
              isEnable: enableCheckImeiButton,
              child: Text(labelDetails?.check ?? emptyString),
              onPressed: () => _checkImei(context),
            )
          ],
        ),
      ),
    );
  }

  bool validInputImeiField() {
    bool isValidImei = true;
    _controllerMap.forEach((key, value) {
      if (value.text.length < 15) {
        isValidImei = false;
        return;
      }
    });
    return isValidImei;
  }

  Widget _listWidget(Map<String, dynamic> values) {
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: values.length,
      itemBuilder: (BuildContext context, int index) {
        String key = values.keys.elementAt(index);
        final controller = _getControllerOf(key);
        controller.addListener(() {
          setState(() {
            enableCheckImeiButton = validInputImeiField();
          });
        });
        return ListTile(
          title: Text("${StringConstants.imei} ${index + 1}"),
          subtitle: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: _inputFieldWidget(controller),
                ),
                InkWell(
                  onTap: () => _removeItemFromMap(key),
                  child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: SvgPicture.asset(ImageConstants.crossIcon)),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  TextEditingController _getControllerOf(String name) {
    var controller = _controllerMap[name];
    if (controller == null) {
      controller = TextEditingController(text: name);
      _controllerMap[name] = controller;
    }
    return controller;
  }

  Widget _inputFieldWidget(TextEditingController imeiController) {
    return SizedBox(
      height: 40,
      child: TextFormField(
        enableInteractiveSelection: true,
        inputFormatters: [
          LengthLimitingTextInputFormatter(15),
          FilteringTextInputFormatter.digitsOnly
        ],
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        maxLines: 1,
        textAlign: TextAlign.left,
        cursorHeight: 18,
        style: const TextStyle(fontSize: 14),
        controller: imeiController,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            filled: true,
            hintText: labelDetails?.enterFifteenDigit ?? emptyString,
            hintStyle: const TextStyle(fontSize: 10),
            fillColor: Colors.white70,
            enabledBorder: (imeiController.text.length == 15)
                ? InputBorders.focused
                : InputBorders.enabled,
            errorBorder: InputBorders.error,
            focusedErrorBorder: InputBorders.error,
            border: InputBorders.border,
            focusedBorder: (imeiController.text.length == 15)
                ? InputBorders.focused
                : InputBorders.border),
      ),
    );
  }

  void _showErrorMsg(String errorMsg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        errorMsg,
        style: const TextStyle(color: Colors.red, fontSize: 16),
      ),
    ));
  }

  void _removeItemFromMap(String key) {
    widget.data.remove(key);
    _controllerMap.remove(key);
    if (widget.data.isEmpty) {
      return Navigator.pop(context);
    }
    setState(() {
      enableCheckImeiButton = validInputImeiField();
    });
  }

  void _checkImei(BuildContext context) {
    List<String> imeiList = [];
    _controllerMap.forEach((key, value) {
      imeiList.add(value.text);
    });
    if (imeiList.isEmpty) {
      return _showErrorMsg(labelDetails?.noImeiSelected ?? emptyString);
    }
    BlocProvider.of<CheckMultiImeiBloc>(context).add(CheckMultiImeiInitEvent(
        imeiMap: imeiList,
        languageType: selectedLng,
        requestCode: checkMultiImeiReq));
  }

  void _reloadPage() {
    BlocProvider.of<CheckMultiImeiBloc>(context)
        .add(CheckMultiImeiInitEvent(requestCode: pageRefresh));
  }

  void _navigateResultScreen(List<MultiImeiRes> imeiResList) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => MultiImeiResultScreen(
            imeiResList: imeiResList, labelDetails: labelDetails)));
  }
}
