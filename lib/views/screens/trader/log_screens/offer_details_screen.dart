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
class OfferDetailsScreen extends StatefulWidget {
  final Offer offer;
  OfferDetailsScreen({Key? key, required this.offer}) : super(key: key);

  @override
  State<OfferDetailsScreen> createState() => _OfferDetailsScreenState();
}

class _OfferDetailsScreenState extends State<OfferDetailsScreen> {
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

  Package? product;

  void getProductInfo() async {
    product = await CalculatorService.getProductInfo(widget.offer.product!.id!);
  }

  @override
  void initState() {
    super.initState();
    getProductInfo();
  }

  @override
  Widget build(BuildContext context) {
    // DateTime now = DateTime.now();
    // Duration diff = now.difference(offer.createdDate!);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(title: "تفاصيل العملية"),
          backgroundColor: Colors.grey[200],
          body: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                                  builder: (context) => OrderTrackingScreen(
                                      offernum: widget.offer.id!),
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
                          'رقم العملية: SA-${widget.offer.id!}',
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
                                    text: getOfferType(widget.offer.offerType!),
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
                                    text: widget.offer.costumeagency!.name,
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
                                    text: widget.offer.product!.label!,
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
                                        text: widget.offer.origin!.label!,
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
                                      text: widget.offer.costumestate!.name!,
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
                                        text: widget.offer.packageType!
                                            .toString(),
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
                                      text:
                                          widget.offer.packagesNum!.toString(),
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
                                        text: widget.offer.weight!.toString(),
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
                                      text: widget.offer.price!.toString(),
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
                                      '${widget.offer.expectedArrivalDate!.day}-${widget.offer.expectedArrivalDate!.month}-${widget.offer.expectedArrivalDate!.year}',
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
                          totalCost(widget.offer.costs),
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
                                    offer: widget.offer,
                                  ),
                                ));

                            result.insurance = widget.offer.taxes!.toInt();
                            result.fee = product!.fee!;
                            result.rawMaterial = widget.offer.raw_material!;
                            result.industrial = widget.offer.industrial;
                            result.totalTax = product!.totalTaxes!.totalTax!;
                            result.partialTax =
                                product!.totalTaxes!.partialTax!;
                            result.origin = widget.offer.origin!.label!;
                            result.spendingFee = product!.spendingFee!;
                            result.supportFee = product!.supportFee!;
                            result.localFee = product!.localFee!;
                            result.protectionFee = product!.protectionFee!;
                            result.naturalFee = product!.naturalFee!;
                            result.taxFee = product!.taxFee!;
                            result.insurance = widget.offer.taxes!.toInt();
                            result.fee = product!.fee!;
                            result.rawMaterial = widget.offer.raw_material!;
                            result.industrial = widget.offer.industrial;
                            result.totalTax = product!.totalTaxes!.totalTax!;
                            result.partialTax =
                                product!.totalTaxes!.partialTax!;
                            result.origin = widget.offer.origin!.label!;
                            result.spendingFee = product!.spendingFee!;
                            result.supportFee = product!.supportFee!;
                            result.localFee = product!.localFee!;
                            result.protectionFee = product!.protectionFee!;
                            result.naturalFee = product!.naturalFee!;
                            result.taxFee = product!.taxFee!;
                            result.weight = widget.offer.weight!.toInt();
                            result.price = widget.offer.price!.toInt();
                            result.cnsulate = 1;
                            result.dolar = 8585;
                            result.arabic_stamp =
                                product!.totalTaxes!.arabicStamp!.toInt();
                            result.import_fee = product!.importFee;
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
                                      attachments: widget.offer.attachments!,
                                      additionalAttachments:
                                          widget.offer.additional_attachments!,
                                      offerId: widget.offer.id!,
                                      offerState: widget.offer.orderStatus!),
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
