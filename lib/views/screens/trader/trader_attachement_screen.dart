import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
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

class TraderAttachementScreen extends StatefulWidget {
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
  TraderAttachementScreen(
      {Key? key,
      required this.customAgency,
      required this.customeState,
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
        padding: const EdgeInsets.all(7),
        height: 100.h,
        width: 100.w,
        child: CachedNetworkImage(imageUrl: element.image!),
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
                const Text("الطلب رقم: 3475"),
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 7),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("تاريخ وصول البضاعة"),
                          TextField(
                            controller: _expireDate,
                            decoration: InputDecoration(
                                icon: GestureDetector(
                                    onTap: _showDatePicker,
                                    child: const Icon(Icons.date_range)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5))),
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          const Text("المرفقات"),
                          const Text("يرجى تحميل المرفقات المتاحة حاليا"),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomButton(
                                color: AppColor.deepYellow,
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => StatefulBuilder(
                                        builder:
                                            (context, StateSetter setState) {
                                      return SimpleDialog(
                                        title: const Text('إضافة مرفق'),
                                        children: [
                                          _previewImages(),
                                          CustomButton(
                                            title: const Text("رفع صورة"),
                                            color: AppColor.deepYellow,
                                            onTap: () async {
                                              var pickedImage =
                                                  await _picker.pickImage(
                                                      source:
                                                          ImageSource.gallery);
                                              setState(() {
                                                _image =
                                                    File(pickedImage!.path);
                                              });
                                            },
                                          ),
                                          CustomButton(
                                              title: const Text("رفع ملف"),
                                              color: AppColor.deepYellow,
                                              onTap: () {}),
                                          BlocBuilder<AttachmentTypeBloc,
                                              AttachmentTypeState>(
                                            builder: (context, state2) {
                                              if (state2
                                                  is AttachmentTypeLoadedSuccess) {
                                                return DropdownButtonHideUnderline(
                                                  child: DropdownButton2<
                                                      AttachmentType>(
                                                    isExpanded: true,
                                                    hint: Text(
                                                      "اختر نوع المرفق",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Theme.of(context)
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
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                            ))
                                                        .toList(),
                                                    value:
                                                        selectedAttachmentType,
                                                    onChanged: (AttachmentType?
                                                        value) {
                                                      setState(() {
                                                        selectedAttachmentType =
                                                            value;
                                                      });
                                                    },
                                                    buttonStyleData:
                                                        const ButtonStyleData(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 16),
                                                      height: 40,
                                                      width: 140,
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
                                            height: 10,
                                          ),
                                          BlocBuilder<AttachmentBloc,
                                              AttachmentState>(
                                            builder: (context, state) {
                                              if (state
                                                  is AttachmentLoadingProgress) {
                                                return const CircularProgressIndicator();
                                              } else {
                                                return Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    CustomButton(
                                                        title:
                                                            const Text("إغلاق"),
                                                        color:
                                                            AppColor.deepYellow,
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                        }),
                                                    CustomButton(
                                                        title:
                                                            const Text("حفظ"),
                                                        color:
                                                            AppColor.deepYellow,
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
                        ]),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 7),
                  child: BlocBuilder<AttachmentBloc, AttachmentState>(
                    builder: (context, state) {
                      if (state is AttachmentLoadedSuccess) {
                        return Wrap(
                            children: _buildAttachmentslist(state.attachments));
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
                const Text("اترك ملاحظاتك للمخلص"),
                TextField(
                  controller: _traderNotes,
                  maxLines: 4,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
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
                      listener: (context, state) {
                        // TODO: implement listener
                      },
                      builder: (context, state) {
                        if (state is OfferLoadingProgress) {
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
                                  AddOfferEvent(
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
    );
  }
}
