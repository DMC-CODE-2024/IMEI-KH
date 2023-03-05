import 'package:eirs/constants/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';

class AppButton extends StatelessWidget {
  const AppButton(
      {Key? key,
      required this.child,
      required this.onPressed,
      this.isLoading = false,
      this.width = double.infinity})
      : super(key: key);
  final double? width;
  final Widget? child;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(
          fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.white),
      child: InkWell(
        onTap: onPressed,
        child: AnimatedSwitcher(
          duration: animationDuration,
          transitionBuilder: (child, animation) => ScaleTransition(
            scale: animation,
            child: child,
          ),
          child: Container(
            width: width ?? double.infinity,
            padding: const EdgeInsets.all(AppSpacings.m),
            height: 35,
            constraints: const BoxConstraints(minWidth: 40),
            decoration: BoxDecoration(
              color: AppColors.buttonColor,
              borderRadius: BorderRadius.circular(AppSpacings.l),
            ),
            child: Center(
              key: ValueKey(isLoading),
              child: isLoading ? const Text(StringConstants.checkImei) : child,
            ),
          ),
        ),
      ),
    );
  }
}
