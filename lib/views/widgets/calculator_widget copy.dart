import 'dart:async';
import 'dart:convert';

import 'package:custome_mobile/business_logic/bloc/calculate_result_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/calculator_panel_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/fee_select_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/flags_bloc.dart';
import 'package:custome_mobile/business_logic/cubit/bottom_nav_bar_cubit.dart';
import 'package:custome_mobile/business_logic/cubit/stop_scroll_cubit.dart';
import 'package:custome_mobile/data/models/package_model.dart';
import 'package:custome_mobile/data/services/calculator_service.dart';
import 'package:custome_mobile/helpers/color_constants.dart';
import 'package:custome_mobile/helpers/formatter.dart';
import 'package:custome_mobile/views/screens/trader/trader_calculator_result_screen.dart';
import 'package:custome_mobile/views/widgets/custom_botton.dart';
import 'package:custome_mobile/views/widgets/highlight_text.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

// ignore: must_be_immutable
class CalculatorWidget2 extends StatefulWidget {
  GlobalKey<FormState> calformkey;

  TextEditingController? typeAheadController;

  TextEditingController? wieghtController;

  TextEditingController? originController;

  TextEditingController? valueController;
  bool? tariffButton;
  final Function()? unfocus;

  CalculatorWidget2({
    Key? key,
    required this.calformkey,
    required this.typeAheadController,
    required this.wieghtController,
    required this.originController,
    required this.valueController,
    required this.tariffButton,
    this.unfocus,
  }) : super(key: key);

  @override
  State<CalculatorWidget2> createState() => _CalculatorWidget2State();
}

class _CalculatorWidget2State extends State<CalculatorWidget2> {
  String syrianExchangeValue = "8585";

  String syrianTotalValue = "0";

  String totalValueWithEnsurance = "0";

  Package? selectedPackage;
  Origin? selectedOrigin;

  String wieghtUnit = "";
  String wieghtLabel = "الوزن";

  double usTosp = 8585;
  double basePrice = 0;
  double wieghtValue = 0;
  var f = NumberFormat("#,###", "en_US");

  bool valueEnabled = true;
  bool allowexport = false;
  bool fillorigin = false;
  bool originerror = false;
  bool feeerror = false;
  bool isfeeequal001 = false;
  bool isBrand = false;
  bool brandValue = false;
  bool rawMaterialValue = false;
  bool industrialValue = false;
  bool isTubes = false;
  bool tubesValue = false;
  bool isLycra = false;
  bool lycraValue = false;
  bool isColored = false;
  bool colorValue = false;
  bool showunit = false;
  bool isdropdwonVisible = false;
  String _placeholder = "";
  String patternString = "";
  CalculateObject result = CalculateObject();
  final FocusNode _statenode = FocusNode();
  late final KeyboardVisibilityController _keyboardVisibilityController;
  late StreamSubscription<bool> keyboardSubscription;

  final FocusNode _nodeWeight = FocusNode();
  final FocusNode _nodeValue = FocusNode();
  @override
  void initState() {
    super.initState();
    _keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription =
        _keyboardVisibilityController.onChange.listen((isVisible) {
      if (!isVisible) {
        FocusManager.instance.primaryFocus?.unfocus();
        BlocProvider.of<BottomNavBarCubit>(context).emitShow();
      }
    });
    // FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    super.dispose();
  }

  void calculateTotalValueWithPrice() {
    var syrianExch =
        double.parse(widget.wieghtController!.text.replaceAll(",", "")) *
            double.parse(widget.valueController!.text.replaceAll(",", ""));
    var syrianTotal = syrianExch * 8585;
    var totalEnsurance = (syrianTotal) + (syrianTotal * 0.0012);
    setState(() {
      syrianExchangeValue = syrianExch.round().toString();
      syrianTotalValue = syrianTotal.round().toString();
      totalValueWithEnsurance = totalEnsurance.round().toString();
    });
  }

  void calculateTotalValue() {
    var syrianTotal =
        double.parse(widget.valueController!.text.replaceAll(",", "")) * 8585;
    var totalEnsurance = (syrianTotal) + (syrianTotal * 0.0012);
    setState(() {
      syrianTotalValue = syrianTotal.round().toString();
      totalValueWithEnsurance = totalEnsurance.round().toString();
    });
  }

  void selectSuggestion(Package suggestion) {
    widget.typeAheadController!.text = suggestion.label!;
    selectedPackage = suggestion;
    setState(() {
      feeerror = false;
    });
    if (suggestion.price! > 0) {
      basePrice = suggestion.price!;

      widget.valueController!.text = suggestion.price!.toString();
      setState(() {
        valueEnabled = false;
      });
    } else {
      setState(() {
        basePrice = 0.0;

        if (widget.valueController!.text.isEmpty) {
          widget.valueController!.text = "0.0";
        }
        valueEnabled = true;
        syrianExchangeValue = "8585";
      });
    }

    if (suggestion.extras!.isNotEmpty) {
      if (suggestion.extras![0].brand!) {
        setState(() {
          isBrand = true;
          brandValue = false;
        });
      } else {
        setState(() {
          isBrand = false;
          brandValue = false;
        });
      }

      if (suggestion.extras![0].tubes!) {
        setState(() {
          isTubes = true;
          tubesValue = false;
        });
      } else {
        setState(() {
          isTubes = false;
          tubesValue = false;
        });
      }

      if (suggestion.extras![0].lycra!) {
        setState(() {
          isLycra = true;
          lycraValue = false;
        });
      } else {
        setState(() {
          isLycra = false;
          lycraValue = false;
        });
      }

      if (suggestion.extras![0].coloredThread!) {
        setState(() {
          isColored = true;
          colorValue = false;
        });
      } else {
        setState(() {
          isColored = false;
          colorValue = false;
        });
      }
    }

    if (suggestion.unit!.isNotEmpty) {
      switch (suggestion.unit) {
        case "كغ":
          setState(() {
            wieghtLabel = " الوزن";
          });
          break;
        case "طن":
          setState(() {
            wieghtLabel = " الوزن";
          });
          break;
        case "قيراط":
          setState(() {
            wieghtLabel = " الوزن";
          });
          break;
        case "كيلو واط بالساعة 1000":
          setState(() {
            wieghtLabel = "الاستطاعة";
          });
          break;
        case "الاستطاعة بالطن":
          setState(() {
            wieghtLabel = "الاستطاعة";
          });
          break;
        case "واط":
          setState(() {
            wieghtLabel = "الاستطاعة";
          });
          break;
        case "عدد الأزواج":
          setState(() {
            wieghtLabel = "العدد";
          });
          break;
        case "عدد":
          setState(() {
            wieghtLabel = "العدد";
          });
          break;
        case "طرد":
          setState(() {
            wieghtLabel = "العدد";
          });
          break;
        case "قدم":
          setState(() {
            wieghtLabel = "العدد";
          });
          break;
        case "متر":
          setState(() {
            wieghtLabel = "الحجم";
          });
          break;
        case "متر مربع":
          setState(() {
            wieghtLabel = "الحجم";
          });
          break;
        case "متر مكعب":
          setState(() {
            wieghtLabel = "الحجم";
          });
          break;
        case "لتر":
          setState(() {
            wieghtLabel = "السعة";
          });
          break;
        default:
          setState(() {
            wieghtLabel = "الوزن";
          });
      }
      setState(() {
        wieghtUnit = suggestion.unit!;
        showunit = true;
      });
    } else {
      setState(() {
        wieghtUnit = "";
        showunit = false;
      });
    }

    if (suggestion.placeholder != "") {
      setState(() {
        _placeholder = suggestion.placeholder!;
        isdropdwonVisible = false;
        items = suggestion.extras!;
        isdropdwonVisible = true;
      });
    } else {
      setState(() {
        isdropdwonVisible = false;
        _placeholder = "";
        items = [];
      });
    }

    if (suggestion.fee! == 0.01) {
      setState(() {
        isfeeequal001 = true;
      });
    } else {
      setState(() {
        isfeeequal001 = false;
      });
    }

    switch (suggestion.export1) {
      case "0":
        setState(() {
          allowexport = true;
        });
        break;
      case "1":
        setState(() {
          allowexport = false;
        });
        break;
      default:
    }
  }

  void selectOrigin(Origin origin) {
    widget.originController!.text = " ${origin.label!}";
    setState(() {
      selectedOrigin = origin;
      originerror = false;
    });

    if (selectedPackage!.extras!.isNotEmpty) {
      outerLoop:
      for (var element in selectedPackage!.extras!) {
        for (var element1 in origin.countryGroups!) {
          if (element.countryGroup!.contains(element1)) {
            if (element.price! > 0) {
              widget.valueController!.text = element.price!.toString();
              basePrice = element.price!;

              setState(() {
                valueEnabled = false;
              });
              break outerLoop;
            }
          } else {
            setState(() {
              basePrice = 0.0;
              widget.valueController!.text = "0.0";
              valueEnabled = true;
              syrianExchangeValue = "8585";
            });
          }
        }
      }
      if (origin.countryGroups!.isEmpty) {
        setState(() {
          basePrice = 0.0;

          widget.valueController!.text = "0.0";
          valueEnabled = true;
          syrianExchangeValue = "8585";
        });
      }
    }
    evaluatePrice();
  }

  void calculateExtrasPrice(double percentage, bool add) {
    var price = 0.0;
    if (add) {
      price =
          double.parse(widget.valueController!.text) + (basePrice * percentage);

      setState(() {
        widget.valueController!.text = price.toString();
      });
    } else {
      price =
          double.parse(widget.valueController!.text) - (basePrice * percentage);

      setState(() {
        widget.valueController!.text = price.toString();
      });
    }
  }

  void evaluatePrice() {
    if (valueEnabled) {
      calculateTotalValue();
    } else {
      calculateTotalValueWithPrice();
    }
  }

  List<Extras> items = [];
  Extras? selectedValue;

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
        KeyboardActionsItem(
          focusNode: _nodeWeight,
          toolbarButtons: [
            //button 2
            (node) {
              return GestureDetector(
                onTap: () {
                  node.unfocus();
                  BlocProvider.of<BottomNavBarCubit>(context).emitShow();
                },
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    "DONE",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              );
            }
          ],
        ),
        KeyboardActionsItem(
          focusNode: _nodeValue,
          toolbarButtons: [
            //button 2
            (node) {
              return GestureDetector(
                onTap: () {
                  node.unfocus();
                  BlocProvider.of<BottomNavBarCubit>(context).emitShow();
                },
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    "DONE",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              );
            }
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FeeSelectBloc, FeeSelectState>(
      listener: (context, state) {
        if (state is FeeSelectSuccess) {
          setState(() {
            widget.wieghtController!.text = "0.0";
            widget.valueController!.text = "0.0";
            syrianExchangeValue = "0.0";
            syrianTotalValue = "0.0";
            totalValueWithEnsurance = "0.0";
          });
          selectSuggestion(state.package);
        }
      },
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          BlocProvider.of<BottomNavBarCubit>(context).emitShow();
        },
        child: Form(
          key: widget.calformkey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Focus(
                    // focusNode: _ordernode,
                    child: Text("تفاصيل البضاعة",
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: AppColor.deepBlue,
                        )),
                  ),
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  widget.tariffButton!
                      ? GestureDetector(
                          onTap: () {
                            BlocProvider.of<CalculatorPanelBloc>(context)
                                .add(TariffPanelOpenEvent());
                            // BlocProvider.of<SectionBloc>(context)
                            //     .add(SectionLoadEvent());
                            FocusManager.instance.primaryFocus?.unfocus();
                            BlocProvider.of<BottomNavBarCubit>(context)
                                .emitShow();
                          },
                          child: SizedBox(
                            height: 40.h,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: 25.w,
                                  height: 25.h,
                                  child: SvgPicture.asset(
                                    "assets/icons/tarrif_btn.svg",
                                  ),
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  "تصفح التعرفة",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: AppColor.lightBlue,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                  Focus(
                    focusNode: _statenode,
                    onFocusChange: (bool focus) {
                      if (!focus) {
                        FocusManager.instance.primaryFocus?.unfocus();
                        BlocProvider.of<BottomNavBarCubit>(context).emitShow();
                        BlocProvider.of<StopScrollCubit>(context).emitEnable();
                      }
                    },
                    child: TypeAheadField(
                      textFieldConfiguration: TextFieldConfiguration(
                        // autofocus: true,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        controller: widget.typeAheadController,
                        scrollPadding: EdgeInsets.only(
                            bottom:
                                MediaQuery.of(context).viewInsets.bottom + 150),
                        onTap: () {
                          // setSelectedPanel(2);
                          BlocProvider.of<BottomNavBarCubit>(context)
                              .emitHide();
                          widget.typeAheadController!.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: widget
                                  .typeAheadController!.value.text.length);
                        },

                        style: const TextStyle(fontSize: 18),
                        decoration: const InputDecoration(
                          labelText: "نوع البضاعة",
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 9.0,
                            vertical: 11.0,
                          ),
                        ),
                        onSubmitted: (value) {
                          BlocProvider.of<StopScrollCubit>(context)
                              .emitEnable();
                          FocusManager.instance.primaryFocus?.unfocus();
                          BlocProvider.of<BottomNavBarCubit>(context)
                              .emitShow();
                        },
                      ),
                      loadingBuilder: (context) {
                        return Container(
                          color: Colors.white,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      },
                      errorBuilder: (context, error) {
                        return Container(
                          color: Colors.white,
                        );
                      },
                      noItemsFoundBuilder: (value) {
                        var localizedMessage = "لم يتم العثور على أية نتائج!";
                        return Container(
                          width: double.infinity,
                          color: Colors.white,
                          child: Center(
                            child: Text(
                              localizedMessage,
                              style: TextStyle(fontSize: 18.sp),
                            ),
                          ),
                        );
                      },
                      suggestionsCallback: (pattern) async {
                        setState(() {
                          patternString = pattern;
                        });
                        if (pattern.isNotEmpty) {
                          BlocProvider.of<StopScrollCubit>(context)
                              .emitDisable();
                        }
                        return pattern.isEmpty || pattern.length == 1
                            ? []
                            : await CalculatorService.getpackages(pattern);
                      },
                      itemBuilder: (context, suggestion) {
                        return Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              ListTile(
                                // leading: Icon(Icons.shopping_cart),
                                tileColor: Colors.white,
                                title: HighlightText(
                                  text: suggestion.label!,
                                  highlight: patternString,
                                  ignoreCase: false,
                                  style: TextStyle(fontSize: 17.sp),
                                  highlightStyle: TextStyle(
                                    fontSize: 17.sp,
                                    backgroundColor: AppColor.goldenYellow,
                                    color: Colors.white,
                                  ),
                                ),
                                // subtitle: Text('\$${suggestion['price']}'),
                              ),
                              Divider(
                                color: Colors.grey[300],
                                height: 3,
                              ),
                            ],
                          ),
                        );
                      },
                      onSuggestionSelected: (suggestion) {
                        // setState(() {
                        //   widget.wieghtController!.text = "";
                        //   widget.valueController!.text = "";
                        //   syrianExchangeValue = "0.0";
                        //   syrianTotalValue = "0.0";
                        //   totalValueWithEnsurance = "0.0";
                        // });
                        BlocProvider.of<StopScrollCubit>(context).emitEnable();
                        selectSuggestion(suggestion);
                        FocusManager.instance.primaryFocus?.unfocus();
                        BlocProvider.of<BottomNavBarCubit>(context).emitShow();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 14,
              ),
              Visibility(
                visible: allowexport,
                child: const Text(
                  "هذا البند ممنوع من الاستيراد",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 13,
                  ),
                ),
              ),
              Visibility(
                visible: allowexport,
                child: const SizedBox(
                  height: 14,
                ),
              ),
              Visibility(
                visible: feeerror,
                child: const Text(
                  "الرجاء اختيار البند",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 13,
                  ),
                ),
              ),
              Visibility(
                visible: feeerror,
                child: const SizedBox(
                  height: 14,
                ),
              ),
              Visibility(
                visible: isdropdwonVisible,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<Extras>(
                    isExpanded: true,
                    barrierLabel: _placeholder,
                    hint: Text(
                      _placeholder,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    items: items
                        .map((Extras item) => DropdownMenuItem<Extras>(
                              value: item,
                              child: Text(
                                item.label!,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ))
                        .toList(),
                    value: selectedValue,
                    onChanged: (Extras? value) {
                      if (value!.countryGroup!.isEmpty) {
                        if (value.price! > 0) {
                          basePrice = value.price!;

                          widget.valueController!.text =
                              value.price!.toString();
                          setState(() {
                            valueEnabled = false;
                          });
                        } else {
                          setState(() {
                            basePrice = 0.0;

                            widget.valueController!.text = "0.0";
                            valueEnabled = true;
                            syrianExchangeValue = "8585";
                          });
                        }
                        evaluatePrice();
                      } else {
                        if (value.price! > 0) {
                          basePrice = value.price!;

                          widget.valueController!.text =
                              value.price!.toString();
                          setState(() {
                            valueEnabled = false;
                          });
                        } else {
                          setState(() {
                            basePrice = 0.0;

                            widget.valueController!.text = "0.0";
                            valueEnabled = true;
                            syrianExchangeValue = "8585";
                          });
                        }
                        evaluatePrice();
                      }
                      setState(() {
                        selectedValue = value;
                      });
                    },
                    buttonStyleData: ButtonStyleData(
                      height: 50,
                      width: double.infinity,

                      padding: const EdgeInsets.symmetric(
                        horizontal: 9.0,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.black26,
                        ),
                        color: Colors.white,
                      ),
                      // elevation: 2,
                    ),
                    iconStyleData: const IconStyleData(
                      icon: Icon(
                        Icons.keyboard_arrow_down_sharp,
                      ),
                      iconSize: 20,
                      iconEnabledColor: AppColor.AccentBlue,
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
                        thumbVisibility: MaterialStateProperty.all(true),
                      ),
                    ),
                    menuItemStyleData: MenuItemStyleData(
                      height: 40.h,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: isdropdwonVisible,
                child: const SizedBox(
                  height: 24,
                ),
              ),
              // BlocBuilder<FlagsBloc, FlagsState>(
              //   builder: (context, flagstate) {
              //     if (flagstate is FlagsLoadedSuccess) {
              //       return DropdownSearch<Origin>(
              //         popupProps: PopupProps.modalBottomSheet(
              //           showSearchBox: true,

              //           itemBuilder: (context, item, isSelected) {
              //             return Padding(
              //               padding: EdgeInsets.symmetric(horizontal: 12.w),
              //               // width: 200,
              //               child: Row(
              //                 children: [
              //                   SvgPicture.network(
              //                     item.imageURL!,
              //                     height: 45.h,
              //                     width: 55.w,
              //                     placeholderBuilder: (context) => Container(
              //                       height: 45.h,
              //                       width: 55.w,
              //                       decoration: BoxDecoration(
              //                         color: Colors.grey[200],
              //                         borderRadius: BorderRadius.circular(5),
              //                       ),
              //                     ),
              //                   ),
              //                   const SizedBox(width: 12),
              //                   Container(
              //                     constraints: BoxConstraints(
              //                       maxWidth: 280.w,
              //                     ),
              //                     child: Text(
              //                       item.label!,
              //                       overflow: TextOverflow.ellipsis,
              //                       // maxLines: 2,
              //                       style: const TextStyle(
              //                         fontSize: 19,
              //                       ),
              //                     ),
              //                   ),
              //                 ],
              //                 // subtitle: Text('\$${suggestion['price']}'),
              //               ),
              //             );
              //           },

              //           modalBottomSheetProps: const ModalBottomSheetProps(
              //             padding: EdgeInsets.all(8),
              //           ),

              //           containerBuilder: (context, popupWidget) {
              //             return Container(
              //               height: MediaQuery.of(context).size.height - 50.h,
              //               padding: const EdgeInsets.all(8),
              //               decoration: const BoxDecoration(
              //                 borderRadius: BorderRadius.zero,
              //               ),
              //               child: popupWidget,
              //             );
              //           },
              //           // title: Text("اختر المنشأ"),
              //         ),
              //         items: flagstate.origins,
              //         dropdownDecoratorProps: const DropDownDecoratorProps(
              //           dropdownSearchDecoration: InputDecoration(
              //             // labelText: "اختر المنشأ",
              //             hintText: "اختر المنشأ من القائمة",
              //           ),
              //         ),
              //         dropdownBuilder: (context, selectedItem) {
              //           return selectedItem != null
              //               ? Row(
              //                   children: [
              //                     SvgPicture.network(
              //                       selectedItem!.imageURL!,
              //                       height: 35.h,
              //                       width: 45.w,
              //                       placeholderBuilder: (context) => Container(
              //                         height: 35.h,
              //                         width: 45.w,
              //                         decoration: BoxDecoration(
              //                           color: Colors.grey[200],
              //                           borderRadius: BorderRadius.circular(5),
              //                         ),
              //                       ),
              //                     ),
              //                     const SizedBox(width: 12),
              //                     Container(
              //                       constraints: BoxConstraints(
              //                         maxWidth: 280.w,
              //                       ),
              //                       child: Text(
              //                         selectedItem!.label!,
              //                         overflow: TextOverflow.ellipsis,
              //                         // maxLines: 2,
              //                         style: const TextStyle(
              //                           fontSize: 19,
              //                         ),
              //                       ),
              //                     ),
              //                   ],
              //                   // subtitle: Text('\$${suggestion['price']}'),
              //                 )
              //               : Text(
              //                   "اختر المنشأ",
              //                   style: TextStyle(
              //                       fontSize: 18, color: Colors.grey[600]!),
              //                 );
              //         },
              //         dropdownButtonProps: const DropdownButtonProps(
              //           icon: Icon(
              //             Icons.keyboard_arrow_down_sharp,
              //             color: AppColor.AccentBlue,
              //           ),
              //           iconSize: 20,
              //         ),
              //         filterFn: (item, filter) {
              //           return item.label!.contains(filter);
              //         },
              //         onChanged: (value) {
              //           selectOrigin(value!);
              //         },
              //         selectedItem: selectedOrigin,
              //       );
              //     } else if (flagstate is FlagsLoadingProgressState) {
              //       return const Center(
              //         child: LinearProgressIndicator(),
              //       );
              //     } else {
              //       return Center(
              //         child: GestureDetector(
              //           onTap: () {
              //             BlocProvider.of<FlagsBloc>(context)
              //                 .add(FlagsLoadEvent());
              //           },
              //           child: const Row(
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             children: [
              //               Text(
              //                 "حدث خطأأثناء تحميل القائمة...  ",
              //                 style: TextStyle(color: Colors.red),
              //               ),
              //               Icon(
              //                 Icons.refresh,
              //                 color: Colors.grey,
              //               )
              //             ],
              //           ),
              //         ),
              //       );
              //     }
              //   },
              // ),
              BlocBuilder<FlagsBloc, FlagsState>(
                builder: (context, flagstate) {
                  if (flagstate is FlagsLoadedSuccess) {
                    return DropdownButtonHideUnderline(
                      child: DropdownButton2<Origin>(
                        isExpanded: true,
                        hint: Text(
                          "اختر المنشأ",
                          style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        items: flagstate.origins
                            .map((Origin item) => DropdownMenuItem<Origin>(
                                  value: item,
                                  child: SizedBox(
                                    // width: 200,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          height: 35,
                                          width: 55,
                                          child: SvgPicture.network(
                                            item.imageURL!,
                                            height: 35,
                                            width: 55,
                                            // semanticsLabel: 'A shark?!',
                                            placeholderBuilder:
                                                (BuildContext context) =>
                                                    Container(
                                              height: 35.h,
                                              width: 45.w,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 7),
                                        Container(
                                          constraints: BoxConstraints(
                                            maxWidth: 280.w,
                                          ),
                                          child: Text(
                                            item.label!,
                                            overflow: TextOverflow.ellipsis,
                                            // maxLines: 2,
                                          ),
                                        ),
                                      ],
                                      // subtitle: Text('\$${suggestion['price']}'),
                                    ),
                                  ),
                                ))
                            .toList(),
                        value: selectedOrigin,
                        onChanged: (Origin? value) {
                          // setState(() {
                          //   selectedOrigin = value;
                          // });
                          selectOrigin(value!);
                        },
                        dropdownSearchData: DropdownSearchData(
                          searchController: widget.originController,
                          searchInnerWidgetHeight: 60,
                          searchInnerWidget: Container(
                            height: 60,
                            padding: const EdgeInsets.only(
                              top: 8,
                              bottom: 4,
                              right: 8,
                              left: 8,
                            ),
                            child: TextFormField(
                              expands: true,
                              maxLines: null,
                              controller: widget.originController,
                              onTap: () {
                                widget.originController!.selection =
                                    TextSelection(
                                        baseOffset: 0,
                                        extentOffset: widget.originController!
                                            .value.text.length);
                              },
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                labelText: 'اختر المنشأ',
                                hintStyle: const TextStyle(fontSize: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onTapOutside: (event) {
                                widget.unfocus;
                                BlocProvider.of<BottomNavBarCubit>(context)
                                    .emitShow();
                              },
                              onFieldSubmitted: (value) {
                                widget.unfocus;
                                BlocProvider.of<BottomNavBarCubit>(context)
                                    .emitShow();
                              },
                            ),
                          ),
                          searchMatchFn: (item, searchValue) {
                            return item.value!.label!.contains(searchValue);
                          },
                        ),
                        onMenuStateChange: (isOpen) {
                          if (isOpen) {
                            setState(() {
                              widget.originController!.clear();
                            });
                          }
                        },
                        buttonStyleData: ButtonStyleData(
                          height: 50,
                          width: double.infinity,
                          padding: const EdgeInsets.only(left: 14, right: 14),

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.black26,
                            ),
                            color: Colors.white,
                          ),
                          // elevation: 2,
                        ),
                        iconStyleData: const IconStyleData(
                          icon: Icon(
                            Icons.keyboard_arrow_down_sharp,
                          ),
                          iconSize: 20,
                          iconEnabledColor: AppColor.AccentBlue,
                          iconDisabledColor: Colors.grey,
                        ),
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 400,
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: Colors.white,
                          ),
                          scrollbarTheme: ScrollbarThemeData(
                            radius: const Radius.circular(40),
                            thickness: MaterialStateProperty.all(6),
                            thumbVisibility: MaterialStateProperty.all(true),
                          ),
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40,
                        ),
                      ),
                    );
                  } else if (flagstate is FlagsLoadingProgressState) {
                    return const Center(
                      child: LinearProgressIndicator(),
                    );
                  } else {
                    return Center(
                      child: GestureDetector(
                        onTap: () {
                          BlocProvider.of<FlagsBloc>(context)
                              .add(FlagsLoadEvent());
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "حدث خطأأثناء تحميل القائمة...  ",
                              style: TextStyle(color: Colors.red),
                            ),
                            Icon(
                              Icons.refresh,
                              color: Colors.grey,
                            )
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(
                height: 14,
              ),

              Visibility(
                visible: originerror,
                child: const Text(
                  "الرجاء اختيار المنشأ",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              Visibility(
                visible: originerror,
                child: const SizedBox(
                  height: 24,
                ),
              ),
              TextFormField(
                controller: widget.wieghtController!,
                // focusNode: _nodeWeight,
                onTap: () {
                  BlocProvider.of<BottomNavBarCubit>(context).emitHide();
                  widget.wieghtController!.selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: widget.wieghtController!.value.text.length);
                },
                // enabled: !valueEnabled,
                scrollPadding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 50),
                textInputAction: TextInputAction.done,
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: true, signed: true),
                inputFormatters: [
                  DecimalFormatter(),
                ],
                style: const TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  labelText: wieghtLabel,
                  suffixText: showunit ? wieghtUnit : "",
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 9.0,
                    vertical: 11.0,
                  ),
                ),
                onChanged: (value) {
                  if (widget.originController!.text.isNotEmpty) {
                    setState(() {
                      originerror = false;
                    });
                    if (value.isNotEmpty) {
                      // calculateTotalValueWithPrice(value);
                      wieghtValue = double.parse(value);
                    } else {
                      wieghtValue = 0.0;
                    }
                    evaluatePrice();
                  } else {
                    setState(() {
                      originerror = true;
                    });
                  }
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "الرجاء ادخال القيمة";
                  }
                  return null;
                },
                onFieldSubmitted: (value) {
                  FocusManager.instance.primaryFocus?.unfocus();
                  BlocProvider.of<BottomNavBarCubit>(context).emitShow();
                },
              ),

              const SizedBox(
                height: 24,
              ),
              TextFormField(
                controller: widget.valueController!,
                // focusNode: _nodeValue,
                onTap: () {
                  BlocProvider.of<BottomNavBarCubit>(context).emitHide();
                  widget.valueController!.selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: widget.valueController!.value.text.length);
                },
                // enabled: valueEnabled,
                textInputAction: TextInputAction.done,
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: true, signed: true),
                inputFormatters: [
                  DecimalFormatter(),
                ],
                scrollPadding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 50),
                style: const TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  suffixText: "\$",
                  labelText: valueEnabled
                      ? "قيمة البضاعة الاجمالية بالدولار"
                      : "سعر الواحدة لدى الجمارك",
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 9.0,
                    vertical: 11.0,
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "الرجاء ادخال القيمة";
                  }
                  return null;
                },
                onChanged: (value) {
                  if (widget.originController!.text.isNotEmpty) {
                    setState(() {
                      originerror = false;
                    });
                    if (value.isNotEmpty) {
                      basePrice = double.parse(value);
                      // calculateTotalValue();
                    } else {
                      basePrice = 0.0;
                      // calculateTotalValue();
                    }
                    evaluatePrice();
                  } else {
                    setState(() {
                      originerror = true;
                    });
                  }
                },
                onFieldSubmitted: (value) {
                  FocusManager.instance.primaryFocus?.unfocus();
                  BlocProvider.of<BottomNavBarCubit>(context).emitShow();
                },
              ),
              const SizedBox(
                height: 12,
              ),
              Visibility(
                visible: isfeeequal001,
                child: CheckboxListTile(
                    value: rawMaterialValue,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: const Text("المادة أولية؟"),
                    onChanged: (value) {
                      setState(() {
                        rawMaterialValue = value!;
                      });
                    }),
              ),
              // Visibility(
              //   visible: isfeeequal001,
              //   child: const SizedBox(
              //     height: 12,
              //   ),
              // ),
              Visibility(
                visible: isfeeequal001,
                child: CheckboxListTile(
                    value: industrialValue,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: const Text("المادة صناعية؟"),
                    onChanged: (value) {
                      setState(() {
                        industrialValue = value!;
                      });
                    }),
              ),
              Visibility(
                visible: isfeeequal001,
                child: const SizedBox(
                  height: 12,
                ),
              ),
              Visibility(
                visible: isBrand,
                child: CheckboxListTile(
                    value: brandValue,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: const Text("البضاعة ماركة؟"),
                    onChanged: (value) {
                      calculateExtrasPrice(1.5, value!);
                      setState(() {
                        brandValue = value;
                      });
                    }),
              ),
              Visibility(
                visible: isBrand,
                child: const SizedBox(
                  height: 12,
                ),
              ),
              Visibility(
                visible: isTubes,
                child: CheckboxListTile(
                    value: tubesValue,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: const Text("قياس الأنابيب أقل أو يساوي 3inch؟"),
                    onChanged: (value) {
                      calculateExtrasPrice(.1, value!);
                      setState(() {
                        tubesValue = value;
                      });
                    }),
              ),
              Visibility(
                visible: isTubes,
                child: const SizedBox(
                  height: 12,
                ),
              ),
              Visibility(
                visible: isColored,
                child: CheckboxListTile(
                    value: colorValue,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: const Text("الخيوط ملونة؟"),
                    onChanged: (value) {
                      calculateExtrasPrice(.1, value!);
                      setState(() {
                        colorValue = value;
                      });
                    }),
              ),
              Visibility(
                visible: isColored,
                child: const SizedBox(
                  height: 12,
                ),
              ),
              Visibility(
                visible: isLycra,
                child: CheckboxListTile(
                    value: lycraValue,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: const Text("الخيوط ليكرا؟"),
                    onChanged: (value) {
                      calculateExtrasPrice(.05, value!);
                      setState(() {
                        lycraValue = value;
                      });
                    }),
              ),
              Visibility(
                visible: isLycra,
                child: const SizedBox(
                  height: 12,
                ),
              ),
              // const Text(
              //   "ملاحظة: الحد الأدنى للسعر الاسترشادي هو 100\$",
              //   style: TextStyle(color: Colors.grey),
              // ),
              // const SizedBox(
              //   height: 12,
              // ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColor.lightGreen,
                  border: Border.all(color: Colors.black26, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   "قيمة التحويل بالجنيه المصري : 8585 E.P",
                    //   style: TextStyle(fontSize: 17.sp),
                    // ),
                    Text(
                      "القيمة الاجمالية بالدولار :${f.format(double.parse(syrianExchangeValue).toInt())}\$",
                      style: TextStyle(fontSize: 17.sp),
                    ),
                    Text(
                      "القيمة الاجمالية بجنيه المصري :${f.format(double.parse(syrianTotalValue).toInt())} E.P",
                      style: TextStyle(fontSize: 17.sp),
                    ),
                    Text(
                      "قيمة البضاعة مع التأمين: ${f.format(double.parse(totalValueWithEnsurance).toInt())} E.P",
                      style: TextStyle(fontSize: 17.sp),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BlocConsumer<CalculateResultBloc, CalculateResultState>(
                    listener: (context, state) {
                      if (state is CalculateResultSuccessed) {}
                    },
                    builder: (context, state) {
                      if (state is CalculateResultLoading) {
                        return CustomButton(
                            onTap: () {},
                            title: SizedBox(
                                width: 250.w,
                                child: const Center(
                                    child: CircularProgressIndicator())));
                      }
                      if (state is CalculateResultFailed) {
                        return Text(state.error);
                      } else {
                        return CustomButton(
                            onTap: () {
                              widget.calformkey.currentState?.save();
                              if (widget.calformkey.currentState!.validate()) {
                                if (selectedOrigin != null) {
                                  if (selectedPackage != null) {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    BlocProvider.of<BottomNavBarCubit>(context)
                                        .emitShow();
                                    result.insurance =
                                        int.parse(totalValueWithEnsurance);
                                    result.fee = selectedPackage!.fee!;
                                    result.rawMaterial =
                                        rawMaterialValue ? 1 : 0;
                                    result.industrial = industrialValue ? 1 : 0;
                                    result.totalTax =
                                        selectedPackage!.totalTaxes!.totalTax!;
                                    result.partialTax = selectedPackage!
                                        .totalTaxes!.partialTax!;
                                    result.origin = selectedOrigin!.label!;
                                    result.spendingFee =
                                        selectedPackage!.spendingFee!;
                                    result.supportFee =
                                        selectedPackage!.supportFee!;
                                    result.localFee =
                                        selectedPackage!.localFee!;
                                    result.protectionFee =
                                        selectedPackage!.protectionFee!;
                                    result.naturalFee =
                                        selectedPackage!.naturalFee!;
                                    result.taxFee = selectedPackage!.taxFee!;
                                    result.weight = wieghtValue.toInt();
                                    result.price = basePrice.toInt();
                                    result.cnsulate = 1;
                                    result.dolar = 8585;
                                    result.arabic_stamp = selectedPackage!
                                        .totalTaxes!.arabicStamp!
                                        .toInt();
                                    result.import_fee =
                                        selectedPackage!.importFee;
                                    print(jsonEncode(result.toJson()));
                                    BlocProvider.of<CalculateResultBloc>(
                                            context)
                                        .add(CalculateTheResultEvent(result));
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    BlocProvider.of<BottomNavBarCubit>(context)
                                        .emitShow();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              TraderCalculatorResultScreen(),
                                        ));
                                  } else {
                                    setState(() {
                                      feeerror = true;
                                    });
                                  }
                                } else {
                                  setState(() {
                                    originerror = true;
                                  });
                                }
                              }
                            },
                            title: SizedBox(
                              width: 250.w,
                              child: const Center(
                                child: Text(
                                  "احسب الرسم الجمركي",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ));
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
