import 'package:custome_mobile/Localization/app_localizations.dart';
import 'package:custome_mobile/business_logic/bloc/assign_broker_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/broker_list_bloc.dart';
import 'package:custome_mobile/business_logic/cubit/locale_cubit.dart';
import 'package:custome_mobile/data/models/state_custome_agency_model.dart';
import 'package:custome_mobile/helpers/color_constants.dart';
import 'package:custome_mobile/views/control_view.dart';
import 'package:custome_mobile/views/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class SelectBrokerScreen extends StatefulWidget {
  final int offerId;
  SelectBrokerScreen({Key? key, required this.offerId}) : super(key: key);

  @override
  State<SelectBrokerScreen> createState() => _SelectBrokerScreenState();
}

class _SelectBrokerScreenState extends State<SelectBrokerScreen> {
  _buildAgenciesWidget(List<CustomeAgency> agencies) {
    List<Widget> list = [];
    for (var element in agencies) {
      list.add(Text(element.name! + " ,"));
    }

    return list;
  }

  Future<void> _showAlertDialog(int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // <-- SEE HERE
          title: const Text('Assign Broker'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure want to assign this broker?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                BlocProvider.of<AssignBrokerBloc>(context)
                    .add(AssignBrokerToOfferEvent(widget.offerId, index));
                // remove(index);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, localeState) {
        return Directionality(
          textDirection: localeState.value.languageCode == 'en'
              ? TextDirection.ltr
              : TextDirection.rtl,
          child: SafeArea(
            child: Scaffold(
              appBar: CustomAppBar(
                title: AppLocalizations.of(context)!.translate('select_broker'),
              ),
              backgroundColor: Colors.grey[200],
              body: SingleChildScrollView(
                child: BlocListener<AssignBrokerBloc, AssignBrokerState>(
                  listener: (context, state) {
                    print(state);
                    if (state is AssignBrokerSuccess) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ControlView(),
                        ),
                        (route) => false,
                      );
                    }
                    if (state is AssignBrokerFailed) {
                      print(state.error);
                    }
                  },
                  child: Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: BlocBuilder<BrokerListBloc, BrokerListState>(
                              builder: (context, state) {
                                if (state is BrokerListSucess) {
                                  return state.brokers.isEmpty
                                      ? Center(
                                          child: Text(
                                              AppLocalizations.of(context)!
                                                  .translate('no_broker')),
                                        )
                                      : ListView.builder(
                                          itemCount: state.brokers.length,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            // DateTime now = DateTime.now();
                                            // Duration diff = now
                                            //     .difference(state.offers[index].createdDate!);
                                            return GestureDetector(
                                              onTap: () {
                                                _showAlertDialog(
                                                    state.brokers[index].id!);
                                              },
                                              child: Card(
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 5.h),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            height: 100.h,
                                                            width: 100.w,
                                                            decoration:
                                                                BoxDecoration(
                                                              // color: AppColor.lightGoldenYellow,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                            ),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                CircleAvatar(
                                                                  radius: 25.h,
                                                                  backgroundColor:
                                                                      AppColor
                                                                          .deepBlue,
                                                                  child: Center(
                                                                    child: (state.brokers[index].user!.image!.length >
                                                                            1)
                                                                        ? Image
                                                                            .network(
                                                                            state.brokers[index].user!.image!,
                                                                            height:
                                                                                55.h,
                                                                            width:
                                                                                55.w,
                                                                            fit:
                                                                                BoxFit.fill,
                                                                          )
                                                                        : Text(
                                                                            state.brokers[index].user!.image!,
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 28.sp,
                                                                            ),
                                                                          ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Text(
                                                                  "${state.brokers[index].user!.firstName!} ${state.brokers[index].user!.lastName!}",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          13.sp),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                  "${AppLocalizations.of(context)!.translate('directorate')}: ${state.brokers[index].agencies![0].statecustome!.name!}"),
                                                              Wrap(
                                                                children: _buildAgenciesWidget(state
                                                                    .brokers[
                                                                        index]
                                                                    .agencies!),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    35.w),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            state.brokers[index]
                                                                        .rating! >=
                                                                    1
                                                                ? Icon(
                                                                    Icons.star,
                                                                    color: AppColor
                                                                        .deepYellow,
                                                                  )
                                                                : Icon(
                                                                    Icons
                                                                        .star_border,
                                                                    color: AppColor
                                                                        .deepYellow,
                                                                  ),
                                                            state.brokers[index]
                                                                        .rating! >=
                                                                    2
                                                                ? Icon(
                                                                    Icons.star,
                                                                    color: AppColor
                                                                        .deepYellow,
                                                                  )
                                                                : Icon(
                                                                    Icons
                                                                        .star_border,
                                                                    color: AppColor
                                                                        .deepYellow,
                                                                  ),
                                                            state.brokers[index]
                                                                        .rating! >=
                                                                    3
                                                                ? Icon(
                                                                    Icons.star,
                                                                    color: AppColor
                                                                        .deepYellow,
                                                                  )
                                                                : Icon(
                                                                    Icons
                                                                        .star_border,
                                                                    color: AppColor
                                                                        .deepYellow,
                                                                  ),
                                                            state.brokers[index]
                                                                        .rating! >=
                                                                    4
                                                                ? Icon(
                                                                    Icons.star,
                                                                    color: AppColor
                                                                        .deepYellow,
                                                                  )
                                                                : Icon(
                                                                    Icons
                                                                        .star_border,
                                                                    color: AppColor
                                                                        .deepYellow,
                                                                  ),
                                                            state.brokers[index]
                                                                        .rating! ==
                                                                    5
                                                                ? Icon(
                                                                    Icons.star,
                                                                    color: AppColor
                                                                        .deepYellow,
                                                                  )
                                                                : Icon(
                                                                    Icons
                                                                        .star_border,
                                                                    color: AppColor
                                                                        .deepYellow,
                                                                  ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                } else {
                                  return Shimmer.fromColors(
                                    baseColor: (Colors.grey[300])!,
                                    highlightColor: (Colors.grey[100])!,
                                    enabled: true,
                                    direction: ShimmerDirection.ttb,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemBuilder: (_, __) => Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 30.h,
                                              width: 100.w,
                                              clipBehavior: Clip.antiAlias,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Container(
                                              height: 30.h,
                                              width: 150.w,
                                              clipBehavior: Clip.antiAlias,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Container(
                                              height: 30.h,
                                              width: 150.w,
                                              clipBehavior: Clip.antiAlias,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      itemCount: 6,
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                      BlocBuilder<AssignBrokerBloc, AssignBrokerState>(
                        builder: (context, state) {
                          if (state is AssignBrokerLoadingProgress) {
                            return Container(
                              color: Colors.white54,
                              child: const Center(
                                  child: CircularProgressIndicator()),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
