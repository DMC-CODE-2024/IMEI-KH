import 'dart:async';

import 'package:eirs/constants/Validator.dart';
import 'package:eirs/constants/strings.dart';
import 'package:eirs/features/launcher/data/models/device_details_res.dart';
import 'package:eirs/features/scanner/barcode_error_widget.dart';
import 'package:eirs/features/scanner/data/business_logic/scanner_bloc.dart';
import 'package:eirs/features/scanner/data/business_logic/scanner_state.dart';
import 'package:eirs/features/scanner/scanner_animation_widget.dart';
import 'package:eirs/features/scanner/scanner_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

import '../../constants/image_path.dart';
import '../../helper/app_states_notifier.dart';
import '../component/app_bar_with_title.dart';
import '../imei_result/business_logic/check_multi_imei_bloc.dart';
import '../multi_imei_list/presentation/imei_list.dart';
import 'barcode_overlay.dart';

//Scanner home screen for displaying camera and all other UI
class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage>
    with SingleTickerProviderStateMixin {
  bool isMultiScan = true;
  MobileScannerController cameraController = MobileScannerController(
      formats: [BarcodeFormat.code128],
      detectionSpeed: DetectionSpeed.normal,
      detectionTimeoutMs: 500,
      returnImage: false);
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
  bool isCameraScan = true;
  int totalTimerCount = 0;

  void _enablePortraitMode() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void initState() {
    _enablePortraitMode();
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
    if (isCameraScan) {
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
    } else {
      getImageBarCodeResult(barcode.barcodes);
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
      body: SafeArea(
          bottom: true,
          child: BlocConsumer<ScannerBloc, ScannerState>(
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
                  CustomPaint(
                    painter: BarcodeOverlay(
                        barcode: barcode,
                        arguments: arguments,
                        boxFit: BoxFit.contain,
                        capture: captureBarcode,
                        resetBarcodeOverlay: resetBarcodeOverlay),
                  ),
                  if (arguments != null)
                    CustomPaint(
                      painter: ScannerOverlay(),
                    ),
                  if (arguments != null)
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 20),
                            child: _flashWidget(),
                          ),
                          _galleryImageWidget()
                        ],
                      ),
                    ),
                  )
                ],
              );
            },
            listener: (context, state) {},
          )),
    );
  }

  Widget _flashWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          color: Colors.white,
          icon: ValueListenableBuilder(
            valueListenable: cameraController.torchState,
            builder: (context, state, child) {
              switch (state) {
                case TorchState.off:
                  return SvgPicture.asset(
                    ImageConstants.flashIconOff,
                    width: 40,
                    height: 40,
                  );
                case TorchState.on:
                  return SvgPicture.asset(
                    ImageConstants.flashIconOn,
                    width: 40,
                    height: 40,
                  );
              }
            },
          ),
          iconSize: 32.0,
          onPressed: () => cameraController.toggleTorch(),
        ),
        Text(
          labelDetails?.flash ?? StringConstants.flashTxt,
          style: const TextStyle(color: Colors.white, fontSize: 16.0),
          textAlign: TextAlign.center,
        )
      ],
    );
  }

  Widget _galleryImageWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          color: Colors.white,
          icon: SvgPicture.asset(
            ImageConstants.uploadBarcode,
            width: 40,
            height: 40,
          ),
          iconSize: 32.0,
          onPressed: () async {
            if (uniqueImei.isNotEmpty) uniqueImei.clear();
            isCameraScan = false;
            stopTimer();
            final ImagePicker picker = ImagePicker();
            // Pick an image
            final XFile? image = await picker.pickImage(
              source: ImageSource.gallery,
            );
            if (image != null) {
              bool isAnalyze = await cameraController.analyzeImage(image.path);
              if (!isAnalyze) {
                isCameraScan = true;
                if (!mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BarcodeErrorWidget()),
                ).then((_) {
                  // This block runs when you have come back to the 1st Page from 2nd.
                  setState(() {
                    // Call setState to refresh the page.
                    resetUiElement();
                  });
                  uniqueImei.clear();
                });
              }
            }
          },
        ),
        Text(
          labelDetails?.uploadBarcode ?? StringConstants.uploadBarcode,
          style: const TextStyle(color: Colors.white, fontSize: 16.0),
          textAlign: TextAlign.center,
        )
      ],
    );
  }

  void getImageBarCodeResult(List<Barcode> barcodes) {
    for (final barcode in barcodes) {
      String? code = barcode.rawValue;
      if (code != null && Validator.isNumeric(code)) {
        if (uniqueImei.containsKey(code)) {
          var count = uniqueImei[code];
          if (count != null) uniqueImei[code] = count + 1;
        } else {
          uniqueImei[code] = 1;
        }
      }
    }
    navigateNext();
  }

  void getScanBarCodeResult(String? code) {
    if (code != null && Validator.isNumeric(code)) {
      var count = uniqueImei[code];
      if (uniqueImei.containsKey(code)) {
        if (count != null) uniqueImei[code] = count + 1;
      } else {
        uniqueImei[code] = 1;
      }
      //if (count != null && count < 2) stopTimer();
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
    _enablePortraitMode();
    initialDetectionValue = 0;
    lastDetectionValue = 0;
    resetBarcodeOverlay = true;
    showScreenTimer = true;
    isDetectionStarted = false;
    _start = 10;
    cameraController.start();
    isNavigateNext = false;
    isTimerStarted = false;
    isCameraScan = true;
    totalTimerCount = 0;
  }

  void startTimer() {
    if (!isTimerStarted && !isNavigateNext) {
      isTimerStarted = true;
      const oneSec = Duration(seconds: 1);
      _timer = Timer.periodic(
        oneSec,
        (Timer timer) {
          if (_start == 0) {
            /*totalTimerCount = totalTimerCount + 1;
            if (uniqueImei.entries.every((e) => e.value >= 2) ||
                totalTimerCount >= 3) {
              stopTimer();
              return navigateNext();
            } else {
              _start = 10;
            }*/
            _start = 10;
            stopTimer();
            return navigateNext();
          } else {
            _start--;
            if (uniqueImei.length >= 2) {
              _start = 10;
              stopTimer();
              return navigateNext();
            }
            if (_start <= 4 && uniqueImei.isNotEmpty) {
              _start = 10;
              stopTimer();
              return navigateNext();
            }
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _animationController.dispose();
    super.dispose();
  }
}
