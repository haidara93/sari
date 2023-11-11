import 'package:custome_mobile/helpers/color_constants.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Widget title;
  final bool isEnabled;
  final double hieght;
  final Color? color;
  final Function() onTap;

  const CustomButton(
      {super.key,
      required this.title,
      this.isEnabled = true,
      this.hieght = 44,
      required this.onTap,
      this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: hieght,
        decoration: BoxDecoration(
          color: color ?? Colors.white,
          // color: isEnabled ? color : Colors.white,
          borderRadius: BorderRadius.circular(100),
          border: Border(
            top: BorderSide(width: 1, color: color ?? AppColor.activeGreen),
            right: BorderSide(width: 1, color: color ?? AppColor.activeGreen),
            left: BorderSide(width: 1, color: color ?? AppColor.activeGreen),
            bottom: BorderSide(width: 1, color: color ?? AppColor.activeGreen),
          ),
        ),
        child: Center(
          child: title,
        ),
      ),
    );
  }
}
