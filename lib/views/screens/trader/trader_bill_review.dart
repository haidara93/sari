import 'package:custome_mobile/business_logic/bloc/calculate_result_bloc.dart';
import 'package:custome_mobile/views/screens/trader/trader_attachement_screen.dart';
import 'package:custome_mobile/views/widgets/calculator_loading_screen.dart';
import 'package:custome_mobile/views/widgets/custom_app_bar.dart';
import 'package:custome_mobile/views/widgets/custom_botton.dart';
import 'package:custome_mobile/views/widgets/item_taxes_widget.dart';
import 'package:custome_mobile/views/widgets/pens_taxes_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TraderBillReview extends StatelessWidget {
  final int customAgency;
  final int customeState;
  final String? offerType;
  final int? packagesNum;
  final int? tabalehNum;
  final int? weight;
  final int? price;
  final int? taxes;
  final String? product;
  final int? origin;
  final int? packageType;
  final int? rawMaterial;
  final int? industrial;
  const TraderBillReview(
      {Key? key,
      required this.customAgency,
      required this.customeState,
      this.offerType,
      this.packagesNum,
      this.tabalehNum,
      this.weight,
      this.price,
      this.taxes,
      this.product,
      this.origin,
      this.packageType,
      this.rawMaterial,
      this.industrial})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: CustomAppBar(title: "طلب مخلص"),
        backgroundColor: Colors.grey[200],
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 86.h,
                child: Stepper(
                  type: StepperType.horizontal,
                  steps: [
                    Step(
                        isActive: true,
                        title: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "معلومات الشحنة",
                            style: TextStyle(fontSize: 12.sp),
                          ),
                        ),
                        content: const SizedBox.shrink()),
                    Step(
                        isActive: true,
                        title: Text(
                          "حساب الرسوم",
                          style: TextStyle(fontSize: 12.sp),
                        ),
                        content: const SizedBox.shrink()),
                    Step(
                        isActive: false,
                        title: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TraderAttachementScreen(
                                    offerType: offerType,
                                    customAgency: customAgency,
                                    customeState: customeState,
                                    origin: origin,
                                    packageType: packageType,
                                    packagesNum: packagesNum,
                                    tabalehNum: tabalehNum,
                                    price: price,
                                    taxes: taxes,
                                    product: product,
                                    weight: weight,
                                    rawMaterial: rawMaterial,
                                    industrial: industrial,
                                  ),
                                ));
                          },
                          child: Text(
                            "المرفقات",
                            style: TextStyle(fontSize: 12.sp),
                          ),
                        ),
                        content: const SizedBox.shrink()),
                  ],
                  currentStep: 1,
                  controlsBuilder: (context, details) {
                    return const SizedBox.shrink();
                  },
                  onStepContinue: () => () {},
                  onStepCancel: () => () {},
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              const Text(
                "الضرائب والرسوم",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
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
                      conservativeLocality: state.result.conservativeLocality!,
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
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "مجموع الضرائب والرسوم:",
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
                height: 23.h,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                    "هذه الرسوم تقديرية ولا تتضمن مصاريف التخليص الجمركي ورسوم الخدمات"),
              ),
              SizedBox(
                height: 23.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomButton(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    title: const SizedBox(
                        width: 150, child: Center(child: Text("إلغاء"))),
                  ),
                  // CustomButton(
                  //   onTap: () {},
                  //
                  //   title: const SizedBox(
                  //       width: 100, child: Center(child: Text("حفظ"))),
                  // ),
                  CustomButton(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TraderAttachementScreen(
                              offerType: offerType,
                              customAgency: customAgency,
                              customeState: customeState,
                              origin: origin,
                              packageType: packageType,
                              packagesNum: packagesNum,
                              tabalehNum: tabalehNum,
                              price: price,
                              taxes: taxes,
                              product: product,
                              weight: weight,
                              rawMaterial: rawMaterial,
                              industrial: industrial,
                            ),
                          ));
                    },
                    title: const SizedBox(
                        width: 150, child: Center(child: Text("طلب مخلص"))),
                  ),
                ],
              ),
              SizedBox(
                height: 30.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
