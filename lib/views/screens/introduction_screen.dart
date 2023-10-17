import 'package:custome_mobile/helpers/color_constants.dart';
import 'package:custome_mobile/views/control_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroductionView extends StatefulWidget {
  IntroductionView({Key? key}) : super(key: key);

  @override
  State<IntroductionView> createState() => _IntroductionViewState();
}

class _IntroductionViewState extends State<IntroductionView> {
  PageController controller = PageController();
  bool isLastPage = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget builfPage(
          {required Color color,
          required String urlImage,
          required Widget title,
          required Widget subtitle}) =>
      Container(
        color: color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 120.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Image.asset(
                urlImage,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            title,
            subtitle,
            // Text(
            //   subtitle,
            //   style: TextStyle(color: AppColor.deepYellow, fontSize: 24),
            // ),
            const SizedBox(
              height: 20,
            ),
            const Spacer(),
            Image.asset("assets/images/sari_intro.png"),
            SizedBox(
              height: 10.h,
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(bottom: 80),
          child: PageView(
            controller: controller,
            onPageChanged: (value) {
              setState(() {
                isLastPage = value == 3;
              });
            },
            children: [
              builfPage(
                color: Colors.white,
                urlImage: "assets/images/intro1.png",
                title: Text(
                  "أهلا وسهلا بك",
                  style: TextStyle(color: AppColor.deepBlue, fontSize: 24.sp),
                ),
                subtitle: Text.rich(
                  TextSpan(
                      text: "في التطبيق الأول",
                      style:
                          TextStyle(fontSize: 24.sp, color: AppColor.deepBlue),
                      children: [
                        TextSpan(
                            text: " للتخليص الجمركي",
                            style: TextStyle(color: AppColor.deepYellow))
                      ]),
                ),
              ),
              builfPage(
                  color: Colors.white,
                  urlImage: "assets/images/intro2.png",
                  title: Text.rich(
                    TextSpan(
                        text: "اطلع على",
                        style: TextStyle(
                            fontSize: 24.sp, color: AppColor.deepBlue),
                        children: [
                          TextSpan(
                              text: " إجراءات التخليص واللوائح",
                              style: TextStyle(
                                  fontSize: 24.sp, color: AppColor.deepYellow))
                        ]),
                  ),
                  subtitle: Text(
                    "الجمركية المطبقة على نوع بضاعتك",
                    style: TextStyle(color: AppColor.deepBlue, fontSize: 24.sp),
                  )),
              builfPage(
                  color: Colors.white,
                  urlImage: "assets/images/intro3.png",
                  title: Text(
                    "احسب الرسوم الجمركية المفروضة على",
                    style: TextStyle(color: AppColor.deepBlue, fontSize: 24.sp),
                  ),
                  subtitle: Text.rich(
                    TextSpan(
                        text: "بضائعك قبل البدء",
                        style: TextStyle(
                            fontSize: 24.sp, color: AppColor.deepBlue),
                        children: [
                          TextSpan(
                              text: " بعملية الاستيراد",
                              style: TextStyle(
                                  fontSize: 24.sp, color: AppColor.deepYellow))
                        ]),
                  )),
              builfPage(
                  color: Colors.white,
                  urlImage: "assets/images/intro4.png",
                  title: Text(
                    "المخلص الجمركي المختص",
                    style: TextStyle(color: AppColor.deepBlue, fontSize: 24.sp),
                  ),
                  subtitle: Text(
                    "",
                    style: TextStyle(color: AppColor.deepBlue, fontSize: 24.sp),
                  )),
            ],
          ),
        ),
      ),
      bottomSheet: isLastPage
          ? TextButton(
              style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  foregroundColor: Colors.white,
                  minimumSize: Size.fromHeight(80.h)),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.setBool("showHome", true);
                // ignore: use_build_context_synchronously
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ControlView(),
                    ));
              },
              child: Text(
                'ابدأ الأن',
                style: TextStyle(fontSize: 24.sp, color: AppColor.deepYellow),
              ))
          : Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              height: 80.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        controller.jumpToPage(3);
                      },
                      child: Text(
                        'تخطى',
                        style: TextStyle(color: AppColor.deepYellow),
                      )),
                  Center(
                    child: SmoothPageIndicator(
                      controller: controller,
                      count: 4,
                      effect: WormEffect(
                          spacing: 14.w,
                          dotColor: AppColor.lightYellow,
                          activeDotColor: AppColor.deepYellow),
                      onDotClicked: (index) => controller.animateToPage(index,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        controller.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut);
                      },
                      child: Text(
                        'التالي',
                        style: TextStyle(color: AppColor.deepYellow),
                      )),
                ],
              ),
            ),
    );
  }
}
