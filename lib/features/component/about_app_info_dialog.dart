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
              ImageConstants.splashIcon,
              width: 150,
              height: 60,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                "Developed by Ministry of Post and Telecommunications, this application will verify any mobile device by its IMEI number. IMEI KH App will provide status  of mobile device (Invalid/Blocklist) and other information like manufacturer, band name and model name of the given IMEI. While purchasing a mobile devices, the genuineness of those mobile devices can be verified by using IMEI KH App.",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
              ),
            ),
            Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      widget.labelDetails?.ok ?? "",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: AppColors.primaryColor),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
