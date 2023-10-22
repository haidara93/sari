import 'package:custome_mobile/constants/user_type.dart';
import 'package:custome_mobile/helpers/color_constants.dart';
import 'package:custome_mobile/views/screens/trader/trader_signin_screen.dart';
import 'package:custome_mobile/views/widgets/custom_botton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class SelectUserType extends StatelessWidget {
  SelectUserType({Key? key}) : super(key: key);

  UserType userType = UserType.trader;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 120.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Image.asset(
                  "assets/images/select_user.png",
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                "الرجاء اختيار مستخدم",
                style: TextStyle(fontSize: 24.sp, color: AppColor.deepBlue),
              ),
              SizedBox(
                height: 10.h,
              ),
              Card(
                elevation: 3,
                clipBehavior: Clip.antiAlias,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                  Radius.circular(40),
                )),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 35),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 62.w),
                        child: CustomButton(
                          title: Text(
                            "تاجر",
                            style: TextStyle(
                              color: AppColor.deepBlue,
                              fontSize: 19.sp,
                            ),
                          ),
                          color: AppColor.deepYellow,
                          onTap: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const TraderSigninScreen(),
                                ));
                            userType = UserType.trader;
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();

                            String usertype = "Trader";
                            switch (userType) {
                              case UserType.trader:
                                usertype = "Trader";
                                break;
                              case UserType.broker:
                                usertype = "Broker";
                                break;
                              default:
                            }
                            prefs.setString("userType", usertype);
                          },
                        ),
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 62.w),
                        child: CustomButton(
                          title: Text(
                            "مخلص جمركي",
                            style: TextStyle(
                              color: AppColor.deepBlue,
                              fontSize: 19.sp,
                            ),
                          ),
                          color: AppColor.deepYellow,
                          onTap: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const TraderSigninScreen(),
                                ));
                            userType = UserType.broker;
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();

                            String usertype = "Broker";
                            switch (userType) {
                              case UserType.trader:
                                usertype = "Trader";
                                break;
                              case UserType.broker:
                                usertype = "Broker";
                                break;
                              default:
                            }
                            prefs.setString("userType", usertype);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer()
            ]),
      ),
    );
  }
}
