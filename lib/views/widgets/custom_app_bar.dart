import 'package:custome_mobile/helpers/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  String title;
  GlobalKey<ScaffoldState>? scaffoldKey;
  CustomAppBar({super.key, required this.title, this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160.h,
      padding: const EdgeInsets.only(bottom: 6.0),
      decoration: BoxDecoration(
        // color: AppColor.deepBlue,
        gradient: LinearGradient(
          colors: [
            AppColor.deepAppBarBlue,
            AppColor.lightAppBarBlue,
            AppColor.lightAppBarBlue,
            AppColor.deepAppBarBlue,
          ],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        ),
        // borderRadius: const BorderRadius.only(
        //   bottomLeft: Radius.circular(20.0),
        //   bottomRight: Radius.circular(20.0),
        // ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(children: [
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  scaffoldKey == null
                      ? GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: SizedBox(
                            // margin:
                            //     EdgeInsets.symmetric(vertical: 13.h, horizontal: 3.w),
                            height: 35.h,
                            width: 35.w,

                            child: Center(
                              child: Image.asset(
                                  "assets/icons/ios_back_arrow.png"),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            scaffoldKey!.currentState!.openDrawer();
                          },
                          child: SizedBox(
                            // margin:
                            //     EdgeInsets.symmetric(vertical: 13.h, horizontal: 3.w),
                            height: 35.h,
                            width: 35.w,

                            child: Center(
                              child:
                                  Image.asset("assets/icons/drawer_icon.png"),
                            ),
                          ),
                        ),
                  SizedBox(
                    width: 24.w,
                  ),
                  GestureDetector(
                    onTap: () {
                      // scaffoldKey.currentState!.openDrawer();
                    },
                    child: SizedBox(
                      // margin:
                      //     EdgeInsets.symmetric(vertical: 13.h, horizontal: 3.w),
                      height: 35.h,
                      width: 35.w,

                      child: Center(
                        child: Image.asset("assets/icons/notification.png"),
                      ),
                    ),
                  ),
                ],
              ),
              Image.asset(
                "assets/images/sari_white_logo.png",
                height: 35.h,
              ),
            ],
          ),
          SizedBox(
            height: 7.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold),
              ),
            ],
          )
        ]),
      ),
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, 122.h);
}
