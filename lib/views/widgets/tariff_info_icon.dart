import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TariffInfoIcon extends StatelessWidget {
  const TariffInfoIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 10.w),
      child: SvgPicture.asset(
        "assets/icons/expansionTileIcon.svg",
        width: 20.w,
        height: 20.h,
      ),
      // child: Image.asset(
      //   "assets/icons/expansionTileIcon.png",
      //   width: 20.w,
      //   height: 20.h,
      // ),
      // child: Icon(
      //   Icons.info_outline,
      //   color: Colors.cyan[200],
      //   size: 25.sp,
      // ),
    );
  }
}
