import 'package:eirs/constants/strings.dart';
import 'package:eirs/features/component/button.dart';
import 'package:flutter/material.dart';

import '../../constants/image_path.dart';
import '../../main.dart';
import '../launcher/data/models/device_details_res.dart';

class NoInternetPage extends StatelessWidget {
  const NoInternetPage({super.key, this.labelDetails, required this.callback});

  final LabelDetails? labelDetails;
  final Function callback;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            ImageConstants.noInternet,
            width: 216,
            height: 216,
          ),
          Text(
            labelDetails?.noInternetConnection ??
                ((selectedLng == StringConstants.englishCode)
                    ? StringConstants.noInternet
                    : StringConstants.noInternetKh),
            style: const TextStyle(
                fontSize: 20.0,
                color: Colors.black,
                fontWeight: FontWeight.w400),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 10, right: 70, left: 70, bottom: 30),
            child: Text(
              labelDetails?.makeSureWifiData ??
                  ((selectedLng == StringConstants.englishCode)
                      ? StringConstants.noInternetMsg
                      : StringConstants.noInternetMsgKh),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14.0, color: Colors.black),
            ),
          ),
          AppButton(
            width: 200,
            isLoading: false,
            child: Text(labelDetails?.tryAgain ??
                ((selectedLng == StringConstants.englishCode)
                    ? StringConstants.tryAgain
                    : StringConstants.tryAgainKh)),
            onPressed: () => callback.call(true),
          )
        ],
      ),
    );
  }
}
