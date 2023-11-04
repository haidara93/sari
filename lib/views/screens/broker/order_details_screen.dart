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

class OrderDetailsScreen extends StatefulWidget {
  final Offer offer;
  OrderDetailsScreen({super.key, required this.offer});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  int offerAccept = 0;

  String getOfferType(String offer) {
    switch (offer) {
      case "I":
        return "استيراد";
      case "E":
        return "تصدير";
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
    // DateTime now = DateTime.now();
    // Duration diff = now.difference(offer.createdDate!);
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
                      'رقم العملية: ${widget.offer.id!}',
                      style: TextStyle(
                          color: AppColor.lightBlue,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                        'نوع العملية: ${getOfferType(widget.offer.offerType!)}'),
                    Text(
                        'الأمانة الجمركية: ${widget.offer.costumeagency!.name}'),
                    Text('نوع البضاعة: ${widget.offer.product!.label!}'),
                    Text(
                      'منشأ البضاعة: ${widget.offer.origin!.label!}',
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'نوع الطرد: ${widget.offer.packageType!}',
                        ),
                        Text(
                          'عدد الطرود: ${widget.offer.packagesNum!}',
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'الوزن: ${widget.offer.weight!}',
                        ),
                        Text(
                          'القيمة: ${widget.offer.price!}',
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
                BlocConsumer<OfferBloc, OfferState>(listener: (context, state) {
                  if (state is OfferListLoadedSuccess && offerAccept == 2) {
                    setState(() {
                      offerAccept = 0;
                    });
                    Navigator.pop(context);
                  }
                }, builder: (context, state) {
                  if (state is OfferListLoadingProgress && offerAccept == 2) {
                    return CustomButton(
                      onTap: () {},
                      title: SizedBox(
                          width: 200.w,
                          child:
                              const Center(child: CircularProgressIndicator())),
                    );
                  } else {
                    return CustomButton(
                      onTap: () {
                        // setState(() {
                        //   offerAccept = 2;
                        // });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              // builder: (context) => OrderCostScreen(offer: offer),
                              builder: (context) =>
                                  OrderAttachmentScreen(offer: widget.offer),
                            ));
                        // BlocProvider.of<OfferBloc>(context)
                        //     .add(OfferStatusUpdateEvent(widget.offer.id!, "F"));
                      },
                      title: SizedBox(
                          width: 200.w,
                          child: const Center(child: Text("عرض المرفقات"))),
                    );
                  }
                }),
                BlocConsumer<OfferBloc, OfferState>(listener: (context, state) {
                  if (state is OfferListLoadedSuccess && offerAccept == 1) {
                    setState(() {
                      offerAccept = 0;
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          // builder: (context) => OrderCostScreen(offer: offer),
                          builder: (context) =>
                              OrderCostScreen(offer: widget.offer),
                        ));
                  }
                }, builder: (context, state) {
                  if (state is OfferListLoadingProgress && offerAccept == 1) {
                    return CustomButton(
                      onTap: () {},
                      title: SizedBox(
                          width: 200.w,
                          child:
                              const Center(child: CircularProgressIndicator())),
                    );
                  } else {
                    return CustomButton(
                      onTap: () {
                        setState(() {
                          offerAccept = 1;
                        });
                        BlocProvider.of<OfferBloc>(context)
                            .add(OfferStatusUpdateEvent(widget.offer.id!, "R"));
                      },
                      title: SizedBox(
                          width: 200.w,
                          child: const Center(
                              child: Text("موافقة وادخال التكاليف"))),
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
