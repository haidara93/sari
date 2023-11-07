import 'package:custome_mobile/views/widgets/custom_app_bar.dart';
import 'package:custome_mobile/views/widgets/custome_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timeline_tile/timeline_tile.dart';

// ignore: must_be_immutable
class OrderTrackingScreen extends StatelessWidget {
  final int offernum;
  OrderTrackingScreen({Key? key, required this.offernum}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: CustomAppBar(title: "تعقب المعاملة"),
        backgroundColor: Colors.grey[200],
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(12.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 15,
                ),
                Text('رقم العملية: SA-$offernum'),
                const SizedBox(
                  height: 15,
                ),
                const CustomeTimeLine(
                  isFirst: true,
                  isLast: false,
                  isPast: true,
                  imageUrl: "assets/images/step1.png",
                  title: "استلام المستندات",
                ),
                const CustomeTimeLine(
                  isFirst: false,
                  isLast: false,
                  isPast: true,
                  imageUrl: "assets/images/step2.png",
                  title: "ميناء التفريغ",
                ),
                const CustomeTimeLine(
                  isFirst: false,
                  isLast: false,
                  isPast: true,
                  imageUrl: "assets/images/step3.png",
                  title: "استلام اذن التسليم",
                ),
                const CustomeTimeLine(
                  isFirst: false,
                  isLast: false,
                  isPast: true,
                  isCurrent: true,
                  imageUrl: "assets/images/step4.png",
                  title: "تقديم البيان الجمركي",
                ),
                const CustomeTimeLine(
                  isFirst: false,
                  isLast: false,
                  isPast: false,
                  imageUrl: "assets/images/step5.png",
                  title: "كشف البضاعة",
                ),
                const CustomeTimeLine(
                  isFirst: false,
                  isLast: false,
                  isPast: false,
                  imageUrl: "assets/images/step6.png",
                  title: "دفع الرشوم والضرائب",
                ),
                const CustomeTimeLine(
                  isFirst: false,
                  isLast: false,
                  isPast: false,
                  imageUrl: "assets/images/step7.png",
                  title: "اصدار اذن الخروج",
                ),
                const CustomeTimeLine(
                  isFirst: false,
                  isLast: true,
                  isPast: false,
                  imageUrl: "assets/images/step8.png",
                  title: "تجميل على الشاحنة",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
