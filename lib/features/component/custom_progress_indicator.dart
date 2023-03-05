import 'package:eirs/constants/strings.dart';
import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatelessWidget {
  const CustomProgressIndicator({super.key, required this.textColor});

  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const CircularProgressIndicator(
            color: Colors.orange,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              StringConstants.loadingTxt,
              style: TextStyle(fontSize: 18.0, color: textColor),
            ),
          )
        ],
      ),
    );
  }
}
