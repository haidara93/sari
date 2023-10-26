import 'package:custome_mobile/business_logic/bloc/calculate_result_bloc.dart';
import 'package:custome_mobile/business_logic/cubit/current_step_cubit.dart';
import 'package:custome_mobile/helpers/color_constants.dart';
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
  // final int customAgency;
  // final int customeState;
  // final String? offerType;
  // final int? packagesNum;
  // final int? tabalehNum;
  // final int? weight;
  // final int? price;
  // final int? taxes;
  // final String? product;
  // final int? origin;
  // final int? packageType;
  // final int? rawMaterial;
  // final int? industrial;
  const TraderBillReview({
    Key? key,
    // required this.customAgency,
    // required this.customeState,
    // this.offerType,
    // this.packagesNum,
    // this.tabalehNum,
    // this.weight,
    // this.price,
    // this.taxes,
    // this.product,
    // this.origin,
    // this.packageType,
    // this.rawMaterial,
    // this.industrial
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 40.h,
            ),
            const Text(
              "الضرائب والرسوم",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 1.w),
              child: BlocBuilder<CalculateResultBloc, CalculateResultState>(
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
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 1.w),
              child: BlocBuilder<CalculateResultBloc, CalculateResultState>(
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
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 1.w),
              child: BlocBuilder<CalculateResultBloc, CalculateResultState>(
                builder: (context, state) {
                  if (state is CalculateResultSuccessed) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        // border: Border(
                        //   left: BorderSide(
                        //     color: AppColor.activeGreen,
                        //     width: 1.0,
                        //   ),
                        //   right: BorderSide(
                        //     color: AppColor.activeGreen,
                        //     width: 1.0,
                        //   ),
                        //   top: BorderSide(
                        //     color: AppColor.activeGreen,
                        //     width: 1.0,
                        //   ),
                        //   bottom: BorderSide(
                        //     color: AppColor.activeGreen,
                        //     width: 1.0,
                        //   ),
                        // ),
                        gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 229, 215, 94),
                              Colors.white,
                              Colors.white,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter),
                      ),
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
                    );
                  } else {
                    return const CalculatorLoadingScreen();
                  }
                },
              ),
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
                    BlocProvider.of<CurrentStepCubit>(context).decreament();
                  },
                  color: AppColor.deepYellow,
                  title: const SizedBox(
                      width: 100, child: Center(child: Text("إلغاء"))),
                ),
                CustomButton(
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => TraderAttachementScreen(),
                    //     ));
                  },
                  color: AppColor.deepYellow,
                  title: const SizedBox(
                      width: 100, child: Center(child: Text("حفظ"))),
                ),
                CustomButton(
                  onTap: () {
                    BlocProvider.of<CurrentStepCubit>(context).increament();

                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => TraderAttachementScreen(
                    //         offerType: offerType,
                    //         customAgency: customAgency,
                    //         customeState: customeState,
                    //         origin: origin,
                    //         packageType: packageType,
                    //         packagesNum: packagesNum,
                    //         tabalehNum: tabalehNum,
                    //         price: price,
                    //         taxes: taxes,
                    //         product: product,
                    //         weight: weight,
                    //         rawMaterial: rawMaterial,
                    //         industrial: industrial,
                    //       ),
                    //     ));
                  },
                  color: AppColor.deepYellow,
                  title: const SizedBox(
                      width: 100, child: Center(child: Text("طلب مخلص"))),
                ),
              ],
            ),
            SizedBox(
              height: 30.h,
            ),
          ],
        ),
      ),
    );
  }
}
