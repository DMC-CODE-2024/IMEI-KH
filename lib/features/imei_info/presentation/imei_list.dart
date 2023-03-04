import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants/image_path.dart';
import '../../../constants/strings.dart';
import '../../../theme/colors.dart';
import '../../component/app_bar_with_title.dart';
import '../../component/button.dart';

class ImeiListPage extends StatefulWidget {
  ImeiListPage({
    Key? key,
    required this.data,
  }) : super(key: key);

  Map<String, int> data = <String, int>{};

  @override
  State<ImeiListPage> createState() => _ImeiListPageState();
}

class _ImeiListPageState extends State<ImeiListPage> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const AppBarWithTitleOnly(title: "Scan code"),
      body: showImeiDialog(widget.data),
    );
  }

  Widget showImeiDialog(Map<String, dynamic> data) {
    return Dialog(
      elevation: 0,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      StringConstants.selectImei,
                      style: TextStyle(
                          fontSize: 16.0,
                          color: AppColors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: SvgPicture.asset(ImageConstants.crossIcon)),
                )
              ],
            ),
            _listWidget(data),
            Container(height: 20),
            AppButton(
              width: 200,
              isLoading: false,
              child: const Text(StringConstants.check),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
      ),
    );
  }

  Widget _listWidget(Map<String, dynamic> values) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: values.length,
      itemBuilder: (BuildContext context, int index) {
        String key = values.keys.elementAt(index);
        return InkWell(
          onTap: () => {setState(() => selectedIndex = index)},
          child: ListTile(
            title: Text("IMEI ${index + 1}"),
            subtitle: Container(
              margin: const EdgeInsets.only(top: 8.0),
              padding: const EdgeInsets.only(left: 10, top: 7, bottom: 7),
              decoration: BoxDecoration(
                border: Border.all(
                    color:
                        (selectedIndex == index) ? Colors.blue : Colors.grey),
                borderRadius: const BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              child: Text(key),
            ),
          ),
        );
      },
    );
  }
}
