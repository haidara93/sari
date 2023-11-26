import 'package:custome_mobile/business_logic/bloc/calculate_result_bloc.dart';
import 'package:custome_mobile/data/models/offer_model.dart';
import 'package:custome_mobile/data/models/package_model.dart';
import 'package:custome_mobile/data/services/calculator_service.dart';
import 'package:custome_mobile/helpers/color_constants.dart';
import 'package:custome_mobile/views/screens/trader/log_screens/broker_attachments_screen.dart';
import 'package:custome_mobile/views/screens/trader/log_screens/broker_costs_screen.dart';
import 'package:custome_mobile/views/screens/trader/log_screens/order_tracking_screen.dart';
import 'package:custome_mobile/views/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class OfferDetailsScreen extends StatelessWidget {
  final Offer offer;
  OfferDetailsScreen({Key? key, required this.offer}) : super(key: key);
  CalculateObject result = CalculateObject();

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
    // DateTime now = DateTime.now();
    // Duration diff = now.difference(offer.createdDate!);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(title: "تكاليف المخلص"),
          backgroundColor: Colors.grey[200],
          body: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 15,
                ),
                Card(
                  clipBehavior: Clip.antiAlias,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  )),
                  margin: EdgeInsets.symmetric(horizontal: 10.w),
                  elevation: 1,
                  color: Colors.white,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 7.5.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 7.h,
                        ),
                        Text(
                          'رقم العملية: SA-${offer.id!}',
                          style: TextStyle(
                            color: AppColor.lightBlue,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Divider(
                          color: Colors.grey[300]!,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Text.rich(
                            TextSpan(
                                text: "نوع العملية: ",
                                style: TextStyle(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: getOfferType(offer.offerType!),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                        Divider(
                          color: Colors.grey[300]!,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Text.rich(
                            TextSpan(
                                text: "الأمانة الجمركية: ",
                                style: TextStyle(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: offer.costumeagency!.name,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                        Divider(
                          color: Colors.grey[300]!,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Text.rich(
                            TextSpan(
                                text: "نوع البضاعة: ",
                                style: TextStyle(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: offer.product!.label!,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                        Divider(
                          color: Colors.grey[300]!,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .4,
                              child: Text.rich(
                                TextSpan(
                                    text: "منشأ البضاعة: ",
                                    style: TextStyle(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: offer.origin!.label!,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ]),
                              ),
                            ),
                            SizedBox(
                              height: 45.h,
                              child: VerticalDivider(
                                color: Colors.grey[300],
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                  text: "الوجهة: ",
                                  style: TextStyle(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: offer.costumestate!.name!,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ]),
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.grey[300]!,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .4,
                              child: Text.rich(
                                TextSpan(
                                    text: "نوع الطرد: ",
                                    style: TextStyle(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: offer.packageType!.toString(),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ]),
                              ),
                            ),
                            SizedBox(
                              height: 45.h,
                              child: VerticalDivider(
                                color: Colors.grey[300],
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                  text: "عدد الطرود: ",
                                  style: TextStyle(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: offer.packagesNum!.toString(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ]),
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.grey[300]!,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .4,
                              child: Text.rich(
                                TextSpan(
                                    text: "الوزن: ",
                                    style: TextStyle(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: offer.weight!.toString(),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ]),
                              ),
                            ),
                            SizedBox(
                              height: 45.h,
                              child: VerticalDivider(
                                color: Colors.grey[300],
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                  text: "القيمة: ",
                                  style: TextStyle(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: offer.price!.toString(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ]),
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.grey[300]!,
                        ),
                        SizedBox(
                          height: 7.h,
                        ),
                        Text.rich(
                          TextSpan(
                              text: "تاريخ وصول البضاعة: ",
                              style: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              children: [
                                TextSpan(
                                  text:
                                      '${offer.expectedArrivalDate!.day}-${offer.expectedArrivalDate!.month}-${offer.expectedArrivalDate!.year}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ]),
                        ),
                        SizedBox(
                          height: 10.h,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Card(
                  clipBehavior: Clip.antiAlias,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  )),
                  margin: EdgeInsets.symmetric(horizontal: 10.w),
                  elevation: 1,
                  color: Colors.white,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 7.5.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "اجمالي التكاليف:",
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          totalCost(offer.costs),
                          style: TextStyle(
                            color: AppColor.lightBlue,
                            fontSize: 15.sp,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BrokerCostDetailsScreen(
                                    offer: offer,
                                  ),
                                ));
                            var product =
                                await CalculatorService.getProductInfo(
                                    offer.product!.id!);

                            result.insurance = offer.taxes!.toInt();
                            result.fee = product.fee!;
                            result.rawMaterial = offer.raw_material!;
                            result.industrial = offer.industrial;
                            result.totalTax = product.totalTaxes!.totalTax!;
                            result.partialTax = product.totalTaxes!.partialTax!;
                            result.origin = offer.origin!.label!;
                            result.spendingFee = product.spendingFee!;
                            result.supportFee = product.supportFee!;
                            result.localFee = product.localFee!;
                            result.protectionFee = product.protectionFee!;
                            result.naturalFee = product.naturalFee!;
                            result.taxFee = product.taxFee!;
                            // ignore: use_build_context_synchronously
                            BlocProvider.of<CalculateResultBloc>(context)
                                .add(CalculateTheResultEvent(result));
                            // ignore: use_build_context_synchronously
                          },
                          child: Padding(
                            padding: EdgeInsets.all(8.h),
                            child: Text(
                              "التفاصيل",
                              style: TextStyle(
                                  color: AppColor.lightBlue,
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Card(
                  clipBehavior: Clip.antiAlias,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  )),
                  margin: EdgeInsets.symmetric(horizontal: 10.w),
                  elevation: 1,
                  color: Colors.white,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 7.5.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "المرفقات:",
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BrokerAttachmentsScreen(
                                      attachments: offer.attachments!,
                                      additionalAttachments:
                                          offer.additional_attachments!,
                                      offerId: offer.id!,
                                      offerState: offer.orderStatus!),
                                ));
                          },
                          child: Padding(
                            padding: EdgeInsets.all(8.h),
                            child: Text(
                              "تفاصيل المرفقات",
                              style: TextStyle(
                                  color: AppColor.lightBlue,
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Card(
                  clipBehavior: Clip.antiAlias,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  )),
                  margin: EdgeInsets.symmetric(horizontal: 10.w),
                  elevation: 1,
                  color: Colors.white,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 7.5.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "تتبع العملية:",
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.h),
                          child: const Text(
                            "تقديم البيان الجمركي",
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      OrderTrackingScreen(offernum: offer.id!),
                                ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.more_vert,
                              color: AppColor.goldenYellow,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String totalCost(List<Costs>? costs) {
    double total = 0.0;
    for (var element in costs!) {
      total += element.amount!;
    }
    return total.toString();
  }
}
