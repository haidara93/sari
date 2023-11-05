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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_img/flutter_img.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
                      child: CachedNetworkImage(
                          imageUrl: state.tradeDescription
                              .imageDescriptions![index4].image!),
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
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(children: [
                          Text(
                            state.notes[index2].noteNum!,
                            style: const TextStyle(
                                color: Colors.yellow,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          Text("  ${state.notes[index2].noteA!}"),
                        ]),
                      );
                    },
                  );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ));
    } else {
      list.add(ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          ExpansionTile(
            title: Row(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Image.asset("assets/icons/trade_description.png"),
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
            onExpansionChanged: (value) {
              if (value) {
                BlocProvider.of<FeeTradeDescriptionBloc>(context)
                    .add(FeeTradeDescriptionLoadEvent(fe.id!));
              } else {}
            },
            children: buildFeesTradeDescription(),
          ),
          ExpansionTile(
            title: Row(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Image.asset("assets/icons/import_conditions.png"),
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
            children: const [],
          ),
          ExpansionTile(
            title: Row(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Image.asset("assets/icons/export_conditions.png"),
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
          GestureDetector(
            onTap: () {
              BlocProvider.of<CalculatorPanelBloc>(context)
                  .add(CalculatorPanelOpenEvent());
              BlocProvider.of<FeeItemBloc>(context)
                  .add(FeeItemLoadEvent(fe.id!));
            },
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
          ExpansionTile(
            title: Row(
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
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(children: [
                          Text(
                            state.notes[index2].noteNum!,
                            style: const TextStyle(
                                color: Colors.yellow,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          Text("  ${state.notes[index2].noteA!}"),
                        ]),
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
            return ListView.builder(
              key: Key('feebuilder ${feeselected.toString()}'),
              shrinkWrap: true,
              itemCount: state.fees.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index4) {
                return Container(
                  // margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: feeselected == index4 ? null : Colors.grey[200],
                    gradient: feeselected == index4
                        ? const LinearGradient(
                            colors: [
                                Color.fromARGB(255, 229, 215, 94),
                                Colors.white,
                                Colors.white,
                                Colors.white,
                                Colors.white,
                                Colors.white,
                              ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter)
                        : null,
                    borderRadius: BorderRadius.circular(5),
                    border: feeselected == index4
                        ? Border.all(color: Colors.yellow[600]!, width: 2)
                        : null,
                  ),
                  child: ExpansionTile(
                    key: Key(index4.toString()),
                    initiallyExpanded: index4 == feeselected,
                    trailing: GestureDetector(
                      onTap: () {
                        BlocProvider.of<NoteBloc>(context).add(NoteLoadEvent(
                            state.fees[index4].id!.toString(), NoteType.Fee));
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
                      child: Image.asset(
                        "assets/icons/expansionTileIcon.png",
                        width: 20.w,
                        height: 20.h,
                      ),
                    ),
                    title: Row(
                      children: [
                        Container(
                          // margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: subchapterselected == index3
                                ? null
                                : Colors.white,
                            gradient: subchapterselected == index3
                                ? const LinearGradient(
                                    colors: [
                                        Color.fromARGB(255, 229, 215, 94),
                                        Colors.white,
                                      ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter)
                                : null,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: feeselected == index4
                                ? const Icon(Icons.remove)
                                : const Icon(Icons.add),
                          ),
                        ),
                        Flexible(
                            child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color:
                                feeselected == index4 ? null : Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "${state.fees[index4].id!} ${state.fees[index4].label!}",
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )),
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
                );
              },
            );
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Shimmer.fromColors(
                  baseColor: (Colors.grey[300])!,
                  highlightColor: (Colors.grey[100])!,
                  enabled: true,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * .65,
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
                        child: Column(children: [
                          Text(
                            state.notes[index2].noteNum!,
                            style: const TextStyle(
                                color: Colors.yellow,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          Text("  ${state.notes[index2].noteA!}"),
                        ]),
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
            return ListView.builder(
              key: Key('subchapterbuilder ${subchapterselected.toString()}'),
              shrinkWrap: true,
              itemCount: state.subchapters.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index3) {
                return Container(
                  // margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      ExpansionTile(
                        key: Key(index3.toString()), //attention
                        initiallyExpanded: index3 == subchapterselected,

                        title: Container(
                          decoration: BoxDecoration(
                            color: subchapterselected == index3
                                ? null
                                : Colors.grey[200],
                            gradient: subchapterselected == index3
                                ? const LinearGradient(
                                    colors: [
                                        Color.fromARGB(255, 229, 215, 94),
                                        Colors.white,
                                      ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter)
                                : null,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            children: [
                              Container(
                                // margin: const EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  color: chapterselected == index2
                                      ? null
                                      : Colors.white,
                                  gradient: chapterselected == index2
                                      ? const LinearGradient(
                                          colors: [
                                              Color.fromARGB(255, 229, 215, 94),
                                              Colors.white,
                                            ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter)
                                      : null,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: subchapterselected == index3
                                      ? const Icon(Icons.remove)
                                      : const Icon(Icons.add),
                                ),
                              ),
                              Flexible(
                                  child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                width: double.infinity,
                                child: Text(
                                  "${state.subchapters[index3].id!} ${state.subchapters[index3].label!}",
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )),
                            ],
                          ),
                        ),
                        trailing: GestureDetector(
                          onTap: () {
                            BlocProvider.of<NoteBloc>(context).add(
                                NoteLoadEvent(
                                    state.subchapters[index3].id!.toString(),
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
                          child: Image.asset(
                            "assets/icons/expansionTileIcon.png",
                            width: 20.w,
                            height: 20.h,
                          ),
                        ),
                        onExpansionChanged: (value) {
                          if (value) {
                            BlocProvider.of<FeeBloc>(context).add(
                                FeeLoadEvent(state.subchapters[index3].id!));
                            setState(() {
                              subchapterselected = index3;
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
                      index3 != state.subchapters.length - 1
                          ? const Divider(
                              color: Color.fromARGB(255, 229, 215, 94),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                );
              },
            );
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Shimmer.fromColors(
                  baseColor: (Colors.grey[300])!,
                  highlightColor: (Colors.grey[100])!,
                  enabled: true,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * .7,
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
                : Container(
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
                                      style: const TextStyle(
                                          color: Colors.yellow,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text("  ${state.notes[index2].noteA!}"),
                                    Text(
                                      state.notes[index2].noteNum!,
                                      style: const TextStyle(
                                          color: Colors.yellow,
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
      list.add(BlocBuilder<ChapterBloc, ChapterState>(
        builder: (context, state) {
          if (state is ChapterLoadedSuccess) {
            return Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.all(5.0),
              child: ListView.builder(
                key: Key('chapterbuilder ${chapterselected.toString()}'),
                shrinkWrap: true,
                itemCount: state.chapters.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index2) {
                  return Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Theme(
                          data: Theme.of(context)
                              .copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            title: Container(
                              decoration: BoxDecoration(
                                gradient: chapterselected == index2
                                    ? subchapterselected == -1
                                        ? const LinearGradient(
                                            colors: [
                                                Color.fromARGB(
                                                    255, 229, 215, 94),
                                                Colors.white,
                                              ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter)
                                        : null
                                    : null,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    decoration: BoxDecoration(
                                      // color: chapterselected == index2
                                      //     ? null
                                      //     : Colors.white,
                                      border: chapterselected == index2
                                          ? subchapterselected == -1
                                              ? null
                                              : Border.all(
                                                  color: const Color.fromARGB(
                                                      255, 229, 215, 94),
                                                  width: 1,
                                                )
                                          : Border.all(
                                              color: const Color.fromARGB(
                                                  255, 229, 215, 94),
                                              width: 1,
                                            ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Center(
                                      child: chapterselected == index2
                                          ? const Icon(Icons.remove)
                                          : const Icon(Icons.add),
                                    ),
                                  ),
                                  Flexible(
                                      child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: chapterselected == index2
                                          ? subchapterselected == -1
                                              ? Colors.white
                                              : null
                                          : null,
                                      gradient: chapterselected == index2
                                          ? subchapterselected == -1
                                              ? const LinearGradient(
                                                  colors: [
                                                      Color.fromARGB(
                                                          255, 229, 215, 94),
                                                      Colors.white,
                                                    ],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter)
                                              : null
                                          : null,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      "${state.chapters[index2].id!} ${state.chapters[index2].label!}",
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )),
                                ],
                              ),
                            ),
                            trailing: GestureDetector(
                              onTap: () {
                                BlocProvider.of<NoteBloc>(context).add(
                                    NoteLoadEvent(
                                        state.chapters[index2].id!.toString(),
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
                              child: Image.asset(
                                "assets/icons/expansionTileIcon.png",
                                width: 20.w,
                                height: 20.h,
                              ),
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
                        const Divider(
                          color: Color.fromARGB(255, 229, 215, 94),
                        ),
                      ],
                    ),
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
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * .75,
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
                RepositoryProvider.of<AccordionRepository>(context)),
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
                          controller: scroll,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.sections.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 4.h, horizontal: 3.w),
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: selected == index
                                      ? Border.all(
                                          color: Colors.yellow[600]!, width: 2)
                                      : null),
                              child: ExpansionTile(
                                key: Key(index.toString()), //attention
                                initiallyExpanded: index == selected,

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
                                          duration: const Duration(seconds: 1),
                                          curve: Curves.easeIn);
                                    } else {
                                      setState(() {
                                        selected = -1;
                                        shownote = false;
                                        noteType = NoteType.None;
                                      });
                                    }
                                  },
                                  child: Image.asset(
                                    "assets/icons/expansionTileIcon.png",
                                    width: 20.w,
                                    height: 20.h,
                                  ),
                                ),
                                title: Row(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 3),
                                      child: SizedBox(
                                        width: 36.w,
                                        height: 36.h,
                                        child: Img(
                                          state.sections[index].image!,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 100.w,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 3),
                                        child: Column(
                                          children: [
                                            FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                state.sections[index].name!,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                    ),
                                    Flexible(
                                      child: Text(
                                        state.sections[index].label!,
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),

                                onExpansionChanged: (value) {
                                  if (value) {
                                    BlocProvider.of<ChapterBloc>(context).add(
                                        ChapterLoadEvent(
                                            state.sections[index].id!));
                                    setState(() {
                                      selected = index;
                                      chapterselected = -1;
                                      subchapterselected = -1;
                                    });

                                    scroll.animateTo(
                                        index +
                                            MediaQuery.of(context).size.width /
                                                2,
                                        duration: const Duration(seconds: 1),
                                        curve: Curves.easeIn);
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
