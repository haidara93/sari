import 'package:cached_network_image/cached_network_image.dart';
import 'package:custome_mobile/business_logic/bloc/calculator_panel_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/chapter_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/fee_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/fee_item_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/fee_trade_description_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/note_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/section_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/sub_chapter_bloc.dart';
import 'package:custome_mobile/constants/enums.dart';
import 'package:custome_mobile/data/models/accurdion_model.dart';
import 'package:custome_mobile/data/repositories/accurdion_repository.dart';
import 'package:custome_mobile/helpers/color_constants.dart';
import 'package:custome_mobile/views/widgets/tariff_info_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_img/flutter_img.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

class CustomeTariffScreen extends StatefulWidget {
  const CustomeTariffScreen({Key? key}) : super(key: key);

  @override
  State<CustomeTariffScreen> createState() => _CustomeTariffScreenState();
}

class _CustomeTariffScreenState extends State<CustomeTariffScreen> {
  // final _headerStyle = const TextStyle(
  //     color: Color(0xffffffff), fontSize: 15, fontWeight: FontWeight.bold);
  final ScrollController _scrollController = ScrollController();

  List<Widget> buildFeesTradeDescription() {
    List<Widget> list = [];
    list.add(BlocBuilder<FeeTradeDescriptionBloc, FeeTradeDescriptionState>(
      builder: (context, state) {
        if (state is FeeTradeDescriptionLoadedSuccess) {
          return Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount:
                    state.tradeDescription.commercialDescriptions!.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index4) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    // decoration: BoxDecoration(
                    //   color: Colors.white,
                    //   borderRadius: BorderRadius.circular(10),
                    // ),
                    child: Text(state.tradeDescription
                        .commercialDescriptions![index4].secondDescription!),
                  );
                },
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 50,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.tradeDescription.imageDescriptions!.length,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index4) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      // decoration: BoxDecoration(
                      //   color: Colors.white,
                      //   borderRadius: BorderRadius.circular(10),
                      // ),
                      child: Image.network(
                        state
                            .tradeDescription.imageDescriptions![index4].image!,
                        height: 35.h,
                        width: 35.w,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 35.h,
                            width: 35.w,
                            color: Colors.grey[300],
                            child: const Center(child: Text("error")),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        } else {
          return Shimmer.fromColors(
            baseColor: (Colors.grey[300])!,
            highlightColor: (Colors.grey[100])!,
            enabled: true,
            child: SizedBox(
              // width: MediaQuery.of(context).size.width * .7,
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (_, __) => Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 3),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SizedBox(
                    height: 60.h,
                  ),
                ),
                itemCount: 3,
              ),
            ),
          );
        }
      },
    ));
    return list;
  }

  List<Widget> buildfeesChildren(FeeSet fe) {
    List<Widget> list = [];
    if (shownote && (noteType == NoteType.Fee)) {
      list.add(BlocBuilder<NoteBloc, NoteState>(
        builder: (context, state) {
          if (state is NoteLoadedSuccess) {
            return state.notes.isEmpty
                ? const SizedBox(
                    height: 50,
                    child: Center(
                      child: Text("لايوجد ملاحظات"),
                    ))
                : ListView.builder(
                    // key: Key('sectionnotebuilder ${chapterselected.toString()}'),
                    shrinkWrap: true,
                    itemCount: state.notes.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index2) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.notes[index2].noteNum!,
                                  style: TextStyle(
                                      color: AppColor.deepBlue,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text("  ${state.notes[index2].noteA!}"),
                              ]),
                        ),
                      );
                    },
                  );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ));
    } else {
      list.add(Container(
        color: Colors.white,
        child: ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Divider(
              height: 1,
              color: AppColor.goldenYellow,
            ),
            ExpansionTile(
              title: Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child:
                            Image.asset("assets/icons/trade_description.png"),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "الوصف التجاري",
                      ),
                    ),
                  ],
                ),
              ),
              onExpansionChanged: (value) {
                if (value) {
                  BlocProvider.of<FeeTradeDescriptionBloc>(context)
                      .add(FeeTradeDescriptionLoadEvent(fe.id!));
                } else {}
              },
              children: buildFeesTradeDescription(),
            ),
            Divider(
              height: 1,
              color: AppColor.goldenYellow,
            ),
            ExpansionTile(
              title: Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child:
                            Image.asset("assets/icons/import_conditions.png"),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "شروط الاستيراد",
                      ),
                    ),
                  ],
                ),
              ),
              children: const [],
            ),
            Divider(
              height: 1,
              color: AppColor.goldenYellow,
            ),
            ExpansionTile(
              title: Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child:
                            Image.asset("assets/icons/export_conditions.png"),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "شروط التصدير",
                      ),
                    ),
                  ],
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset("assets/icons/export_restrection.png"),
                          const Text("شروط التصدير:"),
                          fe.export! == "مسموح التصدير"
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                )
                              : const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                          Text(fe.export!),
                        ],
                      ),
                      Text(
                        fe.restrictionExport!,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(
              height: 1,
              color: AppColor.goldenYellow,
            ),
            ExpansionTile(
              title: Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Image.asset("assets/icons/calculate_fees.png"),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "حساب الرسوم",
                      ),
                    ),
                  ],
                ),
              ),
              onExpansionChanged: (value) {
                BlocProvider.of<CalculatorPanelBloc>(context)
                    .add(CalculatorPanelOpenEvent());
                BlocProvider.of<FeeItemBloc>(context)
                    .add(FeeItemLoadEvent(fe.id!));
              },
              trailing: const SizedBox.shrink(),
            ),
            Divider(
              height: 1,
              color: AppColor.goldenYellow,
            ),
            ExpansionTile(
              title: Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Image.asset("assets/icons/share_fee.png"),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "مشاركة",
                      ),
                    ),
                  ],
                ),
              ),
              trailing: const SizedBox.shrink(),

              // onExpansionChanged: (value) {
              //   if (value) {
              //     // BlocProvider.of<FeeBloc>(context)
              //     //     .add(FeeLoadEvent(state.subchapters[index].id!));
              //     setState(() {
              //       feeselected = index4;
              //     });
              //   } else {
              //     setState(() {
              //       feeselected = -1;
              //     });
              //   }
              // },
              // children: buildFeesTiles(),
            ),
          ],
        ),
      ));
    }
    return list;
  }

  buildFeesTiles(int index3) {
    List<Widget> list = [];
    if (shownote && (noteType == NoteType.SubChapter)) {
      list.add(BlocBuilder<NoteBloc, NoteState>(
        builder: (context, state) {
          if (state is NoteLoadedSuccess) {
            return state.notes.isEmpty
                ? const SizedBox(
                    height: 50,
                    child: Center(
                      child: Text("لايوجد ملاحظات"),
                    ))
                : ListView.builder(
                    // key: Key('sectionnotebuilder ${chapterselected.toString()}'),
                    shrinkWrap: true,
                    itemCount: state.notes.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index2) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.notes[index2].noteNum!,
                                  style: TextStyle(
                                      color: AppColor.deepBlue,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text("  ${state.notes[index2].noteA!}"),
                              ]),
                        ),
                      );
                    },
                  );
          } else {
            return Shimmer.fromColors(
              baseColor: (Colors.grey[300])!,
              highlightColor: (Colors.grey[100])!,
              enabled: true,
              child: SizedBox(
                // width: MediaQuery.of(context).size.width * .7,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (_, __) => Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 3),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SizedBox(
                      height: 180.h,
                    ),
                  ),
                  itemCount: 1,
                ),
              ),
            );
          }
        },
      ));
    } else {
      list.add(BlocBuilder<FeeBloc, FeeState>(
        builder: (context, state) {
          if (state is FeeLoadedSuccess) {
            return Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.all(3.0),
              child: ListView.builder(
                key: Key('feebuilder ${feeselected.toString()}'),
                shrinkWrap: true,
                itemCount: state.fees.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index4) {
                  return Column(
                    children: [
                      Card(
                        // margin: const EdgeInsets.symmetric(horizontal: 4),
                        margin: const EdgeInsets.all(2),
                        // decoration: BoxDecoration(
                        //   color: feeselected == index4 ? Colors.white : null,
                        //   borderRadius: BorderRadius.circular(5),
                        //   border: feeselected == index4
                        //       ? Border.all(color: AppColor.goldenYellow, width: 2)
                        //       : null,
                        // ),
                        elevation: feeselected == index4 ? 1 : 0,
                        color: feeselected == index4
                            ? Colors.white
                            : Colors.grey[200],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                              color: feeselected == index4
                                  ? AppColor.goldenYellow
                                  : Colors.grey[200]!,
                              width: 2),
                        ),
                        child: ExpansionTile(
                          key: Key(index4.toString()),
                          tilePadding: EdgeInsets.zero,
                          initiallyExpanded: index4 == feeselected,
                          controlAffinity: ListTileControlAffinity.leading,
                          leading: Container(
                            margin: EdgeInsets.symmetric(horizontal: 7),
                            child: feeselected == index4
                                ? const Icon(Icons.remove)
                                : const Icon(Icons.add),
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      state.fees[index4].id!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Flexible(
                                      child: Text(
                                        state.fees[index4].label!,
                                        style: const TextStyle(height: 1.3),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  BlocProvider.of<NoteBloc>(context).add(
                                      NoteLoadEvent(
                                          state.fees[index4].id!.toString(),
                                          NoteType.Fee));
                                  if (!shownote) {
                                    setState(() {
                                      feeselected = index4;
                                      shownote = true;
                                      noteType = NoteType.Fee;
                                    });
                                  } else {
                                    setState(() {
                                      feeselected = -1;
                                      shownote = false;
                                      noteType = NoteType.None;
                                    });
                                  }
                                },
                                child: const TariffInfoIcon(),
                              ),
                            ],
                          ),
                          onExpansionChanged: (value) {
                            if (value) {
                              setState(() {
                                feeselected = index4;
                              });
                            } else {
                              setState(() {
                                feeselected = -1;

                                shownote = false;
                                noteType = NoteType.None;
                              });
                            }
                          },
                          children: buildfeesChildren(state.fees[index4]),
                        ),
                      ),
                      index4 == (state.fees.length - 1)
                          ? const SizedBox.shrink()
                          : Divider(
                              height: 1,
                              color: AppColor.goldenYellow,
                            ),
                    ],
                  );
                },
              ),
            );
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Shimmer.fromColors(
                  baseColor: (Colors.grey[300])!,
                  highlightColor: (Colors.grey[100])!,
                  enabled: true,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .85,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (_, __) => Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 3),
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SizedBox(
                              height: 40.h,
                            ),
                          ),
                          itemCount: 4,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .05,
                ),
              ],
            );
          }
        },
      ));
    }
    return list;
  }

  buildSubChapterTiles(int index2) {
    List<Widget> list = [];
    if (shownote && (noteType == NoteType.Chapter)) {
      list.add(BlocBuilder<NoteBloc, NoteState>(
        builder: (context, state) {
          if (state is NoteLoadedSuccess) {
            return state.notes.isEmpty
                ? const SizedBox(
                    height: 50,
                    child: Center(
                      child: Text("لايوجد ملاحظات"),
                    ))
                : ListView.builder(
                    // key: Key('sectionnotebuilder ${chapterselected.toString()}'),
                    shrinkWrap: true,
                    itemCount: state.notes.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index2) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.notes[index2].noteNum!,
                                  style: TextStyle(
                                      color: AppColor.deepBlue,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text("  ${state.notes[index2].noteA!}"),
                              ]),
                        ),
                      );
                    },
                  );
          } else {
            return Shimmer.fromColors(
              baseColor: (Colors.grey[300])!,
              highlightColor: (Colors.grey[100])!,
              enabled: true,
              child: SizedBox(
                // width: MediaQuery.of(context).size.width * .7,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (_, __) => Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 3),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SizedBox(
                      height: 180.h,
                    ),
                  ),
                  itemCount: 1,
                ),
              ),
            );
          }
        },
      ));
    } else {
      list.add(BlocBuilder<SubChapterBloc, SubChapterState>(
        builder: (context, state) {
          if (state is SubChapterLoadedSuccess) {
            return Container(
              color: Colors.white,
              padding: const EdgeInsets.only(top: 0.0),
              child: ListView.builder(
                key: Key('subchapterbuilder ${subchapterselected.toString()}'),
                shrinkWrap: true,
                itemCount: state.subchapters.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index3) {
                  return Column(
                    children: [
                      Card(
                        margin: const EdgeInsets.all(2),
                        clipBehavior: Clip.antiAlias,
                        // decoration: BoxDecoration(
                        //   color: subchapterselected == index3
                        //       ? Colors.white
                        //       : null,
                        //   border: subchapterselected == index3
                        //       ? feeselected == -1
                        //           ? Border.all(
                        //               color: AppColor.goldenYellow, width: 2)
                        //           : null
                        //       : null,
                        //   borderRadius: BorderRadius.circular(10),
                        // ),
                        elevation: subchapterselected == index3 ? 1 : 0,
                        color: subchapterselected == index3
                            ? Colors.white
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                              color: subchapterselected == index3
                                  ? feeselected == -1
                                      ? AppColor.goldenYellow
                                      : Colors.white
                                  : Colors.white,
                              width: 2),
                        ),
                        child: ExpansionTile(
                          key: Key(index3.toString()), //attention
                          initiallyExpanded: index3 == subchapterselected,
                          tilePadding: EdgeInsets.zero,

                          controlAffinity: ListTileControlAffinity.leading,
                          childrenPadding: EdgeInsets.zero,
                          leading: Container(
                            margin: EdgeInsets.symmetric(horizontal: 7),
                            child: subchapterselected == index3
                                ? const Icon(Icons.remove)
                                : const Icon(Icons.add),
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      state.subchapters[index3].id!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Flexible(
                                      child: Text(
                                        state.subchapters[index3].label!,
                                        style: const TextStyle(height: 1.3),
                                        maxLines: 10,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  BlocProvider.of<NoteBloc>(context).add(
                                      NoteLoadEvent(
                                          state.subchapters[index3].id!
                                              .toString(),
                                          NoteType.SubChapter));
                                  if (!shownote) {
                                    setState(() {
                                      subchapterselected = index3;
                                      shownote = true;
                                      noteType = NoteType.SubChapter;
                                    });
                                  } else {
                                    setState(() {
                                      subchapterselected = -1;
                                      shownote = false;
                                      noteType = NoteType.None;
                                    });
                                  }
                                },
                                child: const TariffInfoIcon(),
                              ),
                            ],
                          ),
                          onExpansionChanged: (value) {
                            if (value) {
                              print(state.subchapters[index3].id!);
                              BlocProvider.of<FeeBloc>(context).add(
                                  FeeLoadEvent(state.subchapters[index3].id!));
                              setState(() {
                                subchapterselected = index3;
                                feeselected = -1;
                              });
                            } else {
                              setState(() {
                                subchapterselected = -1;
                                shownote = false;
                                noteType = NoteType.None;
                              });
                            }
                          },
                          children: buildFeesTiles(index3),
                        ),
                      ),
                      state.subchapters.length - 1 == index3
                          ? const SizedBox.shrink()
                          : Divider(
                              height: 1,
                              color: AppColor.goldenYellow,
                            ),
                    ],
                  );
                },
              ),
            );
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Shimmer.fromColors(
                  baseColor: (Colors.grey[300])!,
                  highlightColor: (Colors.grey[100])!,
                  enabled: true,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .85,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (_, __) => Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 3),
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SizedBox(
                              height: 40.h,
                            ),
                          ),
                          itemCount: 4,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .05,
                ),
              ],
            );
          }
        },
      ));
    }

    return list;
  }

  buildChapterTiles() {
    // _CustomeTariffScreenState? stateobject =
    //     context.findAncestorStateOfType<_CustomeTariffScreenState>();
    List<Widget> list = [];
    if (shownote && (noteType == NoteType.Section)) {
      list.add(BlocBuilder<NoteBloc, NoteState>(
        builder: (context, state) {
          if (state is NoteLoadedSuccess) {
            return state.notes.isEmpty
                ? const SizedBox(
                    height: 50,
                    child: Center(
                      child: Text("لايوجد ملاحظات"),
                    ))
                : Directionality(
                    textDirection: TextDirection.rtl,
                    child: Container(
                      color: Colors.grey[200],
                      height: 180,
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Scrollbar(
                          controller: _scrollController,
                          thumbVisibility: true,
                          thickness: 5.0,
                          radius: const Radius.circular(2),
                          child: ListView.builder(
                            // key: Key('sectionnotebuilder ${chapterselected.toString()}'),
                            controller: _scrollController,

                            itemCount: state.notes.length, shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemBuilder: (context, index2) {
                              return Container(
                                padding: const EdgeInsets.all(8.0),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        state.notes[index2].noteNum!,
                                        style: TextStyle(
                                            color: AppColor.deepBlue,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text("  ${state.notes[index2].noteA!}"),
                                    ]),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  );
          } else {
            return Shimmer.fromColors(
              baseColor: (Colors.grey[300])!,
              highlightColor: (Colors.grey[100])!,
              enabled: true,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .85,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (_, __) => Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 3),
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SizedBox(
                          height: 180.h,
                        ),
                      ),
                      itemCount: 1,
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ));
    } else {
      list.add(BlocBuilder<ChapterBloc, ChapterState>(
        builder: (context, state) {
          if (state is ChapterLoadedSuccess) {
            return Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.only(top: 3.0),
              child: ListView.builder(
                key: Key('chapterbuilder ${chapterselected.toString()}'),
                shrinkWrap: true,
                itemCount: state.chapters.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index2) {
                  return Column(
                    children: [
                      Card(
                        margin: const EdgeInsets.all(2),
                        clipBehavior: Clip.antiAlias,
                        // decoration: BoxDecoration(
                        //   color: chapterselected == index2
                        //       ? subchapterselected == -1
                        //           ? Colors.white
                        //           : null
                        //       : null,
                        //   border: chapterselected == index2
                        //       ? subchapterselected == -1
                        //           ? Border.all(
                        //               color: AppColor.goldenYellow, width: 2)
                        //           : null
                        //       : null,
                        //   borderRadius: BorderRadius.circular(10),
                        // ),
                        elevation: chapterselected == index2 ? 1 : 0,
                        color: chapterselected == index2
                            ? Colors.grey[200]
                            : Colors.grey[200],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                              color: chapterselected == index2
                                  ? subchapterselected == -1
                                      ? AppColor.goldenYellow
                                      : Colors.grey[200]!
                                  : Colors.grey[200]!,
                              width: 2),
                        ),

                        child: ListTileTheme(
                          contentPadding: EdgeInsets.all(0),
                          dense: true,
                          horizontalTitleGap: 0.0,
                          minLeadingWidth: 0,
                          child: ExpansionTile(
                            tilePadding: EdgeInsets.zero,
                            controlAffinity: ListTileControlAffinity.leading,
                            childrenPadding: EdgeInsets.zero,
                            leading: Container(
                              margin: EdgeInsets.symmetric(horizontal: 7),
                              child: chapterselected == index2
                                  ? const Icon(Icons.remove)
                                  : const Icon(Icons.add),
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        state.chapters[index2].id!,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Flexible(
                                        child: Text(
                                          state.chapters[index2].label!,
                                          style: const TextStyle(height: 1.3),
                                          maxLines: 10,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    BlocProvider.of<NoteBloc>(context).add(
                                        NoteLoadEvent(
                                            state.chapters[index2].id!
                                                .toString(),
                                            NoteType.Chapter));
                                    if (!shownote) {
                                      setState(() {
                                        chapterselected = index2;

                                        subchapterselected = -1;
                                        shownote = true;
                                        noteType = NoteType.Chapter;
                                      });
                                    } else {
                                      setState(() {
                                        chapterselected = -1;
                                        shownote = false;
                                        noteType = NoteType.None;
                                      });
                                    }
                                  },
                                  child: const TariffInfoIcon(),
                                ),
                              ],
                            ),
                            key: Key(index2.toString()), //attention
                            initiallyExpanded: index2 == chapterselected,

                            onExpansionChanged: (value) {
                              if (value) {
                                BlocProvider.of<SubChapterBloc>(context).add(
                                    SubChapterLoadEvent(
                                        state.chapters[index2].id!));
                                setState(() {
                                  chapterselected = index2;

                                  subchapterselected = -1;
                                  feeselected = -1;
                                });
                              } else {
                                setState(() {
                                  chapterselected = -1;
                                  shownote = false;
                                  noteType = NoteType.None;
                                });
                              }
                            },
                            children: buildSubChapterTiles(index2),
                          ),
                        ),
                      ),
                      state.chapters.length - 1 == index2
                          ? const SizedBox.shrink()
                          : Divider(
                              height: 1,
                              color: AppColor.goldenYellow,
                            ),
                    ],
                  );
                },
              ),
            );
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Shimmer.fromColors(
                  baseColor: (Colors.grey[300])!,
                  highlightColor: (Colors.grey[100])!,
                  enabled: true,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * .85,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (_, __) => Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 3),
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SizedBox(
                          height: 40.h,
                        ),
                      ),
                      itemCount: 4,
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ));
    }

    return list;
  }

  final ScrollController scroll = ScrollController();

  @override
  void dispose() {
    scroll.dispose();
    super.dispose();
  }

  int? selected;
  int? chapterselected;
  int? subchapterselected;
  int? feeselected;
  bool shownote = false;
  NoteType noteType = NoteType.None;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider(
        create: (context) => NoteBloc(
          accordionRepository:
              RepositoryProvider.of<AccordionRepository>(context),
        ),
        child: Scaffold(
          backgroundColor: Colors.grey[200],
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 30.h,
                ),
                Padding(
                  padding: EdgeInsets.all(8.h),
                  child: BlocConsumer<SectionBloc, SectionState>(
                    listener: (context, state) {
                      // if(state is)
                    },
                    builder: (context, state) {
                      if (state is SectionLoadedSuccess) {
                        return ListView.builder(
                          key: Key('builder ${selected.toString()}'),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.sections.length,
                          itemBuilder: (context, index) {
                            final GlobalKey expansionTileKey = GlobalKey();
                            double previousOffset = 0.0;
                            return Card(
                              margin: EdgeInsets.symmetric(
                                  vertical: 4.h, horizontal: 3.w),
                              clipBehavior: Clip.none,
                              shape: RoundedRectangleBorder(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                side: BorderSide(
                                    color: selected == index
                                        ? AppColor.goldenYellow
                                        : Colors.white,
                                    width: 2),
                              ),
                              color: Colors.white,
                              // decoration: BoxDecoration(
                              //   borderRadius: BorderRadius.circular(10),
                              //   border: selected == index
                              //       ? Border.all(
                              //           color: Colors.yellow[600]!, width: 2)
                              //       : null,
                              // ),
                              child: Theme(
                                data: Theme.of(context)
                                    .copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  key: Key(index.toString()), //attention
                                  initiallyExpanded: index == selected,
                                  tilePadding: EdgeInsets.all(5),
                                  // controlAffinity:
                                  //     ListTileControlAffinity.leading,
                                  trailing: GestureDetector(
                                    onTap: () {
                                      BlocProvider.of<NoteBloc>(context).add(
                                          NoteLoadEvent(
                                              state.sections[index].id!
                                                  .toString(),
                                              NoteType.Section));
                                      if (!shownote) {
                                        setState(() {
                                          selected = index;
                                          chapterselected = -1;
                                          subchapterselected = -1;
                                          shownote = true;
                                          noteType = NoteType.Section;
                                        });

                                        scroll.animateTo(
                                            index +
                                                MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2,
                                            duration:
                                                const Duration(seconds: 1),
                                            curve: Curves.easeIn);
                                      } else {
                                        setState(() {
                                          selected = -1;
                                          shownote = false;
                                          noteType = NoteType.None;
                                        });
                                      }
                                    },
                                    child: const TariffInfoIcon(),
                                  ),

                                  title: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 65.w,
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              width: 36.w,
                                              height: 36.h,
                                              child: SvgPicture.network(
                                                state.sections[index].image!,
                                              ),
                                            ),
                                            Text(
                                              "(${state.sections[index].end!}__${state.sections[index].start!})",
                                              style:
                                                  const TextStyle(fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.w,
                                      ),
                                      Flexible(
                                        child: Text(
                                          state.sections[index].label!,
                                          style: const TextStyle(
                                            height: 1.3,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 10,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),

                                  onExpansionChanged: (value) {
                                    if (value) {
                                      BlocProvider.of<ChapterBloc>(context).add(
                                        ChapterLoadEvent(
                                            state.sections[index].id!),
                                      );
                                      setState(() {
                                        selected = index;
                                        chapterselected = -1;
                                        subchapterselected = -1;
                                        feeselected = -1;
                                      });
                                    } else {
                                      setState(() {
                                        selected = -1;
                                        shownote = false;
                                        noteType = NoteType.None;
                                      });
                                    }
                                  },
                                  children: buildChapterTiles(),
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
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemBuilder: (_, __) => Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 3),
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: SizedBox(
                                height: 90.h,
                              ),
                            ),
                            itemCount: 10,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
