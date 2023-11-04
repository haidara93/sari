import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:custome_mobile/business_logic/bloc/additional_attachment_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/attachment_type_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/offer_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/trader_additional_attachment_bloc.dart';
import 'package:custome_mobile/data/models/attachments_models.dart';
import 'package:custome_mobile/helpers/color_constants.dart';
import 'package:custome_mobile/views/control_view.dart';
import 'package:custome_mobile/views/widgets/custom_app_bar.dart';
import 'package:custome_mobile/views/widgets/custom_botton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class BrokerAttachmentsScreen extends StatefulWidget {
  final List<Attachment> attachments;
  final List<AttachmentType> additionalAttachments;
  final int offerId;
  final String offerState;

  const BrokerAttachmentsScreen(
      {Key? key,
      required this.attachments,
      required this.additionalAttachments,
      required this.offerId,
      required this.offerState})
      : super(key: key);

  @override
  State<BrokerAttachmentsScreen> createState() =>
      _BrokerAttachmentsScreenState();
}

class _BrokerAttachmentsScreenState extends State<BrokerAttachmentsScreen> {
  List<AttachmentType> attachmentTypes = [];

  File? _image;

  final ImagePicker _picker = ImagePicker();

  bool additionalattachmentsucees = false;

  int additionalattachmentId = 0;

  List<int> attachmentIds = [];

  List<int> additionalattachmentIds = [];

  List<Attachment> attachments = [];
  List<int> attachmentsId = [];

  String attachmentName(int attachmentType) {
    for (var element in attachmentTypes) {
      if (element.id! == attachmentType) {
        return element.name!;
      }
    }
    return "مرفق";
  }

  Widget _buildimagelist() {
    return Image.file(File(_image!.path));
  }

  Widget _previewImages() {
    if (_image != null) {
      return _buildimagelist();
    } else {
      return const Text(
        'الرجاء اختيار صورة لرفعها.',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black),
      );
    }
  }

  List<Widget> _buildAttachmentslist(List<Attachment> attachments) {
    List<Widget> list = [];
    for (var element in attachments) {
      var elem = Container(
        margin: const EdgeInsets.all(7),
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border(
            left: BorderSide(
              color: AppColor.deepAppBarBlue,
              width: 1.0,
            ),
            right: BorderSide(
              color: AppColor.deepAppBarBlue,
              width: 1.0,
            ),
            top: BorderSide(
              color: AppColor.deepAppBarBlue,
              width: 1.0,
            ),
            bottom: BorderSide(
              color: AppColor.deepAppBarBlue,
              width: 1.0,
            ),
          ),
        ),
        height: 150.h,
        width: 130.w,
        child: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            Text(attachmentName(element.attachmentType!)),
            const SizedBox(
              height: 7,
            ),
            Image.network(
              element.image!,
              fit: BoxFit.cover,
              height: 75.h,
              width: 75.w,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
            ),
            const SizedBox(
              height: 3,
            ),
            // GestureDetector(
            //   onTap: () {},
            //   child: const Text("تعديل"),
            // )
          ],
        ),
      );
      list.add(elem);
    }
    return list;
  }

  List<Widget> _buildAttachmentsTypelist(
      List<AttachmentType> attachments, BuildContext context) {
    List<Widget> list = [];
    for (var element in attachments) {
      var elem = SizedBox(
        width: 200.w,
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) =>
                      StatefulBuilder(builder: (context, StateSetter setState) {
                    return Directionality(
                      textDirection: TextDirection.rtl,
                      child: SimpleDialog(
                        title: const Text('إضافة مرفق'),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        contentPadding: const EdgeInsets.all(8),
                        children: [
                          _previewImages(),
                          const SizedBox(
                            height: 7,
                          ),
                          CustomButton(
                            title: const Text("رفع صورة"),
                            color: AppColor.deepYellow,
                            onTap: () async {
                              var pickedImage = await _picker.pickImage(
                                  source: ImageSource.gallery);
                              setState(() {
                                _image = File(pickedImage!.path);
                              });
                            },
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          CustomButton(
                              title: const Text("رفع ملف"),
                              color: AppColor.deepYellow,
                              onTap: () {}),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(element.name!),
                          const SizedBox(
                            height: 15,
                          ),
                          BlocBuilder<TraderAdditionalAttachmentBloc,
                              TraderAdditionalAttachmentState>(
                            builder: (context, state) {
                              if (state
                                  is TraderAdditionalAttachmentLoadingProgress) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Center(child: CircularProgressIndicator()),
                                  ],
                                );
                              } else {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    CustomButton(
                                        title: const SizedBox(
                                          width: 90,
                                          child: Center(child: Text("إغلاق")),
                                        ),
                                        onTap: () {
                                          Navigator.pop(context);
                                        }),
                                    CustomButton(
                                        title: const SizedBox(
                                            width: 90,
                                            child: Center(child: Text("حفظ"))),
                                        onTap: () {
                                          BlocProvider.of<
                                                      TraderAdditionalAttachmentBloc>(
                                                  context)
                                              .add(AddAdditionalAttachmentEvent(
                                                  element.id!,
                                                  _image!,
                                                  widget.offerId,
                                                  widget.offerState,
                                                  attachmentIds,
                                                  widget
                                                      .additionalAttachments));
                                          additionalattachmentsucees = true;
                                          additionalattachmentId = element.id!;
                                        }),
                                  ],
                                );
                              }
                            },
                          )
                        ],
                      ),
                    );
                  }),
                );
              },
              child: Container(
                margin: const EdgeInsets.all(7),
                height: 100.h,
                width: 100.w,
                child: CachedNetworkImage(imageUrl: element.image!),
              ),
            ),
            Text(element.name!)
          ],
        ),
      );
      list.add(elem);
    }
    return list;
  }

  List<Widget> _buildAddionalAttachmentslist(List<Attachment> attachments) {
    List<Widget> list = [];
    for (var element in attachments) {
      var elem = Container(
        margin: const EdgeInsets.all(7),
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border(
            left: BorderSide(
              color: AppColor.deepAppBarBlue,
              width: 1.0,
            ),
            right: BorderSide(
              color: AppColor.deepAppBarBlue,
              width: 1.0,
            ),
            top: BorderSide(
              color: AppColor.deepAppBarBlue,
              width: 1.0,
            ),
            bottom: BorderSide(
              color: AppColor.deepAppBarBlue,
              width: 1.0,
            ),
          ),
        ),
        height: 150.h,
        width: 130.w,
        child: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            Text(attachmentName(element.attachmentType!)),
            const SizedBox(
              height: 7,
            ),
            Image.network(
              element.image!,
              fit: BoxFit.cover,
              height: 75.h,
              width: 75.w,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
            ),
            const SizedBox(
              height: 3,
            ),
            // GestureDetector(
            //   onTap: () {},
            //   child: const Text("تعديل"),
            // )
          ],
        ),
      );
      list.add(elem);
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    for (var element in widget.attachments) {
      attachmentIds.add(element.id!);
    }
    for (var element in widget.additionalAttachments) {
      additionalattachmentIds.add(element.id!);
    }
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: CustomAppBar(title: "تفاصيل المرفقات"),
        backgroundColor: Colors.grey[200],
        body: SingleChildScrollView(
          child: BlocListener<TraderAdditionalAttachmentBloc,
              TraderAdditionalAttachmentState>(
            listener: (context, state) {
              if (state is TraderAdditionalAttachmentLoadedSuccess &&
                  additionalattachmentsucees) {
                Navigator.pop(context);
                additionalattachmentsucees = false;
                setState(() {
                  attachmentsId.add(state.attachment.id!);
                  attachments.add(state.attachment);
                });
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 10.h,
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
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 7),
                    width: double.infinity,
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("الأوراق المحملة"),
                          const SizedBox(
                            height: 5,
                          ),
                          widget.attachments.isEmpty
                              ? Center(
                                  child: Text("لم يتم تحميل أية مرفقات."),
                                )
                              : Wrap(
                                  children: _buildAttachmentslist(
                                      widget.attachments)),
                        ]),
                  ),
                ),
                SizedBox(
                  height: 10.h,
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
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 7),
                    width: double.infinity,
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("الأوراق الاضافية المطلوبة"),
                          const SizedBox(
                            height: 5,
                          ),
                          BlocBuilder<AttachmentTypeBloc, AttachmentTypeState>(
                            builder: (context, state) {
                              if (state is AttachmentTypeLoadedSuccess) {
                                return Wrap(
                                    children: _buildAttachmentsTypelist(
                                        state.attachmentTypes, context));
                              } else if (state is AttachmentTypeInitial) {
                                return widget.additionalAttachments.isEmpty
                                    ? const Center(
                                        child: Text("لا يوجدأية مرفقات إضافية"),
                                      )
                                    : Wrap(
                                        children: _buildAttachmentsTypelist(
                                            widget.additionalAttachments,
                                            context));
                              } else {
                                return const Center(
                                  child: Text("لا يوجدأية مرفقات إضافية"),
                                );
                              }
                            },
                          ),
                        ]),
                  ),
                ),
                SizedBox(
                  height: 10.h,
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
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 7),
                    width: double.infinity,
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("الأوراق الاضافية التي تم تحميلها"),
                          const SizedBox(
                            height: 5,
                          ),
                          BlocBuilder<TraderAdditionalAttachmentBloc,
                              TraderAdditionalAttachmentState>(
                            builder: (context, state) {
                              if (state
                                  is TraderAdditionalAttachmentLoadedSuccess) {
                                return Wrap(
                                    children: _buildAddionalAttachmentslist(
                                        state.attachments));
                              } else {
                                return const Center(
                                  child: Text("لم يتم تحميل أية مرفقات إضافية"),
                                );
                              }
                            },
                          ),
                        ]),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // CustomButton(
                    //   onTap: () {},
                    //   color: AppColor.deepYellow,
                    //   title: const SizedBox(
                    //       width: 100, child: Center(child: Text("إلغاء"))),
                    // ),
                    CustomButton(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ControlView(),
                            ));
                        BlocProvider.of<TraderAdditionalAttachmentBloc>(context)
                            .add(ClearAdditionalAttachmentEvent());
                      },
                      title: SizedBox(
                          width: 180.w,
                          child: const Center(
                              child: Text("الرجوع للقائمة الرئيسية"))),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
