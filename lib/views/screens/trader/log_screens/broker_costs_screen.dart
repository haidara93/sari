import 'package:custome_mobile/business_logic/bloc/calculate_result_bloc.dart';
import 'package:custome_mobile/data/models/offer_model.dart';
import 'package:custome_mobile/data/models/package_model.dart';
import 'package:custome_mobile/data/services/calculator_service.dart';
import 'package:custome_mobile/helpers/color_constants.dart';
import 'package:custome_mobile/views/screens/trader/trader_bill_review.dart';
import 'package:custome_mobile/views/widgets/custom_app_bar.dart';
import 'package:custome_mobile/views/widgets/custom_botton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BrokerCostDetailsScreen extends StatelessWidget {
  final Offer offer;
  BrokerCostDetailsScreen({Key? key, required this.offer}) : super(key: key);
  CalculateObject result = CalculateObject();
  double finaltotalcost = 0.0;
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
        appBar: CustomAppBar(title: "تفاصيل التكليف"),
        backgroundColor: Colors.grey[200],
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20.h,
              ),
              Text(
                "الضرائب والرسوم",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: 20.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: BlocBuilder<CalculateResultBloc, CalculateResultState>(
                  builder: (context, state) {
                    if (state is CalculateResultSuccessed) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            border: const Border(
                              left: BorderSide(
                                color: Colors.blue,
                                width: 1.0,
                              ),
                              right: BorderSide(
                                color: Colors.blue,
                                width: 1.0,
                              ),
                              top: BorderSide(
                                color: Colors.blue,
                                width: 1.0,
                              ),
                              bottom: BorderSide(
                                color: Colors.blue,
                                width: 1.0,
                              ),
                            ),
                            color: Colors.white),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              "ضرائب البنود",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 22),
                            ),
                            Divider(color: Colors.yellow[800]),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "الرسم الجمركي",
                                  maxLines: 3,
                                ),
                                Text(state.result.customsFee!.toString()),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "رسم الانفاق الاستهلاكي",
                                  maxLines: 3,
                                ),
                                Text(state.result.spendingFee!.toString()),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "رسم محلية عمران",
                                  maxLines: 3,
                                ),
                                Text(state.result.imranLocality!.toString()),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "رسم محلية محافظة",
                                  maxLines: 3,
                                ),
                                Text(state.result.conservativeLocality!
                                    .toString()),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "رسم دعم وتنمية الانتاج المحلي",
                                  maxLines: 3,
                                ),
                                Text(state.result.feeSupportingLocalProduction!
                                    .toString()),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "رسم اعادة تأهيل وحماية المدن والمنشأة :",
                                  maxLines: 3,
                                ),
                                Text(state.result.citiesProtectionFee!
                                    .toString()),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "رسم صندوق الجفاف و الكوارث الطبيعية: :",
                                  maxLines: 3,
                                ),
                                Text(state.result.naturalDisasterFee!
                                    .toString()),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "رسم السلفة على ضريبة الدخل:",
                                  maxLines: 3,
                                ),
                                Text(state.result.incomeTaxFee!.toString()),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "مجموع الرسوم:",
                                  maxLines: 3,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  state.result.finalFee!.toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: BlocBuilder<CalculateResultBloc, CalculateResultState>(
                  builder: (context, state) {
                    if (state is CalculateResultSuccessed) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            border: const Border(
                              left: BorderSide(
                                color: Colors.blue,
                                width: 1.0,
                              ),
                              right: BorderSide(
                                color: Colors.blue,
                                width: 1.0,
                              ),
                              top: BorderSide(
                                color: Colors.blue,
                                width: 1.0,
                              ),
                              bottom: BorderSide(
                                color: Colors.blue,
                                width: 1.0,
                              ),
                            ),
                            color: Colors.white),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              "ضرائب الأقلام",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 22),
                            ),
                            Divider(color: Colors.yellow[800]),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "طوابع وضرائب مضافة",
                                  maxLines: 3,
                                ),
                                Text(state.result.addedTaxes!.toString()),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "شهادة جمركية",
                                  maxLines: 3,
                                ),
                                Text(state.result.customsCertificate!
                                    .toString()),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "رسم تأمين إلزامي",
                                  maxLines: 3,
                                ),
                                Text(state.result.billTax!.toString()),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "رسم طابع",
                                  maxLines: 3,
                                ),
                                Text(state.result.stampFee!.toStringAsFixed(2)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "ضريبة محلية محافظة",
                                  maxLines: 3,
                                ),
                                Text(state.result.provincialLocalTax!
                                    .toStringAsFixed(2)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "السلفة على ضريبة الدخل",
                                  maxLines: 3,
                                ),
                                Text(state.result.advanceIncomeTax!
                                    .toStringAsFixed(2)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "رسم المساهمة الوطنية لإعادة الاإعمار:",
                                  maxLines: 3,
                                ),
                                Text(state.result.reconstructionFee!
                                    .toStringAsFixed(2)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "رسم المساهمة الوطنية لإعادة الاإعمار:",
                                  maxLines: 3,
                                ),
                                Text(state.result.reconstructionFee!
                                    .toStringAsFixed(2)),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "مجموع الضرائب:",
                                  maxLines: 3,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  state.result.finalTaxes!.toStringAsFixed(2),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: BlocBuilder<CalculateResultBloc, CalculateResultState>(
                  builder: (context, state) {
                    if (state is CalculateResultSuccessed) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            border: const Border(
                              left: BorderSide(
                                color: Colors.blue,
                                width: 1.0,
                              ),
                              right: BorderSide(
                                color: Colors.blue,
                                width: 1.0,
                              ),
                              top: BorderSide(
                                color: Colors.blue,
                                width: 1.0,
                              ),
                              bottom: BorderSide(
                                color: Colors.blue,
                                width: 1.0,
                              ),
                            ),
                            color: Colors.white),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              "إجمالي الرسوم:",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 22),
                            ),
                            Divider(color: Colors.yellow[800]),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "مجموع الضرائب والرسوم:",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  maxLines: 3,
                                ),
                                Text(
                                  state.result.finalTotal!.toStringAsFixed(2),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: const Text(
                    "هذه الرسوم تقديرية ولا تتضمن مصاريف التخليص الجمركي ورسوم الخدمات"),
              ),
              SizedBox(
                height: 15.h,
              ),
              const Divider(),
              SizedBox(
                height: 15.h,
              ),
              const Text(
                "تكاليف المخلص الجمركي",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: 20.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: BlocBuilder<CalculateResultBloc, CalculateResultState>(
                  builder: (context, state) {
                    if (state is CalculateResultSuccessed) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            border: const Border(
                              left: BorderSide(
                                color: Colors.blue,
                                width: 1.0,
                              ),
                              right: BorderSide(
                                color: Colors.blue,
                                width: 1.0,
                              ),
                              top: BorderSide(
                                color: Colors.blue,
                                width: 1.0,
                              ),
                              bottom: BorderSide(
                                color: Colors.blue,
                                width: 1.0,
                              ),
                            ),
                            color: Colors.white),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              "تفاصيل التكاليف",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 22),
                            ),
                            Divider(color: Colors.yellow[800]),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: offer.costs!.length,
                              itemBuilder: (context, index) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      offer.costs![index].description!,
                                      maxLines: 3,
                                    ),
                                    Text(
                                        offer.costs![index].amount!.toString()),
                                  ],
                                );
                              },
                            ),
                            Divider(color: Colors.yellow[800]),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "اجمالي التكاليف:",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  maxLines: 3,
                                ),
                                Text(
                                  totalCost(offer.costs),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              const Divider(),
              SizedBox(
                height: 20.h,
              ),
              const Text(
                "اجمالي تكاليف العملية",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: 15.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: BlocBuilder<CalculateResultBloc, CalculateResultState>(
                  builder: (context, state) {
                    if (state is CalculateResultSuccessed) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            border: const Border(
                              left: BorderSide(
                                color: Colors.blue,
                                width: 1.0,
                              ),
                              right: BorderSide(
                                color: Colors.blue,
                                width: 1.0,
                              ),
                              top: BorderSide(
                                color: Colors.blue,
                                width: 1.0,
                              ),
                              bottom: BorderSide(
                                color: Colors.blue,
                                width: 1.0,
                              ),
                            ),
                            color: Colors.white),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              "اجمالي التكاليف",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 22),
                            ),
                            Divider(color: Colors.yellow[800]),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "اجمالي الرسوم والتكاليف:",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  maxLines: 3,
                                ),
                                Text(
                                  finaltotalCost(
                                      offer.costs, state.result.finalTotal!),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
              SizedBox(
                height: 50.h,
              ),
            ],
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

  String finaltotalCost(List<Costs>? costs, double finaltotal) {
    double total = 0.0;
    for (var element in costs!) {
      total += element.amount!;
    }
    return (total + finaltotal).toString();
  }
}
