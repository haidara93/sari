import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Widget title;
  final bool isEnabled;
  final double hieght;
  final Color color;
  final Function() onTap;

  CustomButton(
      {required this.title,
      this.isEnabled = true,
      this.hieght = 44,
      required this.onTap,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: hieght,
      decoration: BoxDecoration(
        color: isEnabled ? color : Colors.grey,
        borderRadius: BorderRadius.circular(100),
        // border: const Border(
        //   top: BorderSide(width: 1),
        //   right: BorderSide(width: 1),
        //   left: BorderSide(width: 1),
        //   bottom: BorderSide(width: 1),
        // ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(100),
          onTap: onTap,
          child: Center(
            child: title,
          ),
        ),
      ),
    );
  }
}
