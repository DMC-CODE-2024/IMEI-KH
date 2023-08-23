import 'dart:io';
import 'dart:ui';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeOverlay extends CustomPainter {
  BarcodeOverlay(
      {required this.barcode,
      required this.arguments,
      required this.boxFit,
      required this.capture,
      required this.resetBarcodeOverlay});

  final bool resetBarcodeOverlay;
  final BarcodeCapture? capture;
  final Barcode? barcode;
  final MobileScannerArguments? arguments;
  final BoxFit? boxFit;

  @override
  void paint(Canvas canvas, Size size) {
    if (barcode == null ||
        barcode?.corners == null ||
        boxFit == null ||
        arguments == null ||
        capture == null ||
        resetBarcodeOverlay) {
      Paint eraserPaint = Paint()
        ..color = Colors.transparent
        ..blendMode = BlendMode.clear
        ..strokeWidth = 0
        ..style = PaintingStyle.stroke
        ..isAntiAlias = true;
      canvas.drawPath(Path(), eraserPaint);
      return;
    }
    final adjustedSize = applyBoxFit(boxFit!, arguments!.size, size);

    double verticalPadding = size.height - adjustedSize.destination.height;
    double horizontalPadding = size.width - adjustedSize.destination.width;
    if (verticalPadding > 0) {
      verticalPadding = verticalPadding / 2;
    } else {
      verticalPadding = 0;
    }

    if (horizontalPadding > 0) {
      horizontalPadding = horizontalPadding / 2;
    } else {
      horizontalPadding = 0;
    }

    final ratioWidth =
        (Platform.isIOS ? capture!.width! : arguments!.size.width) /
            adjustedSize.destination.width;
    final ratioHeight =
        (Platform.isIOS ? capture!.height! : arguments!.size.height) /
            adjustedSize.destination.height;

    final List<Offset> adjustedOffset = [];
    for (final offset in barcode!.corners!) {
      adjustedOffset.add(
        Offset(
          offset.dx / ratioWidth + horizontalPadding,
          offset.dy / ratioHeight + verticalPadding,
        ),
      );
    }
    final cutoutPath = Path()..addPolygon(adjustedOffset, true);

    final backgroundPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawPath(cutoutPath, backgroundPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
