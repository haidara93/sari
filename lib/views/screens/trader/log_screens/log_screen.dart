import 'package:custome_mobile/business_logic/bloc/trader_log_bloc.dart';
import 'package:custome_mobile/helpers/color_constants.dart';
import 'package:custome_mobile/views/screens/trader/log_screens/offer_details_screen.dart';
import 'package:custome_mobile/views/screens/trader/log_screens/order_tracking_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

class LogScreen extends StatefulWidget {
  const LogScreen({Key? key}) : super(key: key);

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int tabIndex = 0;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  String getOfferType(String offer) {
    switch (offer) {
      case "I":
        return "استيراد";
      case "E":
        return "تصدير";
      default:
        return "تصدير";
    }
  }

  String getOfferStatus(String offer) {
    switch (offer) {
      case "P":
        return "معلقة";
      case "R":
        return "جارية";
      case "C":
        return "مكتملة";
      case "F":
        return "مرفوضة";
      default:
        return "خطأ";
    }
  }

  String diffText(Duration diff) {
    if (diff.inSeconds < 60) {
      return "منذ ${diff.inSeconds.toString()} ثانية";
    } else if (diff.inMinutes < 60) {
      return "منذ ${diff.inMinutes.toString()} دقيقة";
    } else if (diff.inHours < 24) {
      return "منذ ${diff.inHours.toString()} ساعة";
    } else {
      return "منذ ${diff.inDays.toString()} يوم";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 5,
            ),
            Card(
              clipBehavior: Clip.antiAlias,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                Radius.circular(15),
              )),
              margin: EdgeInsets.symmetric(horizontal: 7.w),
              elevation: 1,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
                child: TabBar(
                  controller: _tabController,
                  // give the indicator a decoration (color and border radius)

                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      25.0,
                    ),

                    // color: AppColor.activeGreen,
                  ),

                  labelColor: AppColor.deepBlue,
                  unselectedLabelColor: Colors.black,

                  onTap: (value) {
                    switch (value) {
                      case 0:
                        BlocProvider.of<TraderLogBloc>(context)
                            .add(const TraderLogLoadEvent("R"));
                        break;
                      case 1:
                        BlocProvider.of<TraderLogBloc>(context)
                            .add(const TraderLogLoadEvent("C"));
                        break;
                      default:
                    }
                    setState(() {
                      tabIndex = value;
                    });
                  },
                  tabs: [
                    // first tab [you can add an icon using the icon property]
                    Tab(
                      child: Container(
                        decoration: BoxDecoration(
                            // gradient: tabIndex == 0
                            //     ? LinearGradient(
                            //         colors: [
                            //           AppColor.goldenYellow,
                            //           Colors.white,
                            //           AppColor.goldenYellow,
                            //         ],
                            //         begin: Alignment.topLeft,
                            //         end: Alignment.bottomRight,
                            //       )
                            //     : null,
                            color: tabIndex == 0 ? AppColor.goldenYellow : null,
                            borderRadius: BorderRadius.circular(
                              25.0,
                            ),
                            border: tabIndex != 0
                                ? Border.all(
                                    color: AppColor.goldenYellow,
                                    width: 2,
                                  )
                                : null
                            // color: AppColor.activeGreen,
                            ),
                        child: const Center(child: Text("العمليات الجارية")),
                      ),
                    ),

                    // second tab [you can add an icon using the icon property]
                    Tab(
                      child: Container(
                        decoration: BoxDecoration(
                            // gradient: tabIndex == 1
                            //     ? LinearGradient(
                            //         colors: [
                            //           AppColor.goldenYellow,
                            //           Colors.white,
                            //           AppColor.goldenYellow,
                            //         ],
                            //         begin: Alignment.centerLeft,
                            //         end: Alignment.centerRight,
                            //       )
                            //     : null,
                            color: tabIndex == 1 ? AppColor.goldenYellow : null,
                            borderRadius: BorderRadius.circular(
                              25.0,
                            ),
                            border: tabIndex != 1
                                ? Border.all(
                                    color: AppColor.goldenYellow,
                                    width: 2,
                                  )
                                : null
                            // color: AppColor.activeGreen,
                            ),
                        child: const Center(child: Text('العمليات المنتهية')),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlocBuilder<TraderLogBloc, TraderLogState>(
                builder: (context, state) {
                  if (state is TraderLogLoadedSuccess) {
                    return state.offers.isEmpty
                        ? const Center(
                            child: Text("لا يوجد عروض لعرضها"),
                          )
                        : ListView.builder(
                            itemCount: state.offers.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              // DateTime now = DateTime.now();
                              // Duration diff = now
                              //     .difference(state.offers[index].createdDate!);
                              return Card(
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5.h),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                OfferDetailsScreen(
                                                    offer: state.offers[index]),
                                          ));
                                    },
                                    leading: Container(
                                      height: 75.h,
                                      width: 75.w,
                                      decoration: BoxDecoration(
                                          // color: AppColor.lightGoldenYellow,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Center(
                                        child: SvgPicture.asset(
                                          "assets/icons/naval_shipping.svg",
                                          height: 55.h,
                                          width: 55.w,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'رقم العملية: SA-${state.offers[index].id!}',
                                              style: TextStyle(
                                                  // color: AppColor.lightBlue,
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                                'نوع العملية: ${getOfferType(state.offers[index].offerType!)}'),
                                            Text.rich(
                                              TextSpan(
                                                  text: state.offers[index]
                                                      .origin!.label!,
                                                  style: TextStyle(
                                                    color: AppColor.lightBlue,
                                                  ),
                                                  children: [
                                                    const TextSpan(
                                                      text: "  --->  ",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          "${state.offers[index].costumestate!.name}",
                                                      style: TextStyle(
                                                        color:
                                                            AppColor.lightBlue,
                                                      ),
                                                    ),
                                                  ]),
                                            ),
                                            // Text(
                                            //     'نوع البضاعة: ${state.offers[index].product!.label!}'),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 80.h,
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        OrderTrackingScreen(
                                                            offernum: state
                                                                .offers[index]
                                                                .id!),
                                                  ));
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 6.0,
                                                      horizontal: 3.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "تتبع العملية",
                                                    style: TextStyle(
                                                      color: AppColor.lightBlue,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    dense: false,
                                  ),
                                ),
                              );
                            });
                  } else {
                    return Shimmer.fromColors(
                      baseColor: (Colors.grey[300])!,
                      highlightColor: (Colors.grey[100])!,
                      enabled: true,
                      direction: ShimmerDirection.ttb,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (_, __) => Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 30.h,
                                width: 100.w,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Container(
                                height: 30.h,
                                width: 150.w,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Container(
                                height: 30.h,
                                width: 150.w,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ],
                          ),
                        ),
                        itemCount: 6,
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
