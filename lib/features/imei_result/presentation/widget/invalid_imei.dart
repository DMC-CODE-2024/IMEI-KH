import 'package:flutter/material.dart';

import '../../../../theme/colors.dart';

class InvalidImeiResult extends StatelessWidget {
  const InvalidImeiResult({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 5.0),
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 25),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.grey),
            borderRadius: const BorderRadius.all(Radius.circular(5.0) //
                ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Remark',
                style: TextStyle(fontSize: 14.0, color: AppColors.black),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  'The IMEI is not as per the 3GPP specification.',
                  style: TextStyle(fontSize: 14.0, color: AppColors.black),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 5.0),
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 25),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.grey),
            borderRadius: const BorderRadius.all(Radius.circular(15.0) //
                ),
          ),
          child: Text(
            "Call to action to be decided later based on error",
            style: TextStyle(fontSize: 14, color: AppColors.grey),
          ),
        )
      ],
    );
  }
}
