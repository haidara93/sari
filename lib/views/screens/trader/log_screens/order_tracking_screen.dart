import 'package:custome_mobile/views/widgets/custom_app_bar.dart';
import 'package:custome_mobile/views/widgets/custome_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class OrderTrackingScreen extends StatelessWidget {
  final int offernum;
  OrderTrackingScreen({Key? key, required this.offernum}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
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
                    imageUrl: "assets/images/step 1 Dark.svg",
                    type: "svg",
                    title: "استلام المستندات",
                  ),
                  const CustomeTimeLine(
                    isFirst: false,
                    isLast: false,
                    isPast: true,
                    imageUrl: "assets/images/step 2 Dark.svg",
                    type: "svg",
                    title: "ميناء التفريغ",
                  ),
                  const CustomeTimeLine(
                    isFirst: false,
                    isLast: false,
                    isPast: true,
                    imageUrl: "assets/images/step 3 Dark.svg",
                    type: "svg",
                    title: "استلام اذن التسليم",
                  ),
                  const CustomeTimeLine(
                    isFirst: false,
                    isLast: false,
                    isPast: true,
                    isCurrent: true,
                    imageUrl: "assets/images/step 4 Dark.svg",
                    type: "svg",
                    title: "تقديم البيان الجمركي",
                  ),
                  const CustomeTimeLine(
                    isFirst: false,
                    isLast: false,
                    isPast: false,
                    imageUrl: "assets/images/step 5 blue.svg",
                    type: "svg",
                    title: "كشف البضاعة",
                  ),
                  const CustomeTimeLine(
                    isFirst: false,
                    isLast: false,
                    isPast: false,
                    imageUrl: "assets/images/step 6 blue.svg",
                    type: "svg",
                    title: "دفع الرشوم والضرائب",
                  ),
                  const CustomeTimeLine(
                    isFirst: false,
                    isLast: false,
                    isPast: false,
                    imageUrl: "assets/images/step 7 blue.svg",
                    type: "svg",
                    title: "اصدار اذن الخروج",
                  ),
                  const CustomeTimeLine(
                    isFirst: false,
                    isLast: true,
                    isPast: false,
                    imageUrl: "assets/images/step 8 blue.svg",
                    type: "svg",
                    title: "تجميل على الشاحنة",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
