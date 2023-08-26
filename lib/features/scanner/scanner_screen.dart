import 'dart:async';

import 'package:eirs/features/launcher/data/models/device_details_res.dart';
import 'package:eirs/features/scanner/data/business_logic/scanner_bloc.dart';
import 'package:eirs/features/scanner/data/business_logic/scanner_state.dart';
import 'package:eirs/features/scanner/scanner_animation_widget.dart';
import 'package:eirs/features/scanner/scanner_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../../helper/app_states_notifier.dart';
import '../check_multi_imei/data/business_logic/check_multi_imei_bloc.dart';
import '../check_multi_imei/presentation/imei_list.dart';
import '../component/app_bar_with_title.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage>
    with SingleTickerProviderStateMixin {
  bool isMultiScan = true;
  MobileScannerController cameraController =
      MobileScannerController(formats: [BarcodeFormat.all]);
  bool resetBarcodeOverlay = false;
  bool showScreenTimer = true;
  var uniqueImei = <String, int>{};
  late Timer _timer;
  int _start = 10;
  bool isTimerStarted = false;
  bool isNavigateNext = false;
  bool isDetectionStarted = false;
  Barcode? barcode;
  BarcodeCapture? captureBarcode;
  MobileScannerArguments? arguments;
  int initialDetectionValue = 0;
  int lastDetectionValue = 0;
  LabelDetails? labelDetails;
  late AnimationController _animationController;
  AnimationStatus animationStatus = AnimationStatus.forward;
  bool selected = false;
  bool upDown = true;

  @override
  void initState() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    Future<void>.delayed(const Duration(seconds: 2), () {
      // Call set state to re-render the widget with the new position.
      setState(() {
        // Animate it.
        _animationController.repeat(reverse: true);
      });
    });
    _animationController.forward(from: 0);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    labelDetails = Provider.of<AppStatesNotifier>(context).value;
  }

  Future<void> onDetect(BarcodeCapture barcode) async {
    captureBarcode = barcode;
    setState(() {
      if (!isDetectionStarted) {
        isDetectionStarted = true;
      }
      resetBarcodeOverlay = false;
      initialDetectionValue++;
      this.barcode = barcode.barcodes.first;
    });
    final List<Barcode> barcodes = barcode.barcodes;
    for (final barcode in barcodes) {
      getScanBarCodeResult(barcode.rawValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scanWindow = Rect.fromCenter(
      center: MediaQuery.of(context).size.center(Offset.zero),
      width: 300,
      height: 300,
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
                onScannerStarted: (arguments) async {
                  setState(() {
                    this.arguments = arguments;
                  });
                },
                onDetect: onDetect,
              ),
              /* CustomPaint(
                painter: BarcodeOverlay(
                    barcode: barcode,
                    arguments: arguments,
                    boxFit: BoxFit.contain,
                    capture: captureBarcode,
                    resetBarcodeOverlay: resetBarcodeOverlay),
              ),*/
              if (arguments != null)
                CustomPaint(
                  painter: ScannerOverlay(),
                ),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 300,
                  height: 150,
                  child: ScannerAnimation(
                    animation: _animationController,
                  ),
                ),
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
        // Call setState to refresh the page.
        resetUiElement();
      });
      uniqueImei.clear();
    });
  }

  void resetUiElement() {
    initialDetectionValue = 0;
    lastDetectionValue = 0;
    resetBarcodeOverlay = true;
    showScreenTimer = true;
    isDetectionStarted = false;
    _start = 10;
    cameraController.start();
    isNavigateNext = false;
    isTimerStarted = false;
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
            if (lastDetectionValue == initialDetectionValue) {
              resetBarcodeOverlay = true;
            }
            lastDetectionValue = initialDetectionValue;
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

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
