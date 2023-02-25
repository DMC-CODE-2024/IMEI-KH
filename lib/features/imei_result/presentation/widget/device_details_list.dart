import 'package:flutter/material.dart';

import '../../../../theme/colors.dart';

class DeviceDetailList extends StatelessWidget {
  const DeviceDetailList({
    Key? key,
    required this.data,
  }) : super(key: key);

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey),
        borderRadius: const BorderRadius.all(Radius.circular(5.0) //
            ),
      ),
      child: Table(
        border: const TableBorder(
            horizontalInside: BorderSide(
                width: 1, color: Colors.grey, style: BorderStyle.solid)),
        children: data.entries.map((deviceDetailMap) {
          return TableRow(children: [
            TableCell(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(deviceDetailMap.key),
                    Text(deviceDetailMap.value),
                  ],
                ),
              ),
            )
          ]);
        }).toList(),
      ),
    );
  }
}
