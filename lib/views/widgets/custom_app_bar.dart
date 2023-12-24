import 'package:custome_mobile/business_logic/bloc/notification_bloc.dart';
import 'package:custome_mobile/data/providers/notification_provider.dart';
import 'package:custome_mobile/helpers/color_constants.dart';
import 'package:custome_mobile/views/screens/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  String title;
  GlobalKey<ScaffoldState>? scaffoldKey;
  Function()? onTap;
  CustomAppBar({super.key, required this.title, this.scaffoldKey, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 122.h,
      padding: EdgeInsets.only(bottom: 6.h),
      decoration: BoxDecoration(
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
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(children: [
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
                            padding: EdgeInsets.symmetric(
                                vertical: 13.h, horizontal: 10.w),
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
                  Consumer<NotificationProvider>(
                      builder: (context, notificationProvider, child) {
                    return BlocListener<NotificationBloc, NotificationState>(
                      listener: (context, state) {
                        if (state is NotificationLoadedSuccess) {
                          notificationProvider
                              .initNotifications(state.notifications);
                        }
                      },
                      child: InkWell(
                        // borderRadius: BorderRadius.circular(45),
                        onTap: () {
                          notificationProvider.clearNotReadedNotification();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NotificationScreen(),
                              ));
                          // scaffoldKey.currentState!.openDrawer();
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 13.h, horizontal: 10.w),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              SizedBox(
                                height: 35.h,
                                width: 35.h,
                                child: Center(
                                  child: Image.asset(
                                      "assets/icons/notification.png"),
                                ),
                              ),
                              notificationProvider.notreadednotifications != 0
                                  ? Positioned(
                                      right: -7.w,
                                      top: -10.h,
                                      child: Container(
                                        height: 20.h,
                                        width: 20.h,
                                        decoration: BoxDecoration(
                                          color: AppColor.goldenYellow,
                                          borderRadius:
                                              BorderRadius.circular(45),
                                        ),
                                        child: Center(
                                          child: Text(
                                            notificationProvider
                                                .notreadednotifications
                                                .toString(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink()
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
              SizedBox(
                height: 95.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      title,
                      // overflow: TextOver,
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
