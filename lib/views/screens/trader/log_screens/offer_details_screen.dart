import 'package:custome_mobile/business_logic/bloc/calculate_result_bloc.dart';
import 'package:custome_mobile/data/models/offer_model.dart';
import 'package:custome_mobile/data/models/package_model.dart';
import 'package:custome_mobile/data/services/calculator_service.dart';
import 'package:custome_mobile/helpers/color_constants.dart';
import 'package:custome_mobile/views/screens/trader/log_screens/broker_attachments)screen.dart';
import 'package:custome_mobile/views/screens/trader/log_screens/broker_costs_screen.dart';
import 'package:custome_mobile/views/screens/trader/trader_bill_review.dart';
import 'package:custome_mobile/views/widgets/custom_app_bar.dart';
import 'package:custome_mobile/views/widgets/custom_botton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OfferDetailsScreen extends StatelessWidget {
  final Offer offer;
  OfferDetailsScreen({Key? key, required this.offer}) : super(key: key);
  CalculateObject result = CalculateObject();

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
    DateTime now = DateTime.now();
    Duration diff = now.difference(offer.createdDate!);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: CustomAppBar(title: "تكاليف المخلص"),
        backgroundColor: Colors.grey[200],
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Card(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 7.5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'رقم العملية: ${offer.id!}',
                      style: TextStyle(
                          color: AppColor.lightBlue,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ),
                    Text('نوع العملية: ${getOfferType(offer.offerType!)}'),
                    Text('الأمانة الجمركية: ${offer.costumeagency!.name}'),
                    Text('نوع البضاعة: ${offer.product!.label!}'),
                    Text(
                      'منشأ البضاعة: ${offer.origin!.label!}',
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'نوع الطرد: ${offer.packageType!}',
                        ),
                        Text(
                          'عدد الطرود: ${offer.packagesNum!}',
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'الوزن: ${offer.weight!}',
                        ),
                        Text(
                          'القيمة: ${offer.price!}',
                        ),
                      ],
                    ),
                    Text(
                      'تاريخ وصول البضاعة: ${offer.expectedArrivalDate!.day}-${offer.expectedArrivalDate!.month}-${offer.expectedArrivalDate!.year}',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Card(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 7.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("اجمالي التكاليف:"),
                    Text(
                      totalCost(offer.costs),
                      style: TextStyle(
                        color: AppColor.lightBlue,
                        fontSize: 15,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        var product = await CalculatorService.getProductInfo(
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
                        BlocProvider.of<CalculateResultBloc>(context)
                            .add(CalculateTheResultEvent(result));
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BrokerCostDetailsScreen(
                                offer: offer,
                              ),
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
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Card(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 7.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("المرفقات:"),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BrokerAttachmentsScreen(
                                  attachments: offer.attachments!,
                                  additionalAttachments:
                                      offer.additional_attachments!),
                            ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "تفاصيل المرفقات",
                          style: TextStyle(
                              color: AppColor.lightBlue,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [
            //     CustomButton(
            //       onTap: () {},
            //       color: AppColor.deepYellow,
            //       title: const SizedBox(
            //           width: 100, child: Center(child: Text("رفض"))),
            //     ),
            //     BlocConsumer<OfferBloc, OfferState>(listener: (context, state) {
            //       if (state is OfferListLoadedSuccess) {
            //         Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //               // builder: (context) => OrderCostScreen(offer: offer),
            //               builder: (context) =>
            //                   OrderAttachmentScreen(offer: offer),
            //             ));
            //       }
            //     }, builder: (context, state) {
            //       if (state is OfferListLoadedSuccess) {
            //         return CustomButton(
            //           onTap: () {
            //             BlocProvider.of<OfferBloc>(context)
            //                 .add(OfferStatusUpdateEvent(offer.id!, "R"));
            //           },
            //           color: AppColor.deepYellow,
            //           title: SizedBox(
            //               width: 250.w,
            //               child: const Center(
            //                   child: Text("موافقة وادخال التكاليف"))),
            //         );
            //       } else {
            //         return CustomButton(
            //           onTap: () {},
            //           color: AppColor.deepYellow,
            //           title: SizedBox(
            //               width: 250.w,
            //               child:
            //                   const Center(child: CircularProgressIndicator())),
            //         );
            //       }
            //     }),
            //   ],
            // ),
            SizedBox(
              height: 30.h,
            ),
          ],
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
