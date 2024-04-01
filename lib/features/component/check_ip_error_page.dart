import 'package:flutter/material.dart';

import '../../constants/image_path.dart';
import '../launcher/data/models/device_details_res.dart';

class CheckIpErrorPage extends StatelessWidget {
  const CheckIpErrorPage(
      {super.key, this.labelDetails, this.callback, this.textColor});

  final LabelDetails? labelDetails;
  final Function? callback;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(ImageConstants.checkIpError),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                  child: Text(
                    labelDetails?.checkIpErrorMessage ??
                        "The Mobile App is currently not available in your country or region",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16.0,
                        color: (textColor == null) ? Colors.black : textColor),
                  ),
                )
              ],
            ),
          )),
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                labelDetails?.checkIpErrorMessage ?? "Back to Home",
                style: const TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.w400),
              ),
            ),
            onTap: () => callback?.call(true),
          )
        ],
      ),
    );
  }
}
