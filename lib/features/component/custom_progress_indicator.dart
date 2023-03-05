import 'package:eirs/constants/strings.dart';
import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatelessWidget {
  const CustomProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const <Widget>[
          CircularProgressIndicator(
            color: Colors.orange,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              StringConstants.loadingTxt,
              style: TextStyle(fontSize: 18.0),
            ),
          )
        ],
      ),
    );
  }
}
