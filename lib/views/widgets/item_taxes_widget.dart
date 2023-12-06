import 'package:custome_mobile/helpers/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ItemTaxesWidget extends StatelessWidget {
  final double? customsFee;
  final double? spendingFee;
  final double? imranLocality;
  final double? conservativeLocality;
  final double? feeSupportingLocalProduction;
  final double? citiesProtectionFee;
  final double? naturalDisasterFee;
  final double? incomeTaxFee;
  final double? finalFee;

  ItemTaxesWidget(
      {Key? key,
      this.customsFee,
      this.spendingFee,
      this.imranLocality,
      this.conservativeLocality,
      this.feeSupportingLocalProduction,
      this.citiesProtectionFee,
      this.naturalDisasterFee,
      this.incomeTaxFee,
      this.finalFee})
      : super(key: key);
  var f = NumberFormat("#,###", "en_US");
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColor.deepYellow,
            width: 2,
          ),
          right: BorderSide(
            color: AppColor.deepYellow,
            width: 2,
          ),
          left: BorderSide(
            color: AppColor.deepYellow,
            width: 2,
          ),
          bottom: BorderSide(
            color: AppColor.deepYellow,
            width: 1,
          ),
        ),
        borderRadius: const BorderRadius.vertical(
            bottom: Radius.zero, top: Radius.circular(12)),
        color: Colors.white,
      ),
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              "ضرائب الرسوم",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            const SizedBox(
              height: 7,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "الرسم الجمركي",
                  maxLines: 3,
                ),
                Text(f.format(customsFee!.toInt())),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "الانفاق الاستهلاكي",
                  maxLines: 3,
                ),
                Text(f.format(spendingFee!.toInt())),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "محلية عمران",
                  maxLines: 3,
                ),
                Text(f.format(imranLocality!.toInt())),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "محلية محافظة",
                  maxLines: 3,
                ),
                Text(f.format(conservativeLocality!.toInt())),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "دعم وتنمية الانتاج المحلي",
                  maxLines: 3,
                ),
                Text(f.format(feeSupportingLocalProduction!.toInt())),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "اعادة تأهيل وحماية المدن والمنشأة :",
                  maxLines: 3,
                ),
                Text(f.format(citiesProtectionFee!.toInt())),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "صندوق الجفاف و الكوارث الطبيعية: ",
                  maxLines: 3,
                ),
                Text(f.format(naturalDisasterFee!.toInt())),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "السلفة على ضريبة الدخل:",
                  maxLines: 3,
                ),
                Text(f.format(incomeTaxFee!.toInt())),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Divider(color: AppColor.deepYellow),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "مجموع الرسوم:",
                  maxLines: 3,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  f.format(finalFee!.toInt()),
                  style: const TextStyle(fontWeight: FontWeight.bold),
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
  }
}
