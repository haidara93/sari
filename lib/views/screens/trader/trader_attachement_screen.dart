import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:custome_mobile/business_logic/bloc/attachment_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/attachment_type_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/attachments_list_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/offer_bloc.dart';
import 'package:custome_mobile/business_logic/cubit/bottom_nav_bar_cubit.dart';
import 'package:custome_mobile/data/models/attachments_models.dart';
import 'package:custome_mobile/helpers/color_constants.dart';
import 'package:custome_mobile/views/control_view.dart';
import 'package:custome_mobile/views/widgets/custom_app_bar.dart';
import 'package:custome_mobile/views/widgets/custom_botton.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart' as cupertino;
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
    cupertino.showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border(top: BorderSide(color: AppColor.deepBlue, width: 2))),
        height: 450.h,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            cupertino.SizedBox(
              height: 350.h,
              child: cupertino.CupertinoDatePicker(
                backgroundColor: Colors.white10,
                initialDateTime: DateTime.now(),
                mode: cupertino.CupertinoDatePickerMode.date,
                // minimumYear: 2023,
                minimumDate: DateTime.now().subtract(const Duration(days: 1)),
                maximumYear: 2030,
                onDateTimeChanged: (value) {
                  setState(() {
                    productExpireDate = value;
                    _expireDate.text =
                        "${value.year}-${value.month}-${value.day}";
                  });
                },
              ),
            ),
            // InkWell(
            //   onTap: () => Navigator.pop(context),
            //   child: Container(
            //     height: 44,
            //     width: 150.w,
            //     decoration: BoxDecoration(
            //       color: Colors.white,
            //       // color: isEnabled ? color : Colors.white,
            //       borderRadius: BorderRadius.circular(100),
            //       border: Border(
            //         top: BorderSide(width: 1, color: AppColor.activeGreen),
            //         right: BorderSide(width: 1, color: AppColor.activeGreen),
            //         left: BorderSide(width: 1, color: AppColor.activeGreen),
            //         bottom: BorderSide(width: 1, color: AppColor.activeGreen),
            //       ),
            //     ),
            //     child: Center(
            //       child: Text("تم"),
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
    // showDatePicker(
    //   context: context,
    //   initialDate: DateTime.now(),
    //   firstDate: DateTime(2023),
    //   lastDate: DateTime(2025),
    //   // locale: Locale('ar', 'SY'),

    // ).then((value) {
    //   setState(() {
    //     productExpireDate = value!;
    //     _expireDate.text = "${value.year}-${value.month}-${value.day}";
    //   });
    // });
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
    var firstelem = GestureDetector(
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
                contentPadding: EdgeInsets.all(8.h),
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
                          await _picker.pickImage(source: ImageSource.gallery);
                      setState(() {
                        _image = File(pickedImage!.path);
                      });
                    },
                  ),
                  // const SizedBox(
                  //   height: 7,
                  // ),
                  // CustomButton(
                  //     title: const Text("رفع ملف"),
                  //     color: AppColor.deepYellow,
                  //     onTap: () {}),
                  const SizedBox(
                    height: 15,
                  ),
                  BlocBuilder<AttachmentTypeBloc, AttachmentTypeState>(
                    builder: (context, state2) {
                      if (state2 is AttachmentTypeLoadedSuccess) {
                        attachmentTypes = state2.attachmentTypes;
                        return DropdownButtonHideUnderline(
                          child: DropdownButton2<AttachmentType>(
                            isExpanded: true,
                            hint: Text(
                              "اختر نوع المرفق",
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                            items: state2.attachmentTypes
                                .map((AttachmentType item) =>
                                    DropdownMenuItem<AttachmentType>(
                                      value: item,
                                      child: Text(
                                        item.name!,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ))
                                .toList(),
                            value: selectedAttachmentType,
                            onChanged: (AttachmentType? value) {
                              setState(() {
                                selectedAttachmentType = value;
                              });
                            },
                            buttonStyleData: ButtonStyleData(
                              height: 50,
                              width: double.infinity,
                              padding:
                                  const EdgeInsets.only(left: 14, right: 14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.black26,
                                ),
                                color: Colors.white,
                              ),
                              elevation: 2,
                            ),
                            iconStyleData: const IconStyleData(
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                              ),
                              iconSize: 20,
                              iconEnabledColor: AppColor.AccentGreen,
                              iconDisabledColor: Colors.grey,
                            ),
                            dropdownStyleData: DropdownStyleData(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: Colors.white,
                              ),
                              scrollbarTheme: ScrollbarThemeData(
                                radius: const Radius.circular(40),
                                thickness: MaterialStateProperty.all(6),
                                thumbVisibility:
                                    MaterialStateProperty.all(true),
                              ),
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              height: 40,
                            ),
                          ),
                        );
                      } else if (state2 is AttachmentTypeLoadingProgress) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  BlocBuilder<AttachmentBloc, AttachmentState>(
                    builder: (context, state) {
                      if (state is AttachmentLoadingProgress) {
                        return const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(child: CircularProgressIndicator()),
                          ],
                        );
                      } else {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                  BlocProvider.of<AttachmentBloc>(context).add(
                                      AddAttachmentEvent(
                                          selectedAttachmentType!.id!,
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
      child: Container(
        margin: EdgeInsets.all(5.h),
        padding: EdgeInsets.all(5.h),
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
        height: 140.h,
        width: 120.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 5.h,
            ),
            Text(
              "إضافة مرفق",
              style: TextStyle(
                fontSize: 18.sp,
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            Icon(
              Icons.add,
              size: 50.h,
              weight: 5,
            )
            // GestureDetector(
            //   onTap: () {},
            //   child: const Text("تعديل"),
            // )
          ],
        ),
      ),
    );
    list.add(firstelem);
    for (var element in attachments) {
      var elem = Container(
        margin: EdgeInsets.all(5.h),
        padding: EdgeInsets.all(5.h),
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
        height: 140.h,
        width: 120.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 5.h,
            ),
            Text(attachmentName(element.attachmentType!)),
            SizedBox(
              height: 5.h,
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
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: "طلب مخلص"),
        backgroundColor: Colors.grey[200],
        body: SingleChildScrollView(
          child: BlocListener<AttachmentBloc, AttachmentState>(
            listener: (context, state) {
              if (state is AttachmentLoadedSuccess) {
                Navigator.pop(context);
                setState(() {
                  attachmentsId.add(state.attachment.id!);
                  attachments.add(state.attachment);
                  _image = null;
                });
                BlocProvider.of<AttachmentsListBloc>(context)
                    .add(AddAttachmentToListEvent(state.attachment));
              }
              if (state is AttachmentLoadedFailed) {
                Navigator.pop(context);

                var snackBar = SnackBar(
                  elevation: 0,
                  duration: const Duration(seconds: 4),
                  backgroundColor: Colors.transparent,
                  content: Column(
                    children: [
                      AwesomeSnackbarContent(
                        title: 'خطأ',
                        message:
                            'حدث خطأ أثناء تحميل المرفق سنحاول حل المشكلة.',

                        /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                        contentType: ContentType.failure,
                      ),
                      SizedBox(
                        height: 90.h,
                      ),
                    ],
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            child: GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                BlocProvider.of<BottomNavBarCubit>(context).emitShow();
              },
              child: Column(
                children: [
                  SizedBox(
                    height: 86.h,
                    child: Stepper(
                      type: StepperType.horizontal,
                      steps: [
                        Step(
                            isActive: true,
                            title: GestureDetector(
                              onTap: () {
                                var nav = Navigator.of(context);
                                nav.pop();
                                nav.pop();
                              },
                              child: Text(
                                "معلومات الشحنة",
                                style: TextStyle(fontSize: 12.sp),
                              ),
                            ),
                            content: const SizedBox.shrink()),
                        Step(
                            isActive: true,
                            title: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "حساب الرسوم",
                                style: TextStyle(fontSize: 12.sp),
                              ),
                            ),
                            content: const SizedBox.shrink()),
                        Step(
                            isActive: true,
                            title: Text(
                              "المرفقات",
                              style: TextStyle(fontSize: 12.sp),
                            ),
                            content: const SizedBox.shrink()),
                      ],
                      currentStep: 1,
                      controlsBuilder: (context, details) {
                        return const SizedBox.shrink();
                      },
                      onStepContinue: () => () {},
                      onStepCancel: () => () {},
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Text(
                      //   "الطلب رقم: 3475",
                      //   style: TextStyle(color: AppColor.activeGreen),
                      // ),
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
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 7),
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("تاريخ وصول البضاعة"),
                                const SizedBox(
                                  height: 15,
                                ),
                                TextField(
                                  controller: _expireDate,
                                  // enabled: false,
                                  onTap: _showDatePicker,
                                  decoration: InputDecoration(
                                      suffixIcon: GestureDetector(
                                          onTap: _showDatePicker,
                                          child: const Icon(Icons.date_range)),
                                      contentPadding: EdgeInsets.zero,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12))),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                              ]),
                        ),
                      ),
                      SizedBox(
                        height: 14.h,
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
                          margin: EdgeInsets.symmetric(vertical: 7.h),
                          padding: EdgeInsets.all(5.h),
                          width: double.infinity,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("المرفقات"),
                                const Text("يرجى تحميل المرفقات المتاحة حاليا"),
                                SizedBox(
                                  height: 15.h,
                                ),
                                BlocBuilder<AttachmentsListBloc,
                                    AttachmentsListState>(
                                  builder: (context, attstate) {
                                    if (attstate is AttachmentsListSucess) {
                                      return Wrap(
                                          children: _buildAttachmentslist(
                                              attstate.attachments));
                                    } else {
                                      return Wrap(
                                          children: _buildAttachmentslist([]));
                                    }
                                  },
                                ),
                              ]),
                        ),
                      ),
                      SizedBox(
                        height: 14.h,
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
                          padding: const EdgeInsets.all(15.0),
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
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      hintText:
                                          "اكتب ملاحظة للمخلص الجمركي ان وجد"),
                                ),
                              ]),
                        ),
                      ),

                      SizedBox(
                        height: 30.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CustomButton(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            title: const SizedBox(
                                width: 100,
                                child: Center(child: Text("إلغاء"))),
                          ),
                          BlocConsumer<OfferBloc, OfferState>(
                            listener: (context, offerstate) {
                              if (offerstate is OfferLoadedSuccess) {
                                BlocProvider.of<AttachmentsListBloc>(context)
                                    .add(ClearAttachmentToListEvent());
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ControlView(),
                                  ),
                                  (route) => false,
                                );

                                var snackBar = SnackBar(
                                  elevation: 0,
                                  duration: const Duration(seconds: 4),
                                  backgroundColor: Colors.transparent,
                                  content: Column(
                                    children: [
                                      AwesomeSnackbarContent(
                                        title: 'تم',
                                        message:
                                            'تم اضافة الطلب بنجاح سيتم ارساله للمخلص المختص.',

                                        /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                        contentType: ContentType.success,
                                      ),
                                      SizedBox(
                                        height: 90.h,
                                      ),
                                    ],
                                  ),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                              if (offerstate is OfferLoadedFailed) {
                                var snackBar = SnackBar(
                                  elevation: 0,
                                  duration: const Duration(seconds: 4),
                                  backgroundColor: Colors.transparent,
                                  content: Column(
                                    children: [
                                      AwesomeSnackbarContent(
                                        title: 'تنبيه',
                                        message:
                                            'حدث خطأ أثناء معالجة الطلب الرجاء المحاولة مرة أخرى.',

                                        /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                        contentType: ContentType.warning,
                                      ),
                                      SizedBox(
                                        height: 90.h,
                                      ),
                                    ],
                                  ),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            },
                            builder: (context, offerstate) {
                              if (offerstate is OfferLoadingProgress) {
                                return CustomButton(
                                  onTap: () {},
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
                                  title: const SizedBox(
                                      width: 100,
                                      child: Center(child: Text("طلب مخلص"))),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30.h,
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
