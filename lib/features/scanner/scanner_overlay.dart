import 'dart:math';
import 'package:flutter/material.dart';

//Scanner overlay with four round arcs inside barcode detecting and marking
class ScannerOverlay extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final canvasRect = Offset.zero & size;
    const rectWidth = 310.0;
    final rect = Rect.fromCircle(
      center: canvasRect.center,
      radius: (rectWidth - 10) / 2,
    );
    const radius = 8.0;
    const strokeWidth = 3.0;
    const extend = radius + 24.0;
    const arcSize = Size.square(radius * 2);

    canvas.drawPath(
      Path()
        ..fillType = PathFillType.evenOdd
        ..addRRect(
          RRect.fromRectAndRadius(
            rect,
            const Radius.circular(radius),
          ).deflate(strokeWidth / 2),
        )
        ..addRect(canvasRect),
      Paint()..color = Colors.black26,
    );

    canvas.save();
    canvas.translate(rect.left - 5, rect.top - 5);
    final path = Path();
    for (var i = 0; i < 4; i++) {
      final l = i & 1 == 0;
      final t = i & 2 == 0;
      path
        ..moveTo(l ? 0 : rectWidth, t ? extend : rectWidth - extend)
        ..arcTo(
            Offset(l ? 0 : rectWidth - arcSize.width,
                t ? 0 : rectWidth - arcSize.width) &
            arcSize,
            l ? pi : pi * 2,
            l == t ? pi / 2 : -pi / 2,
            false)
        ..lineTo(l ? extend : rectWidth - extend, t ? 0 : rectWidth);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.deepOrange
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(ScannerOverlay oldDelegate) => false;
}
