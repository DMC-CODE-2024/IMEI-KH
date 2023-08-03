import 'package:eirs/constants/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';

class AppButtonOpacity extends StatelessWidget {
  const AppButtonOpacity(
      {Key? key,
      required this.child,
      required this.onPressed,
      this.isLoading = false,
      this.isEnable = false,
      this.width = double.infinity})
      : super(key: key);
  final double? width;
  final Widget? child;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnable;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(
          fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.white),
      child: Opacity(
        opacity: isEnable ? 1.0 : 0.6,
        child: GestureDetector(
          onTap: isEnable ? onPressed : () => {},
          child: AnimatedSwitcher(
            duration: animationDuration,
            transitionBuilder: (child, animation) => ScaleTransition(
              scale: animation,
              child: child,
            ),
            child: Container(
              alignment: Alignment.center,
              width: width ?? double.infinity,
              height: 45,
              padding: const EdgeInsets.all(AppSpacings.m),
              constraints: const BoxConstraints(minWidth: 40),
              decoration: BoxDecoration(
                color: AppColors.buttonColor,
                borderRadius: BorderRadius.circular(AppSpacings.l),
              ),
              child: Center(
                key: ValueKey(isLoading),
                child:
                    isLoading ? const Text(StringConstants.checkImei,textAlign: TextAlign.center,) : child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
