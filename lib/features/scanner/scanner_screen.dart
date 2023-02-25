import 'dart:async';
import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'debug_info_widget.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({Key? key}) : super(key: key);

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  bool isMultiScan = true;

  bool showDebugInfo = true;
  int successScans = 0;
  int failedScans = 0;
  var uniqueImei = <String, int>{};
  late Timer _timer;
  int _start = 10;
  bool isTimerStarted = false;

  @override
  Widget build(BuildContext context) {
    final isCameraSupported = defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android;
    return Scaffold(
        appBar: AppBar(title: const Text("Scan Code")),
        body: WillPopScope(
          onWillPop: () {
            //on Back button press, you can use WillPopScope for another purpose also.
            Navigator.pop(context, uniqueImei); //return data along with pop
            return Future(
                () => false); //onWillPop is Future<bool> so return false
          },
          child: Builder(
            builder: (context) {
              return Stack(
                children: [
                  MobileScanner(
                    fit: BoxFit.fitHeight,
                    controller: MobileScannerController(
                      // facing: CameraFacing.back,
                      // torchEnabled: false,
                      formats: [BarcodeFormat.all],
                      returnImage: true,
                    ),
                    onDetect: (capture) {
                      final List<Barcode> barcodes = capture.barcodes;
                      final Uint8List? image = capture.image;
                      for (final barcode in barcodes) {
                        getScanBarCodeResult(barcode.rawValue);
                      }
                    },
                  ),
                  if (showDebugInfo)
                    DebugInfoWidget(
                      successScans: successScans,
                      failedScans: failedScans,
                      onReset: _onReset,
                    ),
                ],
              );
            },
          ),
        ));
  }

  bool _isNumeric(String str) {
    return double.tryParse(str) != null && str.length == 15;
  }

  void getScanBarCodeResult(String? code) {
    if (code != null && _isNumeric(code)) {
      setState(() {
        successScans = successScans + 1;
      });
      if (uniqueImei.containsKey(code)) {
        var count = uniqueImei[code];
        if (count == 3) {
          stopTimer();
          Navigator.pop(context, uniqueImei);
        }
        if (count != null) uniqueImei[code] = count + 1;
      } else {
        uniqueImei[code] = 1;
      }
      stopTimer();
    }
    startTimer();
  }

  void startTimer() {
    if (!isTimerStarted) {
      isTimerStarted = true;
      const oneSec = Duration(seconds: 1);
      _timer = Timer.periodic(
        oneSec,
        (Timer timer) {
          if (_start == 0) {
            setState(() {
              Navigator.pop(context, uniqueImei);
              timer.cancel();
            });
          } else {
            setState(() {
              _start--;
            });
          }
        },
      );
    }
  }

  void stopTimer() {
    if (isTimerStarted) {
      _start = 10;
      isTimerStarted = false;
      _timer.cancel();
    }
  }

  _onReset() {
    setState(() {
      successScans = 0;
      failedScans = 0;
    });
  }
}
