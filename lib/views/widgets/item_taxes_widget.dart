import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  const ItemTaxesWidget(
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: const LinearGradient(colors: [
          Color.fromARGB(255, 229, 215, 94),
          Colors.white,
          Colors.white,
          Colors.white,
          Colors.white,
          Colors.white,
          Colors.white,
          Colors.white,
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            "ضرائب البنود",
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
              Text(customsFee!.toString()),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "رسم الانفاق الاستهلاكي",
                maxLines: 3,
              ),
              Text(spendingFee!.toString()),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "رسم محلية عمران",
                maxLines: 3,
              ),
              Text(imranLocality!.toString()),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "رسم محلية محافظة",
                maxLines: 3,
              ),
              Text(conservativeLocality!.toString()),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "رسم دعم وتنمية الانتاج المحلي",
                maxLines: 3,
              ),
              Text(feeSupportingLocalProduction!.toString()),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "رسم اعادة تأهيل وحماية المدن والمنشأة :",
                maxLines: 3,
              ),
              Text(citiesProtectionFee!.toString()),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "رسم صندوق الجفاف و الكوارث الطبيعية: :",
                maxLines: 3,
              ),
              Text(naturalDisasterFee!.toString()),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "رسم السلفة على ضريبة الدخل:",
                maxLines: 3,
              ),
              Text(incomeTaxFee!.toString()),
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
                finalFee!.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
