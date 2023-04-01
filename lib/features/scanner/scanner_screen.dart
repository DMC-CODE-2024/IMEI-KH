import 'dart:async';

import 'package:eirs/features/launcher/data/models/device_details_res.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../check_multi_imei/data/business_logic/check_multi_imei_bloc.dart';
import '../check_multi_imei/presentation/imei_list.dart';
import '../component/app_bar_with_title.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key, required this.labelDetails});

  final LabelDetails? labelDetails;

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
  bool showScreenTimer = true;
  int successScans = 0;
  int failedScans = 0;
  var uniqueImei = <String, int>{};
  late Timer _timer;
  int _start = 10;
  bool isTimerStarted = false;
  bool isNavigateNext = false;
  bool isDetectionStarted = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isCameraSupported = defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android;
    return Scaffold(
      appBar: AppBarWithTitleOnly(title: widget.labelDetails?.scanCode ?? ""),
      body: Builder(
        builder: (context) {
          return Stack(
            children: [
              MobileScanner(
                fit: BoxFit.fitHeight,
                controller: cameraController,
                onDetect: (capture) {
                  if (!isDetectionStarted) {
                    setState(() {
                      isDetectionStarted = true;
                    });
                  }
                  final List<Barcode> barcodes = capture.barcodes;
                  for (final barcode in barcodes) {
                    getScanBarCodeResult(barcode.rawValue);
                  }
                },
              ),
              if (showScreenTimer && isDetectionStarted)
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2),
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.7),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "00:${_start.toString().padLeft(2, '0')}",
                          style: const TextStyle(fontSize: 14),
                        )
                      ],
                    ),
                  ),
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
      if (uniqueImei.containsKey(code)) {
        var count = uniqueImei[code];
        if (count == 3) {
          navigateNext();
        }
        if (count != null) uniqueImei[code] = count + 1;
      } else {
        uniqueImei[code] = 1;
/*        setState(() {
          successScans = successScans + 1;
        });*/
      }
      stopTimer();
    }
    startTimer();
  }

  void navigateNext() {
    cameraController.stop();
    stopTimer();
    isNavigateNext = true;
    if (uniqueImei.isEmpty) {
      return Navigator.pop(context, true);
    }
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: CheckMultiImeiBloc(),
          child: ImeiListPage(data: uniqueImei),
        ),
      ),
    )
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
            _start--;
          }
          setState(() {
            _start;
          });
        },
      );
    }
  }

  void stopTimer() {
    if (isTimerStarted) {
      setState(() {
        _start = 10;
      });
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
