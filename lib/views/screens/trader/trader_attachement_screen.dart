import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:custome_mobile/Localization/app_localizations.dart';
import 'package:custome_mobile/business_logic/bloc/attachment/attachment_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/attachment/attachment_type_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/attachment/attachments_list_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/offer_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/package_type_bloc.dart';
import 'package:custome_mobile/business_logic/cubit/bottom_nav_bar_cubit.dart';
import 'package:custome_mobile/data/models/attachments_models.dart';
import 'package:custome_mobile/data/providers/add_attachment_provider.dart';
import 'package:custome_mobile/data/providers/order_broker_provider.dart';
import 'package:custome_mobile/helpers/color_constants.dart';
import 'package:custome_mobile/helpers/formatter.dart';
import 'package:custome_mobile/views/control_view.dart';
import 'package:custome_mobile/views/widgets/custom_app_bar.dart';
import 'package:custome_mobile/views/widgets/custom_botton.dart';
import 'package:flutter/cupertino.dart' as cupertino;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

// ignore: must_be_immutable
class TraderAttachementScreen extends StatefulWidget {
  final int? weight;
  final int? price;
  final int? taxes;
  final String? product;
  final int? origin;
  final int? rawMaterial;
  final int? industrial;

  var homeCarouselIndicator = 0;
  TraderAttachementScreen(
      {Key? key,
      this.weight,
      this.price,
      this.taxes,
      this.product,
      this.origin,
      this.rawMaterial,
      this.industrial})
      : super(key: key);

  @override
  State<TraderAttachementScreen> createState() =>
      _TraderAttachementScreenState();
}

class _TraderAttachementScreenState extends State<TraderAttachementScreen> {
  final TextEditingController _traderNotes = TextEditingController();
  final TextEditingController _tabalehNumController = TextEditingController();
  final TextEditingController _packagesNumController = TextEditingController();
  final TextEditingController _otherAttachmentController =
      TextEditingController();

  var key1 = GlobalKey();
  var key2 = GlobalKey();

  final ScrollController _scrollController = ScrollController();
  final ScrollController _attachmentsScrollController = ScrollController();

  File? _image;
  List<File>? _images = [];
  List<File>? _files = [];
  final ImagePicker _picker = ImagePicker();
  AttachmentType? selectedAttachmentType;
  List<AttachmentType> attachmentTypes = [];
  final GlobalKey<FormState> _attachmentformkey = GlobalKey<FormState>();
  final FocusNode _nodePackages = FocusNode();
  final FocusNode _nodeTabaleh = FocusNode();
  OrderBrokerProvider? order_brokerProvider;
  AddAttachmentProvider? attachment_Provider;
  @override
  void initState() {
    super.initState();
    _tabalehNumController.text = "1";
    _packagesNumController.text = "0";
    _otherAttachmentController.text = "";
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      order_brokerProvider =
          Provider.of<OrderBrokerProvider>(context, listen: false);
      attachment_Provider =
          Provider.of<AddAttachmentProvider>(context, listen: false);
      setState(() {
        _tabalehNumController.text =
            order_brokerProvider!.tabalehNum.toString();
        _packagesNumController.text =
            order_brokerProvider!.packageNum.toString();
        _traderNotes.text = order_brokerProvider!.note;
      });
    });
  }

  _showDatePicker() {
    cupertino.showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border(top: BorderSide(color: AppColor.deepBlue, width: 2))),
        height: MediaQuery.of(context).size.height * .4,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "تم",
                style: TextStyle(
                  color: AppColor.lightBlue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Localizations(
                locale: const Locale('en', ''),
                delegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                child: cupertino.CupertinoDatePicker(
                  backgroundColor: Colors.white10,
                  initialDateTime: DateTime.now(),
                  mode: cupertino.CupertinoDatePickerMode.date,
                  minimumYear: 2023,
                  minimumDate: DateTime.now().subtract(const Duration(days: 1)),
                  maximumYear: 2030,
                  onDateTimeChanged: (value) {
                    order_brokerProvider!.setProductDate(value);
                    order_brokerProvider!.setDateError(false);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String attachmentName(int attachmentType) {
    for (var element in attachmentTypes) {
      if (element.id! == attachmentType) {
        return element.name!;
      }
    }
    return "attachment";
  }

  List<Widget> _buildAttachmentImages(List<AttachmentImage>? images) {
    List<Widget> list = [];
    var restofImagesNum = 0;
    if (images != null) {
      for (var i = 0; i < images!.length; i++) {
        if (i < 3) {
          var elem = Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1,
              ),
            ),
            width: 58.w,
            height: 68.h,
            child: Image.network(
                width: 58.w, height: 68.h, fit: BoxFit.fill, images![i].image!),
          );
          list.add(elem);
        } else {
          restofImagesNum = images!.length - 3;
          var elem = Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                width: 58.w,
                height: 68.h,
                child: Image.network(
                    width: 58.w,
                    height: 68.h,
                    fit: BoxFit.fill,
                    images![i].image!),
              ),
              Container(
                color: Colors.white70,
                width: 58.w,
                height: 68.h,
                child: Center(
                  child: Text(
                    "+$restofImagesNum",
                    style: TextStyle(color: AppColor.deepBlue, fontSize: 18.sp),
                  ),
                ),
              ),
            ],
          );
          list.add(elem);
          break;
        }
      }
    }
    return list;
  }

  bool lastStep = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
            title:
                AppLocalizations.of(context)!.translate('broker_order_title')),
        backgroundColor: Colors.grey[200],
        body: SingleChildScrollView(
          child: BlocListener<AttachmentBloc, AttachmentState>(
            listener: (context, state) {
              if (state is AttachmentLoadedSuccess) {
                Navigator.pop(context);
                // order_brokerProvider!.addAttachment(state.attachment);
                // order_brokerProvider!.addAttachmentId(state.attachment.id!);

                // BlocProvider.of<AttachmentsListBloc>(context)
                //     .add(AddAttachmentToListEvent(state.attachment));
              }
              if (state is AttachmentLoadedFailed) {
                print(state.errortext);
                Navigator.pop(context);
                var snackBar = SnackBar(
                  elevation: 0,
                  duration: const Duration(seconds: 4),
                  backgroundColor: Colors.transparent,
                  content: Column(
                    children: [
                      AwesomeSnackbarContent(
                        title: AppLocalizations.of(context)!.translate('error'),
                        message: AppLocalizations.of(context)!
                            .translate('attachment_error'),

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
              child: Consumer<OrderBrokerProvider>(
                  builder: (context, orderBrokerProvider, child) {
                return Column(
                  children: [
                    Form(
                      key: _attachmentformkey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 15.h,
                          ),
                          Card(
                            key: key1,
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
                                    Text(
                                      AppLocalizations.of(context)!
                                          .translate('expected_arrival_date'),
                                      style: const TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Localizations(
                                      locale: const Locale('en', 'US'),
                                      delegates: const [
                                        GlobalMaterialLocalizations.delegate,
                                        GlobalWidgetsLocalizations.delegate,
                                        GlobalCupertinoLocalizations.delegate,
                                      ],
                                      child: GestureDetector(
                                        onTap: _showDatePicker,
                                        child: Container(
                                          height: 50.h,
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.w),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                              color: Colors.grey[400]!,
                                              width: 1,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              GestureDetector(
                                                onTap: _showDatePicker,
                                                child: Icon(
                                                  Icons.date_range,
                                                  color: orderBrokerProvider
                                                              .productExpireDate ==
                                                          null
                                                      ? Colors.grey
                                                      : AppColor.deepYellow,
                                                ),
                                              ),
                                              orderBrokerProvider
                                                          .productExpireDate ==
                                                      null
                                                  ? const Text(
                                                      "",
                                                    )
                                                  : Text(
                                                      "${orderBrokerProvider.productExpireDate!.year}-${orderBrokerProvider.productExpireDate!.month}-${orderBrokerProvider.productExpireDate!.day}",
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: orderBrokerProvider.dateError,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 4.h,
                                          ),
                                          Text(
                                            AppLocalizations.of(context)!
                                                .translate(
                                                    'select_arrival_date_error'),
                                            style: const TextStyle(
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
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
                            key: key2,
                            margin: const EdgeInsets.symmetric(vertical: 7),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!
                                        .translate('package_type'),
                                    style: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.deepBlue,
                                    ),
                                  ),
                                  SizedBox(
                                      height: 140.h,
                                      child: BlocBuilder<PackageTypeBloc,
                                          PackageTypeState>(
                                        builder: (context, state) {
                                          if (state
                                              is PackageTypeLoadedSuccess) {
                                            return Scrollbar(
                                              controller: _scrollController,
                                              thumbVisibility: true,
                                              thickness: 2.0,
                                              child: Padding(
                                                padding: EdgeInsets.all(2.h),
                                                child: ListView.builder(
                                                  controller: _scrollController,
                                                  itemCount:
                                                      state.packageTypes.length,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  shrinkWrap: true,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 5.w,
                                                              vertical: 15.h),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          // setSelectedPanel(3);
                                                          orderBrokerProvider
                                                              .setPackageError(
                                                                  false);
                                                          orderBrokerProvider
                                                              .setpackageTypeId(
                                                                  state
                                                                      .packageTypes[
                                                                          index]
                                                                      .id!);
                                                        },
                                                        child: Stack(
                                                          clipBehavior:
                                                              Clip.none,
                                                          children: [
                                                            Container(
                                                              width: 145.w,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            7),
                                                                border:
                                                                    Border.all(
                                                                  color: orderBrokerProvider
                                                                              .packageTypeId ==
                                                                          state
                                                                              .packageTypes[
                                                                                  index]
                                                                              .id!
                                                                      ? AppColor
                                                                          .goldenYellow
                                                                      : AppColor
                                                                          .deepBlue,
                                                                  width: 2.w,
                                                                ),
                                                              ),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  SvgPicture
                                                                      .network(
                                                                    state
                                                                        .packageTypes[
                                                                            index]
                                                                        .image!,
                                                                    height:
                                                                        50.h,
                                                                    // placeholder:
                                                                    //     Container(
                                                                    //   color: Colors
                                                                    //       .white,
                                                                    //   height:
                                                                    //       50.h,
                                                                    //   width: 50.h,
                                                                    // ),
                                                                  ),
                                                                  Text(
                                                                    state
                                                                        .packageTypes[
                                                                            index]
                                                                        .name!,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          17.sp,
                                                                      color: AppColor
                                                                          .deepBlue,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            orderBrokerProvider
                                                                        .packageTypeId ==
                                                                    state
                                                                        .packageTypes[
                                                                            index]
                                                                        .id!
                                                                ? Positioned(
                                                                    right: -7.w,
                                                                    top: -10.h,
                                                                    child:
                                                                        Container(
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .all(
                                                                              2),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: AppColor
                                                                            .goldenYellow,
                                                                        borderRadius:
                                                                            BorderRadius.circular(45),
                                                                      ),
                                                                      child: Icon(
                                                                          Icons
                                                                              .check,
                                                                          size: 16
                                                                              .w,
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  )
                                                                : const SizedBox
                                                                    .shrink()
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            );
                                          } else {
                                            return Shimmer.fromColors(
                                              baseColor: (Colors.grey[300])!,
                                              highlightColor:
                                                  (Colors.grey[100])!,
                                              enabled: true,
                                              direction: ShimmerDirection.rtl,
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder: (_, __) => Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 5.w,
                                                      vertical: 15.h),
                                                  child: Container(
                                                    clipBehavior:
                                                        Clip.antiAlias,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: SizedBox(
                                                      width: 145.w,
                                                      height: 70.h,
                                                    ),
                                                  ),
                                                ),
                                                itemCount: 6,
                                              ),
                                            );
                                          }
                                        },
                                      )),
                                  Visibility(
                                    visible: orderBrokerProvider.packageError,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 4.h,
                                        ),
                                        Text(
                                          AppLocalizations.of(context)!
                                              .translate(
                                                  'select_package_type_error'),
                                          style: TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 7.h,
                                  ),
                                  const Divider(),
                                  SizedBox(
                                    height: 7.h,
                                  ),
                                  TextFormField(
                                    controller: _packagesNumController,
                                    textAlign: TextAlign.center,
                                    focusNode: _nodePackages,
                                    textInputAction: TextInputAction.done,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true, signed: true),
                                    inputFormatters: [
                                      DecimalFormatter(),
                                    ],
                                    style: const TextStyle(fontSize: 18),
                                    decoration: InputDecoration(
                                      labelText: AppLocalizations.of(context)!
                                          .translate('packages_number'),
                                    ),
                                    scrollPadding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom +
                                            1),
                                    onTap: () {
                                      // setSelectedPanel(2);
                                      BlocProvider.of<BottomNavBarCubit>(
                                              context)
                                          .emitHide();
                                      _packagesNumController.selection =
                                          TextSelection(
                                              baseOffset: 0,
                                              extentOffset:
                                                  _packagesNumController
                                                      .value.text.length);
                                    },
                                    onChanged: (value) {
                                      if (value.isEmpty) {
                                        setState(() {
                                          _packagesNumController.text = "";
                                        });
                                        orderBrokerProvider.setpackageNum(0);
                                      } else {
                                        orderBrokerProvider.setpackageNum(
                                            int.parse(double.parse(
                                                    _packagesNumController.text)
                                                .toInt()
                                                .toString()));
                                      }
                                    },
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value!.isEmpty || value == "0") {
                                        return AppLocalizations.of(context)!
                                            .translate('insert_value_validate');
                                      }
                                      return null;
                                    },
                                    onSaved: (newValue) {
                                      _packagesNumController.text = newValue!;
                                    },
                                    onFieldSubmitted: (value) {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      BlocProvider.of<BottomNavBarCubit>(
                                              context)
                                          .emitShow();
                                    },
                                  ),
                                  SizedBox(
                                    height: 7.h,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 18.w),
                                    child: CheckboxListTile(
                                        value: orderBrokerProvider.haveTabaleh,
                                        title: Text(
                                          AppLocalizations.of(context)!
                                              .translate('with_tabaleh'),
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                        activeColor: AppColor.goldenYellow,
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                        contentPadding: EdgeInsets.zero,
                                        onChanged: (value) {
                                          // setSelectedPanel(3);
                                          orderBrokerProvider
                                              .setHaveTabaleh(value!);
                                          setState(() {
                                            if (!value) {
                                              _tabalehNumController.text = "0";
                                              orderBrokerProvider
                                                  .settabalehNum(0);
                                            }
                                          });
                                        }),
                                  ),
                                  Visibility(
                                    visible: orderBrokerProvider.haveTabaleh,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              // setSelectedPanel(3);
                                              orderBrokerProvider
                                                  .increasetabalehNum();
                                              setState(() {
                                                _tabalehNumController.text =
                                                    orderBrokerProvider
                                                        .tabalehNum
                                                        .toString();
                                              });
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(3),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.grey[600]!,
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(45),
                                              ),
                                              child: Icon(Icons.add,
                                                  size: 40.w,
                                                  color: Colors.blue[200]!),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 200.w,
                                            height: 55.h,
                                            child: TextField(
                                              controller: _tabalehNumController,
                                              focusNode: _nodeTabaleh,
                                              textAlign: TextAlign.center,
                                              style:
                                                  const TextStyle(fontSize: 18),
                                              textInputAction:
                                                  TextInputAction.done,
                                              keyboardType: const TextInputType
                                                  .numberWithOptions(
                                                  decimal: true, signed: true),
                                              inputFormatters: [
                                                DecimalFormatter(),
                                              ],
                                              decoration: InputDecoration(
                                                labelText: AppLocalizations.of(
                                                        context)!
                                                    .translate('quantity'),
                                                alignLabelWithHint: true,
                                              ),
                                              scrollPadding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                          .viewInsets
                                                          .bottom +
                                                      50),
                                              onTap: () {
                                                // setSelectedPanel(2);
                                                BlocProvider.of<
                                                            BottomNavBarCubit>(
                                                        context)
                                                    .emitHide();
                                                _tabalehNumController
                                                        .selection =
                                                    TextSelection(
                                                        baseOffset: 0,
                                                        extentOffset:
                                                            _tabalehNumController
                                                                .value
                                                                .text
                                                                .length);
                                              },
                                              onChanged: (value) {
                                                if (value.isEmpty) {
                                                  orderBrokerProvider
                                                      .settabalehNum(0);
                                                } else {
                                                  orderBrokerProvider.settabalehNum(
                                                      int.parse(double.parse(
                                                              _tabalehNumController
                                                                  .text)
                                                          .toInt()
                                                          .toString()));
                                                }
                                              },
                                              onSubmitted: (value) {
                                                FocusManager
                                                    .instance.primaryFocus
                                                    ?.unfocus();
                                                BlocProvider.of<
                                                            BottomNavBarCubit>(
                                                        context)
                                                    .emitShow();
                                              },
                                            ),
                                          ),
                                          // Text(
                                          //   tabalehNum.toString(),
                                          //   style: const TextStyle(fontSize: 30),
                                          // ),
                                          GestureDetector(
                                              onTap: () {
                                                // setSelectedPanel(3);
                                                orderBrokerProvider
                                                    .decreasetabalehNum();
                                                setState(() {
                                                  _tabalehNumController.text =
                                                      orderBrokerProvider
                                                          .tabalehNum
                                                          .toString();
                                                });
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(3),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.grey[600]!,
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(45),
                                                ),
                                                child: orderBrokerProvider
                                                            .tabalehNum >
                                                        1
                                                    ? Icon(Icons.remove,
                                                        size: 40.w,
                                                        color:
                                                            Colors.blue[200]!)
                                                    : Icon(Icons.remove,
                                                        size: 40.w,
                                                        color:
                                                            Colors.grey[600]!),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Divider(),
                                  SizedBox(
                                    height: 7.h,
                                  ),
                                ],
                              ),
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
                                    Text(
                                      AppLocalizations.of(context)!
                                          .translate('attachments'),
                                      style: const TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!.translate(
                                          'please_upload_attachments'),
                                      style: const TextStyle(
                                        fontSize: 17,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15.h,
                                    ),
                                    // Wrap(
                                    //   children: _buildAttachmentslist(
                                    //       orderBrokerProvider.attachments),
                                    // ),
                                    SizedBox(
                                      height: 185.h,
                                      child: BlocBuilder<AttachmentTypeBloc,
                                          AttachmentTypeState>(
                                        builder:
                                            (context, attachmentTypeState) {
                                          if (attachmentTypeState
                                              is AttachmentTypeLoadedSuccess) {
                                            return ListView.builder(
                                              itemCount: attachmentTypeState
                                                  .attachmentTypes.length,
                                              scrollDirection: Axis.horizontal,
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                return InkWell(
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          StatefulBuilder(
                                                              builder: (context,
                                                                  StateSetter
                                                                      setState2) {
                                                        return Directionality(
                                                          textDirection:
                                                              TextDirection.rtl,
                                                          child: SimpleDialog(
                                                            backgroundColor:
                                                                Colors.white,
                                                            title: const Text(
                                                                'إضافة مرفق'),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15),
                                                            ),
                                                            contentPadding:
                                                                EdgeInsets.all(
                                                                    8.h),
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            5.w,
                                                                        vertical:
                                                                            15.h),
                                                                    child:
                                                                        InkWell(
                                                                      child:
                                                                          Stack(
                                                                        clipBehavior:
                                                                            Clip.none,
                                                                        children: [
                                                                          Card(
                                                                            elevation:
                                                                                1,
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Center(
                                                                                child: SizedBox(
                                                                                  height: 55.h,
                                                                                  width: 50.w,
                                                                                  child: SvgPicture.asset("assets/icons/pdf_icon.svg"),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          _files!.isNotEmpty
                                                                              ? Positioned(
                                                                                  right: -7.w,
                                                                                  top: -10.h,
                                                                                  child: Container(
                                                                                    height: 25.h,
                                                                                    width: 25.h,
                                                                                    padding: const EdgeInsets.all(2),
                                                                                    decoration: BoxDecoration(
                                                                                      color: AppColor.goldenYellow,
                                                                                      borderRadius: BorderRadius.circular(45),
                                                                                    ),
                                                                                    child: Center(
                                                                                      child: Text(
                                                                                        _files!.length.toString(),
                                                                                        style: const TextStyle(
                                                                                          color: Colors.white,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              : const SizedBox.shrink()
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            5.w,
                                                                        vertical:
                                                                            15.h),
                                                                    child:
                                                                        InkWell(
                                                                      onTap:
                                                                          () async {
                                                                        var pickedImages =
                                                                            await _picker.pickMultiImage();
                                                                        for (var element
                                                                            in pickedImages) {
                                                                          _images!
                                                                              .add(File(element!.path));
                                                                        }
                                                                        setState2(
                                                                          () {},
                                                                        );
                                                                      },
                                                                      child:
                                                                          Stack(
                                                                        clipBehavior:
                                                                            Clip.none,
                                                                        children: [
                                                                          Card(
                                                                            elevation:
                                                                                1,
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Center(
                                                                                child: cupertino.SizedBox(
                                                                                  height: 55.h,
                                                                                  width: 50.w,
                                                                                  child: SvgPicture.asset("assets/icons/photo_icon.svg"),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          _images!.isNotEmpty
                                                                              ? Positioned(
                                                                                  right: -7.w,
                                                                                  top: -10.h,
                                                                                  child: Container(
                                                                                    height: 25.h,
                                                                                    width: 25.h,
                                                                                    padding: const EdgeInsets.all(2),
                                                                                    decoration: BoxDecoration(
                                                                                      color: AppColor.goldenYellow,
                                                                                      borderRadius: BorderRadius.circular(45),
                                                                                    ),
                                                                                    child: Center(
                                                                                      child: Text(
                                                                                        _images!.length.toString(),
                                                                                        style: const TextStyle(
                                                                                          color: Colors.white,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              : const SizedBox.shrink()
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              // _previewImages(),
                                                              Visibility(
                                                                visible: attachmentTypeState
                                                                        .attachmentTypes[
                                                                            index]
                                                                        .number !=
                                                                    200,
                                                                child:
                                                                    const SizedBox(
                                                                  height: 15,
                                                                ),
                                                              ),
                                                              Visibility(
                                                                visible: attachmentTypeState
                                                                        .attachmentTypes[
                                                                            index]
                                                                        .number ==
                                                                    200,
                                                                child: Padding(
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical:
                                                                            7.h,
                                                                        horizontal: 15
                                                                            .w),
                                                                    child:
                                                                        TextField(
                                                                      controller:
                                                                          _otherAttachmentController,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        isDense:
                                                                            true,
                                                                        contentPadding:
                                                                            const EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              10,
                                                                          vertical:
                                                                              8,
                                                                        ),
                                                                        labelText:
                                                                            AppLocalizations.of(context)!.translate('enter_attachment_name'),
                                                                        border:
                                                                            OutlineInputBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(8),
                                                                        ),
                                                                      ),
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              18),
                                                                    )),
                                                              ),

                                                              BlocConsumer<
                                                                  AttachmentBloc,
                                                                  AttachmentState>(
                                                                listener:
                                                                    (context,
                                                                        state) {
                                                                  if (state
                                                                      is AttachmentLoadedSuccess) {
                                                                    orderBrokerProvider!
                                                                        .addAttachmentId(state
                                                                            .attachment
                                                                            .id!);
                                                                    orderBrokerProvider
                                                                        .addAttachment(
                                                                            state.attachment);
                                                                    setState2(
                                                                        () {
                                                                      _images =
                                                                          [];
                                                                      _files =
                                                                          [];
                                                                      _otherAttachmentController
                                                                          .text = "";
                                                                    });
                                                                  }
                                                                },
                                                                builder:
                                                                    (context,
                                                                        state) {
                                                                  if (state
                                                                      is AttachmentLoadingProgress) {
                                                                    return const Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
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
                                                                            title:
                                                                                SizedBox(
                                                                              width: 90,
                                                                              child: Center(child: Text(AppLocalizations.of(context)!.translate('close'))),
                                                                            ),
                                                                            onTap:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                            }),
                                                                        CustomButton(
                                                                            title:
                                                                                const SizedBox(width: 90, child: Center(child: Text("حفظ"))),
                                                                            onTap: () {
                                                                              BlocProvider.of<AttachmentBloc>(context).add(AddAttachmentEvent(
                                                                                attachmentTypeState.attachmentTypes[index].id!,
                                                                                _otherAttachmentController.text,
                                                                                _images!,
                                                                                _files!,
                                                                              ));
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
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        margin:
                                                            EdgeInsets.all(5.h),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          border: Border.all(
                                                            color: AppColor
                                                                .deepAppBarBlue,
                                                            width: 1.0,
                                                          ),
                                                        ),
                                                        height: 140.h,
                                                        width: 120.w,
                                                        clipBehavior:
                                                            Clip.antiAlias,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          child: orderBrokerProvider
                                                                      .attachments
                                                                      .singleWhere(
                                                                          (it) =>
                                                                              it!.attachmentType ==
                                                                              attachmentTypeState
                                                                                  .attachmentTypes[
                                                                                      index]
                                                                                  .id,
                                                                          orElse: () => Attachment(
                                                                              id:
                                                                                  0))
                                                                      .id !=
                                                                  Attachment(
                                                                          id: 0)
                                                                      .id
                                                              ? SizedBox(
                                                                  height: 137.h,
                                                                  width: 120.w,
                                                                  child: Wrap(
                                                                    children: _buildAttachmentImages(orderBrokerProvider
                                                                        .attachments
                                                                        .singleWhere(
                                                                            (it) =>
                                                                                it!.attachmentType ==
                                                                                attachmentTypeState.attachmentTypes[index].id,
                                                                            orElse: () => Attachment(id: 0))
                                                                        .image),
                                                                  ),
                                                                )
                                                              : SizedBox(
                                                                  height: 137.h,
                                                                  width: 120.w,
                                                                  child: SvgPicture
                                                                      .asset(
                                                                          "assets/icons/cloud.svg")),
                                                        ),
                                                      ),
                                                      Text(
                                                        attachmentTypeState
                                                            .attachmentTypes[
                                                                index]
                                                            .name!,
                                                        style: TextStyle(
                                                          fontSize: 18.sp,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          } else if (attachmentTypeState
                                              is AttachmentTypeLoadingProgress) {
                                            return SizedBox(
                                                height: 185.h,
                                                child: const Center(
                                                    child:
                                                        LinearProgressIndicator()));
                                          } else {
                                            return Container();
                                          }
                                        },
                                      ),
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
                                    Text(
                                        AppLocalizations.of(context)!
                                            .translate('notes'),
                                        style: const TextStyle(fontSize: 18)),
                                    SizedBox(
                                      height: 15.h,
                                    ),
                                    TextFormField(
                                      controller: _traderNotes,
                                      maxLines: 2,
                                      textInputAction: TextInputAction.done,
                                      style: const TextStyle(fontSize: 18),
                                      onChanged: (value) {
                                        orderBrokerProvider.setNote(value);
                                      },
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          hintText:
                                              AppLocalizations.of(context)!
                                                  .translate('nots_hint')),
                                    ),
                                    SizedBox(
                                      height: 15.h,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        // CustomButton(
                                        //   onTap: () {
                                        //     Navigator.pop(context);
                                        //   },
                                        //   title: const SizedBox(
                                        //       width: 100,
                                        //       child:
                                        //           Center(child: Text("إلغاء"))),
                                        // ),
                                        BlocConsumer<OfferBloc, OfferState>(
                                          listener: (context, offerstate) {
                                            if (offerstate
                                                is OfferLoadedSuccess) {
                                              BlocProvider.of<
                                                          AttachmentsListBloc>(
                                                      context)
                                                  .add(
                                                      ClearAttachmentToListEvent());
                                              Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const ControlView(),
                                                ),
                                                (route) => false,
                                              );

                                              var snackBar = SnackBar(
                                                elevation: 0,
                                                duration:
                                                    const Duration(seconds: 4),
                                                backgroundColor:
                                                    Colors.transparent,
                                                content: Column(
                                                  children: [
                                                    AwesomeSnackbarContent(
                                                      title: AppLocalizations
                                                              .of(context)!
                                                          .translate('done'),
                                                      message: AppLocalizations
                                                              .of(context)!
                                                          .translate(
                                                              'order_success_message'),

                                                      /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                                      contentType:
                                                          ContentType.success,
                                                    ),
                                                    SizedBox(
                                                      height: 90.h,
                                                    ),
                                                  ],
                                                ),
                                              );
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                              orderBrokerProvider
                                                  .initProvider();
                                            }
                                            if (offerstate
                                                is OfferLoadedFailed) {
                                              var snackBar = SnackBar(
                                                elevation: 0,
                                                duration:
                                                    const Duration(seconds: 4),
                                                backgroundColor:
                                                    Colors.transparent,
                                                content: Column(
                                                  children: [
                                                    AwesomeSnackbarContent(
                                                      title: AppLocalizations
                                                              .of(context)!
                                                          .translate('warning'),
                                                      message: AppLocalizations
                                                              .of(context)!
                                                          .translate(
                                                              'order_waring_message'),

                                                      /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                                      contentType:
                                                          ContentType.warning,
                                                    ),
                                                    SizedBox(
                                                      height: 90.h,
                                                    ),
                                                  ],
                                                ),
                                              );
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                              BlocProvider.of<OfferBloc>(
                                                      context)
                                                  .add(OfferInit());
                                            }
                                          },
                                          builder: (context, offerstate) {
                                            if (offerstate
                                                is OfferLoadingProgress) {
                                              return CustomButton(
                                                onTap: () {},
                                                title: const SizedBox(
                                                    width: 100,
                                                    child: Center(
                                                        child:
                                                            CircularProgressIndicator())),
                                              );
                                            } else {
                                              return CustomButton(
                                                onTap: () {
                                                  if (orderBrokerProvider
                                                          .productExpireDate !=
                                                      null) {
                                                    if (orderBrokerProvider
                                                            .packageTypeId !=
                                                        0) {
                                                      if (_attachmentformkey
                                                          .currentState!
                                                          .validate()) {
                                                        BlocProvider.of<OfferBloc>(context).add(AddOfferEvent(
                                                            orderBrokerProvider
                                                                .selectedRadioTile,
                                                            orderBrokerProvider
                                                                .packageNum,
                                                            orderBrokerProvider
                                                                .tabalehNum,
                                                            widget.weight!,
                                                            widget.price!,
                                                            widget.taxes!,
                                                            orderBrokerProvider
                                                                .selectedCustomeAgency!
                                                                .id!,
                                                            orderBrokerProvider
                                                                .selectedStateCustome!
                                                                .id!,
                                                            widget.origin!,
                                                            orderBrokerProvider
                                                                .packageTypeId,
                                                            "${orderBrokerProvider.productExpireDate!.year}-${orderBrokerProvider.productExpireDate!.month}-${orderBrokerProvider.productExpireDate!.day}",
                                                            orderBrokerProvider
                                                                .note,
                                                            widget.product!,
                                                            orderBrokerProvider
                                                                .attachmentsId,
                                                            widget.rawMaterial!,
                                                            widget
                                                                .industrial!));
                                                      } else {
                                                        Scrollable
                                                            .ensureVisible(
                                                          key2.currentContext!,
                                                          duration:
                                                              const Duration(
                                                            milliseconds: 500,
                                                          ),
                                                        );
                                                      }
                                                    } else {
                                                      orderBrokerProvider
                                                          .setPackageError(
                                                              true);
                                                      Scrollable.ensureVisible(
                                                        key2.currentContext!,
                                                        duration:
                                                            const Duration(
                                                          milliseconds: 500,
                                                        ),
                                                      );
                                                    }
                                                  } else {
                                                    orderBrokerProvider
                                                        .setDateError(true);
                                                    Scrollable.ensureVisible(
                                                      key1.currentContext!,
                                                      duration: const Duration(
                                                        milliseconds: 500,
                                                      ),
                                                    );
                                                  }
                                                },
                                                title: SizedBox(
                                                    width: 100,
                                                    child: Center(
                                                        child: Text(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .translate(
                                                                    'broker_order')))),
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ]),
                            ),
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
