import 'package:eirs/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants/image_path.dart';
import '../launcher/data/models/device_details_res.dart';
import 'button.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key, this.labelDetails, this.callback});

  final LabelDetails? labelDetails;
  final Function? callback;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(ImageConstants.errorImg),
          Text(
            labelDetails?.oops ?? StringConstants.oops,
            style: const TextStyle(fontSize: 32.0, color: Colors.black),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
            child: Text(
              labelDetails?.sorryUnableToFetch ?? StringConstants.errorMsg,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16.0, color: Colors.black),
            ),
          ),
          AppButton(
            width: 200,
            isLoading: false,
            child: Text(labelDetails?.tryAgain ?? StringConstants.tryAgain),
            onPressed: () => callback?.call(true),
          )
        ],
      ),
    );
  }
}
