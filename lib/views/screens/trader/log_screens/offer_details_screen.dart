import 'package:custome_mobile/Localization/app_localizations.dart';
import 'package:custome_mobile/business_logic/bloc/calculate_result/calculate_multi_result_dart_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/calculate_result/calculate_result_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/offer_details_bloc.dart';
import 'package:custome_mobile/business_logic/cubit/locale_cubit.dart';
import 'package:custome_mobile/data/models/offer_model.dart';
import 'package:custome_mobile/data/models/package_model.dart';
import 'package:custome_mobile/data/providers/broker_offer_provider.dart';
import 'package:custome_mobile/data/providers/trader_offer_provider.dart';
import 'package:custome_mobile/data/services/calculator_service.dart';
import 'package:custome_mobile/helpers/color_constants.dart';
import 'package:custome_mobile/views/screens/trader/log_screens/broker_attachments_screen.dart';
import 'package:custome_mobile/views/screens/trader/log_screens/broker_costs_screen.dart';
import 'package:custome_mobile/views/screens/trader/log_screens/order_tracking_screen.dart';
import 'package:custome_mobile/views/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class OfferDetailsScreen extends StatefulWidget {
  // final Offer offer;
  final String type;
  OfferDetailsScreen({Key? key, required this.type}) : super(key: key);

  @override
  State<OfferDetailsScreen> createState() => _OfferDetailsScreenState();
}

class _OfferDetailsScreenState extends State<OfferDetailsScreen> {
  CalculateObject result = CalculateObject();
  List<CalculateObject> objects = [];

  TraderOfferProvider? trader_offerProvider;
  BrokerOfferProvider? broker_offerProvider;

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

  String getEnOfferType(String offer) {
    switch (offer) {
      case "I":
        return "Import";
      case "E":
        return "Export";
      default:
        return "Export";
    }
  }

  String getOfferStatus(String offer) {
    switch (offer) {
      case "P":
        return "معلقة";
      case "R":
        return "جارية";
      case "C":
        return "مكتملة";
      case "F":
        return "مرفوضة";
      default:
        return "خطأ";
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

  String diffEnText(Duration diff) {
    if (diff.inSeconds < 60) {
      return "since ${diff.inSeconds.toString()} seconds";
    } else if (diff.inMinutes < 60) {
      return "since ${diff.inMinutes.toString()} minutes";
    } else if (diff.inHours < 24) {
      return "since ${diff.inHours.toString()} hours";
    } else {
      return "since ${diff.inDays.toString()} days";
    }
  }

  Package? product;

  void getProductInfo(String id) async {
    product = await CalculatorService.getProductInfo(id);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      trader_offerProvider =
          Provider.of<TraderOfferProvider>(context, listen: false);
      broker_offerProvider =
          Provider.of<BrokerOfferProvider>(context, listen: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    // DateTime now = DateTime.now();
    // Duration diff = now.difference(offer.createdDate!);
    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, localeState) {
        return Directionality(
          textDirection: localeState.value.languageCode == 'en'
              ? TextDirection.ltr
              : TextDirection.rtl,
          child: SafeArea(
            child: Scaffold(
              appBar: CustomAppBar(
                  title: AppLocalizations.of(context)!
                      .translate('operation_details')),
              backgroundColor: Colors.grey[200],
              body: BlocConsumer<OfferDetailsBloc, OfferDetailsState>(
                listener: (context, offersstate) {
                  if (offersstate is OfferDetailsLoadedSuccess) {
                    trader_offerProvider!
                        .initAttachment(offersstate.offer.attachments!);
                    trader_offerProvider!.initAdditionalAttachment(
                        offersstate.offer.additional_attachments!);
                    broker_offerProvider!.initOffer(offersstate.offer);
                  }
                },
                builder: (context, offerstate) {
                  if (offerstate is OfferDetailsLoadedSuccess) {
                    getProductInfo(offerstate.offer.products![0].id!);

                    return SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 15.h,
                          ),
                          Card(
                            clipBehavior: Clip.antiAlias,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            )),
                            margin: EdgeInsets.symmetric(horizontal: 10.w),
                            elevation: 1,
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15.w, vertical: 7.5.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${AppLocalizations.of(context)!.translate('status')}:",
                                    style: TextStyle(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    offerstate.offer.track_offer!.message!,
                                    style: TextStyle(
                                      fontSize: 17.sp,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                OrderTrackingScreen(
                                                    type: widget.type,
                                                    offer: offerstate.offer),
                                          ));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .translate('operation_tracking'),
                                        style: TextStyle(
                                          color: AppColor.lightBlue,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Card(
                            clipBehavior: Clip.antiAlias,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            )),
                            margin: EdgeInsets.symmetric(horizontal: 10.w),
                            elevation: 1,
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15.w, vertical: 7.5.h),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 7.h,
                                  ),
                                  Text(
                                    '${AppLocalizations.of(context)!.translate('operation_number')}: SA-${broker_offerProvider!.id!}',
                                    style: TextStyle(
                                      color: AppColor.lightBlue,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.grey[300]!,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5.0),
                                    child: Text.rich(
                                      TextSpan(
                                          text:
                                              "${AppLocalizations.of(context)!.translate('operation_type')}: ",
                                          style: TextStyle(
                                            fontSize: 17.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: localeState
                                                          .value.languageCode ==
                                                      'en'
                                                  ? getEnOfferType(
                                                      broker_offerProvider!
                                                          .offerType!)
                                                  : getOfferType(
                                                      broker_offerProvider!
                                                          .offerType!),
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ]),
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.grey[300]!,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5.0),
                                    child: Text.rich(
                                      TextSpan(
                                          text:
                                              "${AppLocalizations.of(context)!.translate('costume_agency')}: ",
                                          style: TextStyle(
                                            fontSize: 17.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: offerstate
                                                  .offer.costumeagency!.name,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ]),
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.grey[300]!,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5.0),
                                    child: Text.rich(
                                      TextSpan(
                                          text:
                                              "${AppLocalizations.of(context)!.translate('goods_name')}: ",
                                          style: TextStyle(
                                            fontSize: 17.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: broker_offerProvider!
                                                  .products![0].label!,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ]),
                                    ),
                                  ),
                                  Divider(
                                    color: const Color.fromARGB(
                                        255, 164, 144, 144)!,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .4,
                                        child: Text.rich(
                                          TextSpan(
                                              text:
                                                  "${AppLocalizations.of(context)!.translate('goods_origin')}: ",
                                              style: TextStyle(
                                                fontSize: 17.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: offerstate
                                                      .offer.source!.label!,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16.sp,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                              ]),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 45.h,
                                        child: VerticalDivider(
                                          color: Colors.grey[300],
                                        ),
                                      ),
                                      Text.rich(
                                        TextSpan(
                                            text:
                                                "${AppLocalizations.of(context)!.translate('destination')}: ",
                                            style: TextStyle(
                                              fontSize: 17.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: offerstate
                                                    .offer.costumestate!.name!,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ]),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    color: Colors.grey[300]!,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .4,
                                        child: Text.rich(
                                          TextSpan(
                                              text:
                                                  "${AppLocalizations.of(context)!.translate('package_type')}: ",
                                              style: TextStyle(
                                                fontSize: 17.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: offerstate
                                                      .offer.packageType!
                                                      .toString(),
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16.sp,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                              ]),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 45.h,
                                        child: VerticalDivider(
                                          color: Colors.grey[300],
                                        ),
                                      ),
                                      Text.rich(
                                        TextSpan(
                                            text:
                                                "${AppLocalizations.of(context)!.translate('packages_number')}: ",
                                            style: TextStyle(
                                              fontSize: 17.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: broker_offerProvider!
                                                    .packagesNum!
                                                    .toString(),
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ]),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    color: Colors.grey[300]!,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .4,
                                        child: Text.rich(
                                          TextSpan(
                                              text:
                                                  "${AppLocalizations.of(context)!.translate('weight')}: ",
                                              style: TextStyle(
                                                fontSize: 17.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: broker_offerProvider!
                                                      .weight![0]
                                                      .toString(),
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16.sp,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                              ]),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 45.h,
                                        child: VerticalDivider(
                                          color: Colors.grey[300],
                                        ),
                                      ),
                                      Text.rich(
                                        TextSpan(
                                            text:
                                                "${AppLocalizations.of(context)!.translate('value')}: ",
                                            style: TextStyle(
                                              fontSize: 17.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: broker_offerProvider!
                                                    .price![0]
                                                    .toString(),
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ]),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    color: Colors.grey[300]!,
                                  ),
                                  SizedBox(
                                    height: 7.h,
                                  ),
                                  Text.rich(
                                    TextSpan(
                                        text:
                                            "${AppLocalizations.of(context)!.translate('expected_arrival_date')}: ",
                                        style: TextStyle(
                                          fontSize: 17.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        children: [
                                          TextSpan(
                                            text:
                                                '${broker_offerProvider!.expectedArrivalDate!.day}-${broker_offerProvider!.expectedArrivalDate!.month}-${broker_offerProvider!.expectedArrivalDate!.year}',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ]),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          Card(
                            clipBehavior: Clip.antiAlias,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            )),
                            margin: EdgeInsets.symmetric(horizontal: 10.w),
                            elevation: 1,
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15.w, vertical: 7.5.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${AppLocalizations.of(context)!.translate('total_costs')}:",
                                    style: TextStyle(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    totalCost(broker_offerProvider!.costs),
                                    style: TextStyle(
                                      color: AppColor.lightBlue,
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                BrokerCostDetailsScreen(
                                              costs:
                                                  broker_offerProvider!.costs,
                                            ),
                                          ));
                                      for (var i = 0;
                                          i <
                                              broker_offerProvider!
                                                  .products!.length;
                                          i++) {
                                        objects.add(CalculateObject());
                                        objects[i].insurance =
                                            broker_offerProvider!.taxes![i];
                                        objects[i].fee = broker_offerProvider!
                                            .products![i].fee;
                                        objects[i].rawMaterial =
                                            broker_offerProvider!
                                                    .raw_material![i]
                                                ? 1
                                                : 0;
                                        objects[i].industrial =
                                            broker_offerProvider!.industrial![i]
                                                ? 1
                                                : 0;
                                        objects[i].totalTax =
                                            broker_offerProvider!.products![i]!
                                                .totalTaxes!.totalTax!
                                                .toDouble();
                                        objects[i].partialTax =
                                            broker_offerProvider!.products![i]!
                                                .totalTaxes!.partialTax!
                                                .toDouble();
                                        objects[i].origin =
                                            broker_offerProvider!
                                                .origin![i].label;
                                        objects[i].spendingFee =
                                            broker_offerProvider!
                                                .products![i]!.spendingFee;
                                        objects[i].supportFee =
                                            broker_offerProvider!
                                                .products![i]!.supportFee;
                                        objects[i].localFee =
                                            broker_offerProvider!
                                                .products![i]!.localFee!
                                                .toDouble();
                                        objects[i].protectionFee =
                                            broker_offerProvider!
                                                .products![i]!.protectionFee;
                                        objects[i].naturalFee =
                                            broker_offerProvider!
                                                .products![i]!.naturalFee;
                                        objects[i].taxFee =
                                            broker_offerProvider!
                                                .products![i]!.taxFee;
                                        objects[i].weight =
                                            broker_offerProvider!.weight![i];
                                        objects[i].price =
                                            broker_offerProvider!.price![i];
                                        objects[i].cnsulate = 1;
                                        objects[i].dolar = 8585;
                                        objects[i].arabic_stamp =
                                            broker_offerProvider!.products![i]!
                                                .totalTaxes!.arabicStamp!
                                                .toInt();
                                        objects[i].import_fee =
                                            broker_offerProvider!
                                                .products![i]!.importFee!;
                                      }
                                      BlocProvider.of<CalculateMultiResultBloc>(
                                              context)
                                          .add(CalculateMultiTheResultEvent(
                                              objects));

                                      // ignore: use_build_context_synchronously
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(8.h),
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .translate('details'),
                                        style: TextStyle(
                                            color: AppColor.lightBlue,
                                            fontSize: 17.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          Card(
                            clipBehavior: Clip.antiAlias,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            )),
                            margin: EdgeInsets.symmetric(horizontal: 10.w),
                            elevation: 1,
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15.w, vertical: 7.5.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${AppLocalizations.of(context)!.translate('attachments')}:",
                                    style: TextStyle(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                BrokerAttachmentsScreen(
                                                    offerId:
                                                        broker_offerProvider!
                                                            .id!,
                                                    offerState:
                                                        broker_offerProvider!
                                                            .orderStatus!),
                                          ));
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(8.h),
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .translate('attachments_details'),
                                        style: TextStyle(
                                            color: AppColor.lightBlue,
                                            fontSize: 17.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                        ],
                      ),
                    );
                  } else if (offerstate is OfferDetailsLoadingProgress) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * .6,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  } else {
                    return Text("");
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }

  String totalCost(List<Costs>? costs) {
    double total = 0.0;
    for (var element in costs!) {
      total += element.amount!;
    }
    return total.toInt().toString();
  }
}
