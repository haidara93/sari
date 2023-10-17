import 'package:custome_mobile/business_logic/bloc/calculate_result_bloc.dart';
import 'package:custome_mobile/helpers/color_constants.dart';
import 'package:custome_mobile/views/screens/trader/trader_attachement_screen.dart';
import 'package:custome_mobile/views/widgets/custom_app_bar.dart';
import 'package:custome_mobile/views/widgets/custom_botton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TraderBillReview extends StatelessWidget {
  final int customAgency;
  final int customeState;
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
  TraderBillReview(
      {Key? key,
      required this.customAgency,
      required this.customeState,
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
        backgroundColor: Colors.grey[200],
        appBar: CustomAppBar(
          title: "طلب مخلص",
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 40.h,
              ),
              Text(
                "الضرائب والرسوم",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                                  maxLines: 3,
                                ),
                                Text(
                                  state.result.finalTotal!.toStringAsFixed(2),
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
              SizedBox(
                height: 30.h,
              ),
              const Text(
                  "هذه الرسوم تقديرية ولا تتضمن مصاريف التخليص الجمركي ورسوم الخدمات"),
              SizedBox(
                height: 30.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomButton(
                    onTap: () {},
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TraderAttachementScreen(
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
      ),
    );
  }
}
