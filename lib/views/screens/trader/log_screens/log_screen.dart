import 'package:custome_mobile/business_logic/bloc/trader_log_bloc.dart';
import 'package:custome_mobile/helpers/color_constants.dart';
import 'package:custome_mobile/views/screens/trader/log_screens/offer_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class LogScreen extends StatefulWidget {
  LogScreen({Key? key}) : super(key: key);

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
        break;
      case "E":
        return "تصدير";
        break;
      default:
        return "تصدير";
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
            SizedBox(
              height: 15,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 7, vertical: 7),
              decoration: BoxDecoration(
                color: AppColor.deepBlue,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(27.0),
                  topRight: Radius.circular(27.0),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                // give the indicator a decoration (color and border radius)
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    25.0,
                  ),
                  color: AppColor.activeGreen,
                ),
                labelColor: AppColor.deepBlue,
                unselectedLabelColor: Colors.white,
                onTap: (value) {
                  switch (value) {
                    case 0:
                      BlocProvider.of<TraderLogBloc>(context)
                          .add(TraderLogLoadEvent("R"));
                      break;
                    case 1:
                      BlocProvider.of<TraderLogBloc>(context)
                          .add(TraderLogLoadEvent("C"));
                      break;
                    default:
                  }
                },
                tabs: const [
                  // first tab [you can add an icon using the icon property]
                  Tab(
                    text: 'العمليات الجارية',
                  ),

                  // second tab [you can add an icon using the icon property]
                  Tab(
                    text: 'العمليات المنتهية',
                  ),
                ],
              ),
            ),
            BlocBuilder<TraderLogBloc, TraderLogState>(
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
                            DateTime now = DateTime.now();
                            Duration diff = now
                                .difference(state.offers[index].createdDate!);
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 7.5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'رقم العملية: ${state.offers[index].id!}',
                                      style: TextStyle(
                                          color: AppColor.lightBlue,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                        'نوع العملية: ${getOfferType(state.offers[index].offerType!)}'),
                                    Text(
                                        'الأمانة الجمركية: ${state.offers[index].costumeagency!.name}'),
                                    Text(
                                        'نوع البضاعة: ${state.offers[index].product!.label!}'),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          diffText(diff),
                                          style: TextStyle(
                                            color: AppColor.lightBlue,
                                            fontSize: 15,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            print("asd");
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      OfferDetailsScreen(
                                                          offer: state
                                                              .offers[index]),
                                                ));
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "التفاصيل",
                                              style: TextStyle(
                                                  color: AppColor.lightBlue,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                } else {
                  return Shimmer.fromColors(
                    baseColor: (Colors.grey[300])!,
                    highlightColor: (Colors.grey[100])!,
                    enabled: true,
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
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
