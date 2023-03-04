import 'dart:async';

import 'package:eirs/features/imei_info/presentation/imei_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../component/app_bar_with_title.dart';
import 'debug_info_widget.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({Key? key}) : super(key: key);

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  bool isMultiScan = true;
  MobileScannerController cameraController = MobileScannerController(
    // facing: CameraFacing.back,
    // torchEnabled: false,
    formats: [BarcodeFormat.all],
    returnImage: true,
  );
  bool showDebugInfo = true;
  int successScans = 0;
  int failedScans = 0;
  var uniqueImei = <String, int>{};
  late Timer _timer;
  int _start = 10;
  bool isTimerStarted = false;
  bool isNavigateNext = false;

  @override
  Widget build(BuildContext context) {
    final isCameraSupported = defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android;
    return Scaffold(
      appBar: const AppBarWithTitleOnly(title: "Scan code"),
      body: Builder(
        builder: (context) {
          return Stack(
            children: [
              MobileScanner(
                fit: BoxFit.fitHeight,
                controller: cameraController,
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
    );
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
          navigateNext();
        }
        if (count != null) uniqueImei[code] = count + 1;
      } else {
        uniqueImei[code] = 1;
      }
      stopTimer();
    }
    startTimer();
  }

  void navigateNext() {
    cameraController.stop();
    stopTimer();
    isNavigateNext = true;
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => ImeiListPage(data: uniqueImei)))
        .then((_) {
      // This block runs when you have come back to the 1st Page from 2nd.
      setState(() {
        _start = 10;
        successScans = 0;
        failedScans = 0;
        cameraController.start();
        isNavigateNext = false;
        isTimerStarted = false;
        // Call setState to refresh the page.
      });
      uniqueImei.clear();
    });
  }

  void startTimer() {
    if (!isTimerStarted && !isNavigateNext) {
      isTimerStarted = true;
      const oneSec = Duration(seconds: 1);
      _timer = Timer.periodic(
        oneSec,
        (Timer timer) {
          if (_start == 0) {
            setState(() {
              navigateNext();
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
