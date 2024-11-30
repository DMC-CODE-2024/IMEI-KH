import 'package:eirs/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../constants/image_path.dart';
import '../../helper/app_states_notifier.dart';
import '../component/app_bar_with_title.dart';
import '../launcher/data/models/device_details_res.dart';

//Error screen while scanning bar code
class BarcodeErrorWidget extends StatefulWidget {
  const BarcodeErrorWidget({super.key});

  @override
  State<BarcodeErrorWidget> createState() => _BarcodeErrorWidgetState();
}

class _BarcodeErrorWidgetState extends State<BarcodeErrorWidget> {
  LabelDetails? labelDetails;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    labelDetails = Provider.of<AppStatesNotifier>(context).value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBarWithTitleOnly(title: labelDetails?.scanCode ?? ""),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    ImageConstants.warningIcon,
                    width: 40,
                    height: 38,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      labelDetails?.invalidBarcode ??
                          StringConstants.invalidBarcode,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: InkWell(
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                onTap: () => Navigator.pop(context),
                child: Container(
                  height: 38.0,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: Colors.white, width: 1.0),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Center(
                    child: Text(
                      labelDetails?.tryAgain?.toUpperCase() ??
                          StringConstants.tryAgain,
                      style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
