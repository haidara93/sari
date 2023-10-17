import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:custome_mobile/business_logic/bloc/attachment_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/attachment_type_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/offer_bloc.dart';
import 'package:custome_mobile/data/models/attachments_models.dart';
import 'package:custome_mobile/data/models/offer_model.dart';
import 'package:custome_mobile/helpers/color_constants.dart';
import 'package:custome_mobile/views/control_view.dart';
import 'package:custome_mobile/views/widgets/custom_app_bar.dart';
import 'package:custome_mobile/views/widgets/custom_botton.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class OrderAttachmentScreen extends StatefulWidget {
  final Offer offer;

  OrderAttachmentScreen({required this.offer});

  @override
  State<OrderAttachmentScreen> createState() => _OrderAttachmentScreenState();
}

class _OrderAttachmentScreenState extends State<OrderAttachmentScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  AttachmentType? selectedAttachmentType;
  List<Attachment> attachments = [];
  List<int> attachmentsId = [];
  List<int> selectedAttachmentsId = [];

  @override
  void initState() {
    super.initState();
    print(widget.offer.attachments!.length);
    for (var element in widget.offer.attachments!) {
      setState(() {
        attachmentsId.add(element.id!);
        attachments.add(element);
      });
    }
  }

  // _showDatePicker() {
  //   showDatePicker(
  //           context: context,
  //           initialDate: DateTime.now(),
  //           firstDate: DateTime(2020),
  //           lastDate: DateTime(2030))
  //       .then((value) {
  //     setState(() {
  //       productExpireDate = value!;
  //       _expireDate.text = "${value.year}-${value.month}-${value.day}";
  //     });
  //   });
  // }

  imageButtonPressed(ImageSource source, {bool isMultiImage = false}) async {
    if (isMultiImage) {
      try {
        final List<XFile>? pickedFileList = await _picker.pickMultiImage();
        // _imageFileList = pickedFileList;
      } catch (e) {
        // _pickImageError = e;
      }
    } else {
      // _image = await _picker.pickImage(source: source);
    }
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
    int i = 0;
    for (var element in attachments) {
      var elem = Container(
        margin: const EdgeInsets.all(7),
        height: 100.h,
        width: 100.w,
        child: CachedNetworkImage(imageUrl: element.image!),
      );
      i++;
      list.add(elem);
    }
    return list;
  }

  List<Widget> _buildAttachmentsTypelist(List<AttachmentType> attachments) {
    List<Widget> list = [];
    int i = 0;
    for (var element in attachments) {
      var elem = SizedBox(
        width: 200.w,
        child: CheckboxListTile(
          title: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(7),
                height: 100.h,
                width: 100.w,
                child: CachedNetworkImage(imageUrl: element.image!),
              ),
              Text(element.name!)
            ],
          ),
          value: selectedAttachmentsId.contains(element.id),
          onChanged: (value) {
            if (selectedAttachmentsId.contains(element.id)) {
              setState(() {
                selectedAttachmentsId.remove(element.id);
              });
            } else {
              setState(() {
                selectedAttachmentsId.add(element.id!);
              });
            }
          },
        ),
      );
      i++;
      list.add(elem);
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: CustomAppBar(
          title: "طلب مخلص",
        ),
        body: SingleChildScrollView(
          child: BlocListener<AttachmentBloc, AttachmentState>(
            listener: (context, state) {
              if (state is AttachmentLoadedSuccess) {
                Navigator.pop(context);
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
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 7),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("الأوراق المحملة"),
                          SizedBox(
                            height: 5,
                          ),
                          Wrap(children: _buildAttachmentslist(attachments)),
                        ]),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 7),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("الأوراق الاضافية المطلوبة"),
                          SizedBox(
                            height: 5,
                          ),
                          BlocBuilder<AttachmentTypeBloc, AttachmentTypeState>(
                            builder: (context, state) {
                              if (state is AttachmentTypeLoadedSuccess) {
                                return Wrap(
                                    children: _buildAttachmentsTypelist(
                                        state.attachmentTypes));
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                          ),
                        ]),
                  ),
                ),
                const SizedBox(
                  height: 75,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CustomButton(
                      onTap: () {},
                      color: AppColor.deepYellow,
                      title: const SizedBox(
                          width: 100, child: Center(child: Text("إلغاء"))),
                    ),
                    BlocConsumer<OfferBloc, OfferState>(
                      listener: (context, state) {
                        // TODO: implement listener
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ControlView(),
                            ));
                      },
                      builder: (context, state) {
                        if (state is OfferListLoadingProgress) {
                          return CustomButton(
                            onTap: () {},
                            color: AppColor.deepYellow,
                            title: const SizedBox(
                                width: 100,
                                child:
                                    Center(child: CircularProgressIndicator())),
                          );
                        } else {
                          return CustomButton(
                            onTap: () {
                              BlocProvider.of<OfferBloc>(context).add(
                                  AddAdditionalAttachmentEvent(
                                      selectedAttachmentsId, widget.offer.id!));
                            },
                            color: AppColor.deepYellow,
                            title: const SizedBox(
                                width: 100,
                                child: Center(child: Text("طلب مخلص"))),
                          );
                        }
                      },
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
