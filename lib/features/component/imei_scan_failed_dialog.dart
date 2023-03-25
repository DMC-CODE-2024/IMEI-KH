import 'package:eirs/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helper/app_states_notifier.dart';
import '../../theme/colors.dart';
import '../launcher/data/models/device_details_res.dart';

class ImeiScanFailedDialog extends StatefulWidget {
  const ImeiScanFailedDialog({
    Key? key,
    required this.callback,
  }) : super(key: key);

  final VoidCallback callback;

  @override
  State<StatefulWidget> createState() {
    return _ImeiScanFailedDialogState();
  }
}

class _ImeiScanFailedDialogState extends State<ImeiScanFailedDialog> {
  LabelDetails? labelDetails;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    labelDetails = Provider.of<AppStatesNotifier>(context).value;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                labelDetails?.scanFailedMsg ?? StringConstants.scanFailedMsg,
                style: TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 20),
              ),
            ),
            Text(
              labelDetails?.scanFailedDesc ?? StringConstants.scanFailedDesc,
              style: TextStyle(
                  color: AppColors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 16),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18),
              child: Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          labelDetails?.negativeBtnTxt ??
                              StringConstants.negativeBtnTxt,
                          style: TextStyle(
                              fontSize: 14.0,
                              color: AppColors.buttonColor,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Container(
                      width: 20,
                    ),
                    InkWell(
                      onTap: () => _navigateNext(),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          labelDetails?.positiveBtnTxt ??
                              StringConstants.positiveBtnTxt,
                          style: TextStyle(
                              fontSize: 14.0,
                              color: AppColors.buttonColor,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _navigateNext() {
    Navigator.pop(context);
    widget.callback.call();
  }
}
