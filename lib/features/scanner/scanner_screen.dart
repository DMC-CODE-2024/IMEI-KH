import 'dart:async';

import 'package:eirs/features/launcher/data/models/device_details_res.dart';
import 'package:eirs/features/scanner/data/business_logic/scanner_bloc.dart';
import 'package:eirs/features/scanner/data/business_logic/scanner_state.dart';
import 'package:eirs/features/scanner/scanner_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

import '../../helper/app_states_notifier.dart';
import '../check_multi_imei/data/business_logic/check_multi_imei_bloc.dart';
import '../check_multi_imei/presentation/imei_list.dart';
import '../component/app_bar_with_title.dart';
import 'barcode_overlay.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  bool isMultiScan = true;
  MobileScannerController cameraController =
      MobileScannerController(formats: [BarcodeFormat.all]);
  bool resetBarcodeOverlay = false;
  bool showScreenTimer = true;
  int successScans = 0;
  int failedScans = 0;
  var uniqueImei = <String, int>{};
  late Timer _timer;
  int _start = 10;
  bool isTimerStarted = false;
  bool isNavigateNext = false;
  bool isDetectionStarted = false;
  Barcode? barcode;
  BarcodeCapture? captureBarcode;
  MobileScannerArguments? arguments;

  //Uint8List? capturedImg;
  LabelDetails? labelDetails;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    labelDetails = Provider.of<AppStatesNotifier>(context).value;
  }

  Future<void> onDetect(BarcodeCapture barcode) async {
    captureBarcode = barcode;
    setState(() {
      if (!isDetectionStarted) {
        resetBarcodeOverlay = false;
        isDetectionStarted = true;
      }
      this.barcode = barcode.barcodes.first;
    });
    //capturedImg = capture.image;
    final List<Barcode> barcodes = barcode.barcodes;
    for (final barcode in barcodes) {
      getScanBarCodeResult(barcode.rawValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scanWindow = Rect.fromCenter(
      center: MediaQuery.of(context).size.center(Offset.zero),
      width: 250,
      height: 250,
    );
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBarWithTitleOnly(title: labelDetails?.scanCode ?? ""),
      body: BlocConsumer<ScannerBloc, ScannerState>(
        builder: (context, state) {
          return Stack(
            fit: StackFit.expand,
            children: [
              MobileScanner(
                fit: BoxFit.contain,
                scanWindow: scanWindow,
                controller: cameraController,
                onScannerStarted: (arguments) {
                  setState(() {
                    this.arguments = arguments;
                  });
                },
                onDetect: onDetect,
              ),
              if (showScreenTimer && isDetectionStarted)
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(width: 2),
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      child: Center(
                        child: Text(
                          "00:${_start.toString().padLeft(2, '0')}",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                ),
              CustomPaint(
                painter: BarcodeOverlay(
                    barcode: barcode,
                    arguments: arguments,
                    boxFit: BoxFit.contain,
                    capture: captureBarcode,
                    resetBarcodeOverlay: resetBarcodeOverlay),
              ),
              CustomPaint(
                painter: ScannerOverlay(scanWindow),
              ),
            ],
          );
        },
        listener: (context, state) {},
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
      /* ScannerBloc bloc = BlocProvider.of<ScannerBloc>(context);
      bloc.add(ScannerInitEvent(imgBytes: capturedImg));*/
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
        resetBarcodeOverlay = true;
        showScreenTimer = true;
        isDetectionStarted = false;
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
}
