import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PensTaxesWidget extends StatelessWidget {
  final double addedTaxes;
  final double customsCertificate;
  final double billTax;
  final double stampFee;
  final double provincialLocalTax;
  final double advanceIncomeTax;
  final double reconstructionFee;
  final double finalTaxes;

  const PensTaxesWidget(
      {Key? key,
      required this.addedTaxes,
      required this.customsCertificate,
      required this.billTax,
      required this.stampFee,
      required this.provincialLocalTax,
      required this.advanceIncomeTax,
      required this.reconstructionFee,
      required this.finalTaxes})
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
            "ضرائب الأقلام",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          const SizedBox(
            height: 7,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "طوابع وضرائب مضافة",
                maxLines: 3,
              ),
              Text(addedTaxes!.toString()),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "شهادة جمركية",
                maxLines: 3,
              ),
              Text(customsCertificate!.toString()),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "رسم تأمين إلزامي",
                maxLines: 3,
              ),
              Text(billTax!.toString()),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "رسم طابع",
                maxLines: 3,
              ),
              Text(stampFee!.toStringAsFixed(2)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "ضريبة محلية محافظة",
                maxLines: 3,
              ),
              Text(provincialLocalTax!.toStringAsFixed(2)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "السلفة على ضريبة الدخل",
                maxLines: 3,
              ),
              Text(advanceIncomeTax!.toStringAsFixed(2)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "رسم المساهمة الوطنية لإعادة الاإعمار:",
                maxLines: 3,
              ),
              Text(reconstructionFee!.toStringAsFixed(2)),
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
                finalTaxes!.toStringAsFixed(2),
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
