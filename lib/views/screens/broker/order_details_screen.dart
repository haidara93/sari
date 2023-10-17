import 'package:custome_mobile/business_logic/bloc/offer_bloc.dart';
import 'package:custome_mobile/data/models/offer_model.dart';
import 'package:custome_mobile/helpers/color_constants.dart';
import 'package:custome_mobile/views/screens/broker/order_attachments_screen.dart';
import 'package:custome_mobile/views/screens/broker/order_cost_screen.dart';
import 'package:custome_mobile/views/widgets/custom_app_bar.dart';
import 'package:custome_mobile/views/widgets/custom_botton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderDetailsScreen extends StatelessWidget {
  final Offer offer;
  const OrderDetailsScreen({required this.offer});

  String getOfferType(String offer) {
    switch (offer) {
      case "I":
        return "استيراد";
        break;
      case "E":
        return "تصدير";
        break;
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
    DateTime now = DateTime.now();
    Duration diff = now.difference(offer.createdDate!);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: CustomAppBar(title: "طلبات تخليص"),
        backgroundColor: Colors.grey[200],
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Card(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 7.5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'رقم العملية: ${offer.id!}',
                      style: TextStyle(
                          color: AppColor.lightBlue,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ),
                    Text('نوع العملية: ${getOfferType(offer.offerType!)}'),
                    Text('الأمانة الجمركية: ${offer.costumeagency!.name}'),
                    Text('نوع البضاعة: ${offer.product!.label!}'),
                    Text(
                      'منشأ البضاعة: ${offer.origin!.label!}',
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'نوع الطرد: ${offer.packageType!}',
                        ),
                        Text(
                          'عدد الطرود: ${offer.packagesNum!}',
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'الوزن: ${offer.weight!}',
                        ),
                        Text(
                          'القيمة: ${offer.price!}',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomButton(
                  onTap: () {},
                  color: AppColor.deepYellow,
                  title: const SizedBox(
                      width: 100, child: Center(child: Text("رفض"))),
                ),
                BlocConsumer<OfferBloc, OfferState>(listener: (context, state) {
                  if (state is OfferListLoadedSuccess) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          // builder: (context) => OrderCostScreen(offer: offer),
                          builder: (context) =>
                              OrderAttachmentScreen(offer: offer),
                        ));
                  }
                }, builder: (context, state) {
                  if (state is OfferListLoadedSuccess) {
                    return CustomButton(
                      onTap: () {
                        BlocProvider.of<OfferBloc>(context)
                            .add(OfferStatusUpdateEvent(offer.id!, "R"));
                      },
                      color: AppColor.deepYellow,
                      title: SizedBox(
                          width: 250.w,
                          child: const Center(
                              child: Text("موافقة وادخال التكاليف"))),
                    );
                  } else {
                    return CustomButton(
                      onTap: () {},
                      color: AppColor.deepYellow,
                      title: SizedBox(
                          width: 250.w,
                          child:
                              const Center(child: CircularProgressIndicator())),
                    );
                  }
                }),
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
