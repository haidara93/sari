import 'package:custome_mobile/helpers/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ignore: must_be_immutable
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  String title;
  GlobalKey<ScaffoldState>? scaffoldKey;
  Function()? onTap;
  CustomAppBar({super.key, required this.title, this.scaffoldKey, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160.h,
      padding: EdgeInsets.only(bottom: 6.h),
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
          // const Spacer(),
          SizedBox(
            height: 20.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  scaffoldKey == null
                      ? GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
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
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            scaffoldKey!.currentState!.openDrawer();
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 13.h, horizontal: 10.w),
                            child: SizedBox(
                              height: 35.h,
                              width: 35.w,
                              child: Center(
                                child:
                                    Image.asset("assets/icons/drawer_icon.png"),
                              ),
                            ),
                          ),
                        ),
                  SizedBox(
                    width: 2.w,
                  ),
                  InkWell(
                    // borderRadius: BorderRadius.circular(45),
                    onTap: () {
                      print("asdasd");
                      // scaffoldKey.currentState!.openDrawer();
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 13.h, horizontal: 10.w),
                      child: SizedBox(
                        height: 35.h,
                        width: 35.h,
                        child: Center(
                          child: Image.asset("assets/icons/notification.png"),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 95.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onTap ?? () {},
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    "assets/images/sari_blue.svg",
                    height: 40.h,
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, 122.h);
}
