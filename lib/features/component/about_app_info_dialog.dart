import 'package:eirs/constants/strings.dart';
import 'package:eirs/features/privacy_policy/privacy_policy_screen.dart';
import 'package:flutter/material.dart';

import '../../constants/image_path.dart';
import '../../theme/colors.dart';
import '../launcher/data/models/device_details_res.dart';

class AboutAppInfoDialog extends StatefulWidget {
  const AboutAppInfoDialog({super.key, this.labelDetails});

  final LabelDetails? labelDetails;

  @override
  State<StatefulWidget> createState() {
    return _AboutAppInfoDialogState();
  }
}

class _AboutAppInfoDialogState extends State<AboutAppInfoDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              ImageConstants.aboutUs,
              width: 200,
              height: 80,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                widget.labelDetails?.checkImeiMesssage ??
                    StringConstants.aboutApp,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PrivacyPolicyScreen()));
                  },
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 3),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.blue,
                          width: 1.0, // Underline thickness
                        ),
                      ),
                    ),
                    child: const Text(
                      "Privacy & Policy",
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    widget.labelDetails?.ok ?? "",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.buttonColor),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
