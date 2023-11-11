import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TariffInfoIcon extends StatelessWidget {
  const TariffInfoIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
      child: Icon(
        Icons.info_outline,
        color: Colors.cyan[200],
        size: 25.sp,
      ),
    );
  }
}
