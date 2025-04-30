import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class AppTextButton extends StatelessWidget {
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? borderSideColor;
  final Widget? childwidget;

  final double? horizontalPadding;
  final double? verticalPadding;
  final double? buttonWidth;
  final double? buttonHeight;
  final String buttonText;
  final TextStyle textStyle;

  final VoidCallback? onPressed;
  const AppTextButton({
    super.key,
    this.borderRadius,
    this.backgroundColor,
    this.horizontalPadding,
    this.verticalPadding,
    this.buttonHeight,
    this.buttonWidth,
    required this.buttonText,
    required this.textStyle,
    required this.onPressed,
    this.borderSideColor,
    this.childwidget,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            side: BorderSide(color: borderSideColor ?? Colors.transparent),
            borderRadius: BorderRadius.circular(borderRadius ?? 15.0),
          ),
        ),
        backgroundColor: WidgetStatePropertyAll(
          backgroundColor ?? Colors.yellow,
        ),
        padding: WidgetStateProperty.all<EdgeInsets>(
          EdgeInsets.symmetric(
            horizontal: horizontalPadding?.w ?? 1.w,
            vertical: verticalPadding?.h ?? 1.h,
          ),
        ),
        fixedSize: WidgetStateProperty.all(
          Size(buttonWidth?.w ?? 80.w, buttonHeight ?? 40.h),
        ),
      ),
      onPressed: onPressed,
      child: childwidget ??
          Text(
            buttonText,
            textAlign: TextAlign.center,
            style: textStyle,
          ),
    );
  }
}
