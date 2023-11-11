import 'package:custome_mobile/business_logic/bloc/calculate_result_bloc.dart';
import 'package:custome_mobile/data/models/offer_model.dart';
import 'package:custome_mobile/data/models/package_model.dart';
import 'package:custome_mobile/views/widgets/calculator_loading_screen.dart';
import 'package:custome_mobile/views/widgets/custom_app_bar.dart';
import 'package:custome_mobile/views/widgets/item_taxes_widget.dart';
import 'package:custome_mobile/views/widgets/pens_taxes_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class BrokerCostDetailsScreen extends StatelessWidget {
  final Offer offer;
  BrokerCostDetailsScreen({Key? key, required this.offer}) : super(key: key);
  CalculateObject result = CalculateObject();
  double finaltotalcost = 0.0;
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
          appBar: CustomAppBar(title: "تفاصيل المخلص"),
          backgroundColor: Colors.grey[200],
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  "الضرائب والرسوم",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
                ),
                SizedBox(
                  height: 20.h,
                ),
                BlocBuilder<CalculateResultBloc, CalculateResultState>(
                  builder: (context, state) {
                    if (state is CalculateResultSuccessed) {
                      return ItemTaxesWidget(
                        customsFee: state.result.customsFee!,
                        spendingFee: state.result.spendingFee!,
                        conservativeLocality:
                            state.result.conservativeLocality!,
                        citiesProtectionFee: state.result.citiesProtectionFee!,
                        feeSupportingLocalProduction:
                            state.result.feeSupportingLocalProduction!,
                        imranLocality: state.result.imranLocality!,
                        incomeTaxFee: state.result.incomeTaxFee!,
                        naturalDisasterFee: state.result.naturalDisasterFee!,
                        finalFee: state.result.finalTotal!,
                      );
                    } else {
                      return const CalculatorLoadingScreen();
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                BlocBuilder<CalculateResultBloc, CalculateResultState>(
                  builder: (context, state) {
                    if (state is CalculateResultSuccessed) {
                      return PensTaxesWidget(
                        addedTaxes: state.result.addedTaxes!,
                        customsCertificate: state.result.customsCertificate!,
                        billTax: state.result.billTax!,
                        stampFee: state.result.stampFee!,
                        provincialLocalTax: state.result.provincialLocalTax!,
                        advanceIncomeTax: state.result.advanceIncomeTax!,
                        reconstructionFee: state.result.reconstructionFee!,
                        finalTaxes: state.result.finalTaxes!,
                      );
                    } else {
                      return const CalculatorLoadingScreen();
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                BlocBuilder<CalculateResultBloc, CalculateResultState>(
                  builder: (context, state) {
                    if (state is CalculateResultSuccessed) {
                      return Card(
                        clipBehavior: Clip.antiAlias,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        )),
                        margin: EdgeInsets.symmetric(horizontal: 10.w),
                        elevation: 1,
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                "إجمالي الرسوم:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 22),
                              ),
                              const SizedBox(
                                height: 7,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "مجموع الضرائب والرسوم:",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                        ),
                      );
                    } else {
                      return const CalculatorLoadingScreen();
                    }
                  },
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
                BlocBuilder<CalculateResultBloc, CalculateResultState>(
                  builder: (context, state) {
                    if (state is CalculateResultSuccessed) {
                      return Card(
                        clipBehavior: Clip.antiAlias,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        )),
                        margin: EdgeInsets.symmetric(horizontal: 10.w),
                        elevation: 1,
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                "تفاصيل التكاليف",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 22),
                              ),
                              const SizedBox(
                                height: 7,
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: offer.costs!.length,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        offer.costs![index].description!,
                                        maxLines: 3,
                                      ),
                                      Text(offer.costs![index].amount!
                                          .toString()),
                                    ],
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 7,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "اجمالي التكاليف:",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                        ),
                      );
                    } else {
                      return const CalculatorLoadingScreen();
                    }
                  },
                ),
                SizedBox(
                  height: 10.h,
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
                BlocBuilder<CalculateResultBloc, CalculateResultState>(
                  builder: (context, state) {
                    if (state is CalculateResultSuccessed) {
                      return Card(
                        clipBehavior: Clip.antiAlias,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        )),
                        margin: EdgeInsets.symmetric(horizontal: 10.w),
                        elevation: 1,
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "اجمالي التكاليف",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22.sp),
                              ),
                              SizedBox(
                                height: 7.h,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "اجمالي الرسوم والتكاليف:",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                              SizedBox(
                                height: 15.h,
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return const CalculatorLoadingScreen();
                    }
                  },
                ),
                SizedBox(
                  height: 50.h,
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

  String finaltotalCost(List<Costs>? costs, double finaltotal) {
    double total = 0.0;
    for (var element in costs!) {
      total += element.amount!;
    }
    return (total + finaltotal).toString();
  }
}
