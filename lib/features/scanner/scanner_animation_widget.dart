import 'package:flutter/material.dart';

//Overlay scanner vertical animating line
class ScannerAnimation extends AnimatedWidget {
  final scanningHeightOffset = 0.4;
  final scanningColor = Colors.blue;

  const ScannerAnimation({super.key, required Animation<double> animation})
      : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) {
      final animation = listenable as Animation<double>;
      final value = animation.value;
      var scorePosition =
          (value * constrains.maxHeight * 2) - (constrains.maxHeight)/2;

      return Container(
        transform: Matrix4.translationValues(0, scorePosition, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: const [0, 0.2, 0.5, 0.6, 0.7, 0.8],
                  colors: [
                    Colors.orange,
                    Colors.orangeAccent.withOpacity(0.5),
                    Colors.purple.withOpacity(0.5),
                    Colors.purpleAccent.withOpacity(0.7),
                    Colors.purpleAccent.withOpacity(0.8),
                    Colors.purple,
                  ],
                ),
              ),
            ),
            Container(
              height: 30,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: const [0, 0.2, 0.5, 0.6, 0.7, 0.8],
                  colors: [
                    Colors.purple.withOpacity(0.1),
                    Colors.purpleAccent.withOpacity(0.1),
                    Colors.purpleAccent.withOpacity(0.1),
                    Colors.purple.withOpacity(0.1),
                    Colors.orange.withOpacity(0.1),
                    Colors.orangeAccent.withOpacity(0.1),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}
