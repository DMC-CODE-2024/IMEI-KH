import 'package:eirs/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants/image_path.dart';
import '../../main.dart';
import '../launcher/data/models/device_details_res.dart';
import 'button.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key, this.labelDetails, this.callback, this.textColor});

  final LabelDetails? labelDetails;
  final Function? callback;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(ImageConstants.errorImg),
          Text(
            labelDetails?.oops ??
                ((selectedLng == StringConstants.englishCode)
                    ? StringConstants.oops
                    : StringConstants.oopsKh),
            style: TextStyle(
                fontSize: 32.0,
                color: (textColor == null) ? Colors.black : textColor),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
            child: Text(
              labelDetails?.sorryUnableToFetch ??
                  ((selectedLng == StringConstants.englishCode)
                      ? StringConstants.errorMsg
                      : StringConstants.errorMsgKh),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0, color: (textColor == null) ? Colors.black : textColor),
            ),
          ),
          AppButton(
            width: 200,
            isLoading: false,
            child: Text(labelDetails?.tryAgain ??
                ((selectedLng == StringConstants.englishCode)
                    ? StringConstants.tryAgain
                    : StringConstants.tryAgainKh)),
            onPressed: () => callback?.call(true),
          )
        ],
      ),
    );
  }
}
