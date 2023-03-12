import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants/image_path.dart';
import '../../theme/colors.dart';
import '../launcher/data/models/device_details_res.dart';

class NeedAnyHelpWidget extends StatelessWidget {
  const NeedAnyHelpWidget({
    super.key,
    this.labelDetails,
  });

  final LabelDetails? labelDetails;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
          color: AppColors.needAnyHelpBg,
          borderRadius: const BorderRadius.all(Radius.circular(5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${labelDetails?.needAnyHelp} ${labelDetails?.contactUs}" ??
                      "",
                  style: TextStyle(color: AppColors.black, fontSize: 14.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    labelDetails?.emailId ?? "",
                    style: TextStyle(color: AppColors.black, fontSize: 14.0),
                  ),
                )
              ],
            ),
          ),
          SvgPicture.asset(
            ImageConstants.helpIcon,
            width: 30,
            height: 30,
          )
        ],
      ),
    );
  }
}
