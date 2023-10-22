import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:custome_mobile/business_logic/bloc/group_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/post_bloc.dart';
import 'package:custome_mobile/views/widgets/calculator_loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TraderMainScreen extends StatefulWidget {
  const TraderMainScreen({Key? key}) : super(key: key);

  @override
  State<TraderMainScreen> createState() => _TraderMainScreenState();
}

class _TraderMainScreenState extends State<TraderMainScreen> {
  int isvisivle = 0;
  bool addgroup = false;
  bool savepost = false;
  List<Color> colors = [
    Colors.red[300]!,
    Colors.yellow[300]!,
    Colors.blue[300]!,
    Colors.pink[200]!,
    Colors.purple[200]!
  ];
  final GlobalKey<FormState> _groupform = GlobalKey();
  String groupName = "";

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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey[200],
          body: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: BlocBuilder<PostBloc, PostState>(
              builder: (context, state) {
                if (state is PostLoadedSuccess) {
                  return ListView.builder(
                    itemCount: state.posts.length,
                    itemBuilder: (context, index) {
                      DateTime now = DateTime.now();
                      Duration diff = now.difference(state.posts[index].date!);
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        elevation: 1,
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 15),
                        clipBehavior: Clip.hardEdge,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CachedNetworkImage(
                                imageUrl: state.posts[index].image!,
                                height: 185,
                                width: double.infinity,
                              ),
                              SizedBox(
                                height: 12.h,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(diffText(diff)),
                                    Text(state.posts[index].title!),
                                    Text(
                                        "المصدر: ${state.posts[index].source!}"),
                                    Visibility(
                                      visible:
                                          isvisivle == state.posts[index].id!,
                                      child: Text(
                                        state.posts[index].content!,
                                        maxLines: 1000,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        BlocListener<GroupBloc, GroupState>(
                                          listener: (context, state3) {
                                            if (state3
                                                is PostUnsavedSuccessfully) {
                                              const snackBar = SnackBar(
                                                content: Text(
                                                    'تم حذف المنشور من المحفوظات'),
                                              );
                                              BlocProvider.of<PostBloc>(context)
                                                  .add(PostSaveEvent(
                                                      state.posts[index].id!,
                                                      false));
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                            }
                                          },
                                          child: GestureDetector(
                                              onTap: () {
                                                state.posts[index].is_saved!
                                                    ? (BlocProvider.of<
                                                            GroupBloc>(context)
                                                        .add(UnSavePostEvent(
                                                            state.posts[index]
                                                                .id!)))
                                                    : showModalBottomSheet(
                                                        context: context,
                                                        shape: const RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.vertical(
                                                                    top: Radius
                                                                        .circular(
                                                                            20))),
                                                        builder: (context) =>
                                                            StatefulBuilder(builder:
                                                                (BuildContext
                                                                        context,
                                                                    setStte) {
                                                          return Directionality(
                                                            textDirection:
                                                                TextDirection
                                                                    .rtl,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Center(
                                                                  child: BlocConsumer<
                                                                      GroupBloc,
                                                                      GroupState>(
                                                                listener:
                                                                    (context,
                                                                        state2) {
                                                                  if ((state2
                                                                          is GroupListLoadedSuccess) &
                                                                      savepost) {
                                                                    const snackBar =
                                                                        SnackBar(
                                                                      content: Text(
                                                                          'تم حفظ المنشور في المحفوظات'),
                                                                    );
                                                                    BlocProvider.of<PostBloc>(context).add(PostSaveEvent(
                                                                        state
                                                                            .posts[index]
                                                                            .id!,
                                                                        true));
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                            snackBar);

                                                                    Navigator.pop(
                                                                        context);
                                                                    setStte(() {
                                                                      savepost =
                                                                          false;
                                                                    });
                                                                  }
                                                                },
                                                                builder: (context,
                                                                    groupstate) {
                                                                  if (groupstate
                                                                      is GroupListLoadedSuccess) {
                                                                    return addgroup
                                                                        ? Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            children: [
                                                                              const SizedBox(
                                                                                height: 60,
                                                                              ),
                                                                              Form(
                                                                                key: _groupform,
                                                                                child: TextFormField(
                                                                                  decoration: InputDecoration(
                                                                                    labelText: "اسم المجموعة",
                                                                                    border: OutlineInputBorder(
                                                                                      borderRadius: BorderRadius.circular(5),
                                                                                    ),
                                                                                  ),
                                                                                  validator: (value) {
                                                                                    if (value!.isEmpty) {
                                                                                      return "أدخل اسم";
                                                                                    }
                                                                                    return null;
                                                                                  },
                                                                                  onSaved: (newValue) {
                                                                                    groupName = newValue!;
                                                                                  },
                                                                                ),
                                                                              ),
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                children: [
                                                                                  ElevatedButton(
                                                                                      onPressed: () {
                                                                                        setStte(() {
                                                                                          addgroup = false;
                                                                                        });
                                                                                      },
                                                                                      child: const Text("إلغاء")),
                                                                                  ElevatedButton(
                                                                                      onPressed: () {
                                                                                        if (_groupform.currentState!.validate()) {
                                                                                          _groupform.currentState!.save();

                                                                                          setStte(() {
                                                                                            addgroup = false;
                                                                                          });
                                                                                          BlocProvider.of<GroupBloc>(context).add(GroupAddEvent(groupName));
                                                                                        }
                                                                                      },
                                                                                      child: const Text("حفظ")),
                                                                                ],
                                                                              )
                                                                            ],
                                                                          )
                                                                        : Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            children: [
                                                                              const Text(
                                                                                "حفظ",
                                                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                                                                              ),
                                                                              const Divider(),
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    const Text(
                                                                                      "المجموعات",
                                                                                      style: TextStyle(fontWeight: FontWeight.bold),
                                                                                    ),
                                                                                    GestureDetector(
                                                                                      onTap: () {
                                                                                        setStte(() {
                                                                                          addgroup = true;
                                                                                        });
                                                                                      },
                                                                                      child: Row(
                                                                                        children: const [
                                                                                          Text(
                                                                                            "اضافة مجموعة جديدة",
                                                                                            style: TextStyle(color: Colors.greenAccent),
                                                                                          ),
                                                                                          Icon(Icons.add_circle_outline_rounded, color: Colors.greenAccent),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              const Divider(),
                                                                              ListView.builder(
                                                                                shrinkWrap: true,
                                                                                itemCount: groupstate.groups.length,
                                                                                itemBuilder: (context, index2) {
                                                                                  return Padding(
                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                    child: GestureDetector(
                                                                                      onTap: () {
                                                                                        setStte(() {
                                                                                          savepost = true;
                                                                                        });
                                                                                        BlocProvider.of<GroupBloc>(context).add(SavePostEvent(state.posts[index].id!, groupstate.groups[index2].id!));
                                                                                      },
                                                                                      child: SizedBox(
                                                                                        height: 65.h,
                                                                                        child: Column(
                                                                                          children: [
                                                                                            Row(
                                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                              children: [
                                                                                                Row(
                                                                                                  children: [
                                                                                                    Container(
                                                                                                      height: 45.h,
                                                                                                      width: 45.w,
                                                                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: colors[Random().nextInt(5)]),
                                                                                                      child: Center(child: Text(groupstate.groups[index2].name![0])),
                                                                                                    ),
                                                                                                    const SizedBox(
                                                                                                      width: 5,
                                                                                                    ),
                                                                                                    Text(groupstate.groups[index2].name!),
                                                                                                  ],
                                                                                                ),
                                                                                                const Icon(Icons.add_circle_outline_rounded, color: Colors.greenAccent),
                                                                                              ],
                                                                                            ),
                                                                                            const Divider()
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  );
                                                                                },
                                                                              ),
                                                                            ],
                                                                          );
                                                                  } else {
                                                                    return const CircularProgressIndicator();
                                                                  }
                                                                },
                                                              )),
                                                            ),
                                                          );
                                                        }),
                                                      );
                                              },
                                              child: state
                                                      .posts[index].is_saved!
                                                  ? const Icon(Icons.bookmark)
                                                  : const Icon(
                                                      Icons.bookmark_border)),
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                if (isvisivle ==
                                                    state.posts[index].id!) {
                                                  isvisivle = 0;
                                                } else {
                                                  isvisivle =
                                                      state.posts[index].id!;
                                                }
                                              });
                                            },
                                            child: const Text("اقرأ المزيد"))
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ]),
                      );
                    },
                  );
                } else {
                  return const CalculatorLoadingScreen();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
