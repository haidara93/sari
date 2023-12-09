import 'package:custome_mobile/business_logic/bloc/calculate_result_bloc.dart';
import 'package:custome_mobile/helpers/color_constants.dart';
import 'package:custome_mobile/views/widgets/calculator_loading_screen.dart';
import 'package:custome_mobile/views/widgets/custom_app_bar.dart';
import 'package:custome_mobile/views/widgets/custom_botton.dart';
import 'package:custome_mobile/views/widgets/item_taxes_widget.dart';
import 'package:custome_mobile/views/widgets/pens_taxes_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class TraderCalculatorResultScreen extends StatelessWidget {
  TraderCalculatorResultScreen({Key? key}) : super(key: key);
  var f = NumberFormat("#,###", "en_US");

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: CustomAppBar(
          title: "الضرائب والرسوم",
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: BlocBuilder<CalculateResultBloc, CalculateResultState>(
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
                        finalFee: state.result.finalFee!,
                        addedTaxes: state.result.addedTaxes!,
                        customsCertificate: state.result.customsCertificate!,
                        billTax: state.result.billTax!,
                        stampFee: state.result.stampFee!,
                        provincialLocalTax: state.result.provincialLocalTax!,
                        advanceIncomeTax: state.result.advanceIncomeTax!,
                        reconstructionFee: state.result.reconstructionFee!,
                        finalTaxes: state.result.finalTaxes!,
                        finalTotal: state.result.finalTotal!,
                      );
                    } else {
                      return const CalculatorLoadingScreen();
                    }
                  },
                ),
              ),
              // const SizedBox(
              //   height: 20,
              // ),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 10.w),
              //   child: BlocBuilder<CalculateResultBloc, CalculateResultState>(
              //     builder: (context, state) {
              //       if (state is CalculateResultSuccessed) {
              //         return PensTaxesWidget(
              //           addedTaxes: state.result.addedTaxes!,
              //           customsCertificate: state.result.customsCertificate!,
              //           billTax: state.result.billTax!,
              //           stampFee: state.result.stampFee!,
              //           provincialLocalTax: state.result.provincialLocalTax!,
              //           advanceIncomeTax: state.result.advanceIncomeTax!,
              //           reconstructionFee: state.result.reconstructionFee!,
              //           finalTaxes: state.result.finalTaxes!,
              //         );
              //       } else {
              //         return const CalculatorLoadingScreen();
              //       }
              //     },
              //   ),
              // ),
              // const SizedBox(
              //   height: 20,
              // ),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 10.w),
              //   child: BlocBuilder<CalculateResultBloc, CalculateResultState>(
              //     builder: (context, state) {
              //       if (state is CalculateResultSuccessed) {
              //         return Container(
              //           padding: EdgeInsets.symmetric(horizontal: 15.w),
              //           margin: EdgeInsets.symmetric(horizontal: 10.w),
              //           decoration: BoxDecoration(
              //             border: Border(
              //               top: BorderSide(
              //                 color: AppColor.deepYellow,
              //                 width: 1,
              //               ),
              //               right: BorderSide(
              //                 color: AppColor.deepYellow,
              //                 width: 2,
              //               ),
              //               left: BorderSide(
              //                 color: AppColor.deepYellow,
              //                 width: 2,
              //               ),
              //               bottom: BorderSide(
              //                 color: AppColor.deepYellow,
              //                 width: 2,
              //               ),
              //             ),
              //             borderRadius: const BorderRadius.vertical(
              //                 top: Radius.zero, bottom: Radius.circular(12)),
              //             color: Colors.white,
              //           ),
              //           child: Column(
              //             mainAxisAlignment: MainAxisAlignment.start,
              //             children: [
              //               const Text(
              //                 "إجمالي الرسوم:",
              //                 style: TextStyle(
              //                     fontWeight: FontWeight.bold, fontSize: 22),
              //               ),
              //               const SizedBox(
              //                 height: 7,
              //               ),
              //               Divider(color: AppColor.deepYellow),
              //               Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                 children: [
              //                   const Text(
              //                     "مجموع الضرائب والرسوم:",
              //                     maxLines: 3,
              //                   ),
              //                   Text(
              //                     f.format(state.result.finalTotal!.toInt()),
              //                     style: const TextStyle(
              //                         fontWeight: FontWeight.bold),
              //                   ),
              //                 ],
              //               ),
              //               const SizedBox(
              //                 height: 15,
              //               ),
              //             ],
              //           ),
              //         );
              //       } else {
              //         return const CalculatorLoadingScreen();
              //       }
              //     },
              //   ),
              // ),
              SizedBox(
                height: 30.h,
              ),
              const Text(
                  "هذه الرسوم تقديرية ولا تتضمن مصاريف التخليص الجمركي ورسوم الخدمات"),
              SizedBox(
                height: 15.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomButton(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    title: const SizedBox(
                        width: 100, child: Center(child: Text("رجوع"))),
                  ),
                  // CustomButton(
                  //   onTap: () {
                  //     // Navigator.push(
                  //     //     context,
                  //     //     MaterialPageRoute(
                  //     //       builder: (context) => TraderBillReview(),
                  //     //     ));
                  //   },
                  //   title: const SizedBox(
                  //       width: 100, child: Center(child: Text("حفظ"))),
                  // ),
                  // CustomButton(
                  //   onTap: () {
                  //     // Navigator.push(
                  //     //     context,
                  //     //     MaterialPageRoute(
                  //     //       builder: (context) => TraderAttachementScreen(),
                  //     //     ));
                  //   },
                  //   title: const SizedBox(
                  //       width: 100, child: Center(child: Text("طلب مخلص"))),
                  // ),
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
