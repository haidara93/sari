import 'dart:io';

import 'package:custome_mobile/business_logic/bloc/attachment_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/attachment_type_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/offer_bloc.dart';
import 'package:custome_mobile/data/models/attachments_models.dart';
import 'package:custome_mobile/helpers/color_constants.dart';
import 'package:custome_mobile/views/widgets/custom_app_bar.dart';
import 'package:custome_mobile/views/widgets/custom_botton.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class TraderAttachementScreen extends StatefulWidget {
  final String? offerType;
  final int customAgency;
  final int customeState;
  final int? packagesNum;
  final int? tabalehNum;
  final int? weight;
  final int? price;
  final int? taxes;
  final String? product;
  final int? origin;
  final int? packageType;
  final int? rawMaterial;
  final int? industrial;

  var homeCarouselIndicator = 0;
  TraderAttachementScreen(
      {Key? key,
      required this.customAgency,
      required this.customeState,
      this.offerType,
      this.packagesNum,
      this.tabalehNum,
      this.weight,
      this.price,
      this.taxes,
      this.product,
      this.origin,
      this.packageType,
      this.rawMaterial,
      this.industrial})
      : super(key: key);

  @override
  State<TraderAttachementScreen> createState() =>
      _TraderAttachementScreenState();
}

class _TraderAttachementScreenState extends State<TraderAttachementScreen> {
  DateTime productExpireDate = DateTime.now();
  final TextEditingController _expireDate = TextEditingController();
  final TextEditingController _traderNotes = TextEditingController();
  File? _image;
  final ImagePicker _picker = ImagePicker();
  AttachmentType? selectedAttachmentType;
  List<Attachment> attachments = [];
  List<int> attachmentsId = [];
  List<AttachmentType> attachmentTypes = [];

  @override
  void initState() {
    super.initState();
  }

  _showDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime(2030))
        .then((value) {
      setState(() {
        productExpireDate = value!;
        _expireDate.text = "${value.year}-${value.month}-${value.day}";
      });
    });
  }

  imageButtonPressed(ImageSource source, {bool isMultiImage = false}) async {
    if (isMultiImage) {
      try {
        // final List<XFile>? pickedFileList = await _picker.pickMultiImage();
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

  String attachmentName(int attachmentType) {
    for (var element in attachmentTypes) {
      if (element.id! == attachmentType) {
        return element.name!;
      }
    }
    return "مرفق";
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
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Text(
                  //   "الطلب رقم: 3475",
                  //   style: TextStyle(color: AppColor.activeGreen),
                  // ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 7),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 229, 215, 94),
                            Colors.white,
                            Colors.white,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("تاريخ وصول البضاعة"),
                          const SizedBox(
                            height: 15,
                          ),
                          TextField(
                            controller: _expireDate,
                            decoration: InputDecoration(
                                suffixIcon: GestureDetector(
                                    onTap: _showDatePicker,
                                    child: const Icon(Icons.date_range)),
                                contentPadding: EdgeInsets.zero,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12))),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                        ]),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 7),
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 229, 215, 94),
                            Colors.white,
                            Colors.white,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("المرفقات"),
                          const Text("يرجى تحميل المرفقات المتاحة حاليا"),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomButton(
                                color: AppColor.activeGreen,
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => StatefulBuilder(
                                        builder:
                                            (context, StateSetter setState) {
                                      return Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: SimpleDialog(
                                          title: const Text('إضافة مرفق'),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          contentPadding:
                                              const EdgeInsets.all(8),
                                          children: [
                                            _previewImages(),
                                            const SizedBox(
                                              height: 7,
                                            ),
                                            CustomButton(
                                              title: const Text("رفع صورة"),
                                              color: AppColor.deepYellow,
                                              onTap: () async {
                                                var pickedImage =
                                                    await _picker.pickImage(
                                                        source: ImageSource
                                                            .gallery);
                                                setState(() {
                                                  _image =
                                                      File(pickedImage!.path);
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
                                            BlocBuilder<AttachmentTypeBloc,
                                                AttachmentTypeState>(
                                              builder: (context, state2) {
                                                if (state2
                                                    is AttachmentTypeLoadedSuccess) {
                                                  attachmentTypes =
                                                      state2.attachmentTypes;
                                                  return DropdownButtonHideUnderline(
                                                    child: DropdownButton2<
                                                        AttachmentType>(
                                                      isExpanded: true,
                                                      hint: Text(
                                                        "اختر نوع المرفق",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color:
                                                              Theme.of(context)
                                                                  .hintColor,
                                                        ),
                                                      ),
                                                      items: state2
                                                          .attachmentTypes
                                                          .map((AttachmentType
                                                                  item) =>
                                                              DropdownMenuItem<
                                                                  AttachmentType>(
                                                                value: item,
                                                                child: Text(
                                                                  item.name!,
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                                ),
                                                              ))
                                                          .toList(),
                                                      value:
                                                          selectedAttachmentType,
                                                      onChanged:
                                                          (AttachmentType?
                                                              value) {
                                                        setState(() {
                                                          selectedAttachmentType =
                                                              value;
                                                        });
                                                      },
                                                      buttonStyleData:
                                                          ButtonStyleData(
                                                        height: 50,
                                                        width: double.infinity,
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 14,
                                                                right: 14),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          border: Border.all(
                                                            color:
                                                                Colors.black26,
                                                          ),
                                                          color: Colors.white,
                                                        ),
                                                        elevation: 2,
                                                      ),
                                                      iconStyleData:
                                                          const IconStyleData(
                                                        icon: Icon(
                                                          Icons
                                                              .arrow_forward_ios_outlined,
                                                        ),
                                                        iconSize: 14,
                                                        iconEnabledColor:
                                                            AppColor
                                                                .AccentGreen,
                                                        iconDisabledColor:
                                                            Colors.grey,
                                                      ),
                                                      dropdownStyleData:
                                                          DropdownStyleData(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(14),
                                                          color: Colors.white,
                                                        ),
                                                        scrollbarTheme:
                                                            ScrollbarThemeData(
                                                          radius: const Radius
                                                              .circular(40),
                                                          thickness:
                                                              MaterialStateProperty
                                                                  .all(6),
                                                          thumbVisibility:
                                                              MaterialStateProperty
                                                                  .all(true),
                                                        ),
                                                      ),
                                                      menuItemStyleData:
                                                          const MenuItemStyleData(
                                                        height: 40,
                                                      ),
                                                    ),
                                                  );
                                                } else if (state2
                                                    is AttachmentTypeLoadingProgress) {
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                } else {
                                                  return Container();
                                                }
                                              },
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            BlocBuilder<AttachmentBloc,
                                                AttachmentState>(
                                              builder: (context, state) {
                                                if (state
                                                    is AttachmentLoadingProgress) {
                                                  return Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: const [
                                                      Center(
                                                          child:
                                                              CircularProgressIndicator()),
                                                    ],
                                                  );
                                                } else {
                                                  return Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      CustomButton(
                                                          title: const SizedBox(
                                                            width: 90,
                                                            child: Center(
                                                                child: Text(
                                                                    "إغلاق")),
                                                          ),
                                                          color: AppColor
                                                              .deepYellow,
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                          }),
                                                      CustomButton(
                                                          title: const SizedBox(
                                                              width: 90,
                                                              child: Center(
                                                                  child: Text(
                                                                      "حفظ"))),
                                                          color: AppColor
                                                              .deepYellow,
                                                          onTap: () {
                                                            BlocProvider.of<
                                                                        AttachmentBloc>(
                                                                    context)
                                                                .add(AddAttachmentEvent(
                                                                    selectedAttachmentType!
                                                                        .id!,
                                                                    _image!));
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
                                title: const SizedBox(
                                  width: 120,
                                  child: Center(
                                    child: Text("تحميل jpg,pdf"),
                                  ),
                                ),
                              )
                            ],
                          ),
                          BlocBuilder<AttachmentBloc, AttachmentState>(
                            builder: (context, state) {
                              if (state is AttachmentLoadedSuccess) {
                                return Wrap(
                                    children: _buildAttachmentslist(
                                        state.attachments));
                              } else {
                                return Container();
                              }
                            },
                          ),
                        ]),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 7),
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 229, 215, 94),
                            Colors.white,
                            Colors.white,
                            Colors.white,
                            Colors.white,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("اترك ملاحظاتك للمخلص",
                              style: TextStyle(fontSize: 16)),
                          SizedBox(
                            height: 15.h,
                          ),
                          TextField(
                            controller: _traderNotes,
                            maxLines: 4,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                hintText: "اكتب ملاحظة للمخلص الجمركي ان وجد"),
                          ),
                        ]),
                  ),

                  SizedBox(
                    height: 30.h,
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
                        listener: (context, state) {},
                        builder: (context, state) {
                          if (state is OfferLoadingProgress) {
                            return CustomButton(
                              onTap: () {},
                              color: AppColor.deepYellow,
                              title: const SizedBox(
                                  width: 100,
                                  child: Center(
                                      child: CircularProgressIndicator())),
                            );
                          } else {
                            return CustomButton(
                              onTap: () {
                                BlocProvider.of<OfferBloc>(context).add(
                                    AddOfferEvent(
                                        widget.offerType!,
                                        widget.packagesNum!,
                                        widget.tabalehNum!,
                                        widget.weight!,
                                        widget.price!,
                                        widget.taxes!,
                                        1,
                                        1,
                                        widget.customAgency,
                                        widget.customeState,
                                        widget.origin!,
                                        widget.packageType!,
                                        _expireDate.text,
                                        _traderNotes.text,
                                        widget.product!,
                                        attachmentsId,
                                        widget.rawMaterial!,
                                        widget.industrial!));
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
      ),
    );
  }
}
