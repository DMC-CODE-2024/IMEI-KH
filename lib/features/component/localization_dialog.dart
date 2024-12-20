import 'package:eirs/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../constants/image_path.dart';
import '../../constants/strings.dart';
import '../../helper/app_states_notifier.dart';
import '../../helper/shared_pref.dart';
import '../launcher/data/models/device_details_res.dart';
import 'button.dart';

class LocalizationDialog extends StatefulWidget {
  const LocalizationDialog({
    Key? key,
    required this.callback,
  }) : super(key: key);

  final Function callback;

  @override
  State<StatefulWidget> createState() {
    return _LocalizationDialogState();
  }
}

class _LocalizationDialogState extends State<LocalizationDialog> {
  bool isEnglish = true;
  LabelDetails? labelDetails;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    labelDetails = Provider.of<AppStatesNotifier>(context).value;
  }

  @override
  void initState() {
    super.initState();
    getLocale().then((languageCode) {
      switch (languageCode) {
        case StringConstants.englishCode:
          setState(() {
            isEnglish = true;
          });
          break;
        case StringConstants.khmerCode:
          setState(() {
            isEnglish = false;
          });
          break;
      }
    });
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
        padding: const EdgeInsets.all(8.0),
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
                      labelDetails?.changeLanguage ?? "",
                      style: TextStyle(
                          fontSize: 16.0,
                          color: AppColors.black,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: SvgPicture.asset(ImageConstants.crossIcon),
                    ))
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.dialogBg,
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              isEnglish = true;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4)),
                                color: isEnglish
                                    ? AppColors.white
                                    : AppColors.dialogBg),
                            child: Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        ImageConstants.englishLanIcon,
                                        width: 26,
                                        height: 13,
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(left: 4),
                                        child: Text(StringConstants.english),
                                      ),
                                    ]),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              isEnglish = false;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4)),
                                color: isEnglish
                                    ? AppColors.dialogBg
                                    : AppColors.white),
                            child: Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        ImageConstants.khmerLanIcon,
                                        width: 26,
                                        height: 15,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 4),
                                        child: Text(labelDetails?.khmer ?? ""),
                                      ),
                                    ]),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 10, right: 10, top: 10, bottom: 20),
              child: AppButton(
                isLoading: false,
                child: Text(labelDetails?.ok ?? ""),
                onPressed: () => _navigateNext(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateNext() {
    widget.callback.call(
        isEnglish ? StringConstants.englishCode : StringConstants.khmerCode);
    Navigator.pop(context);
  }
}
