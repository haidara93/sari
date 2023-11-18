import 'package:custome_mobile/business_logic/bloc/calculate_result_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/calculator_panel_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/fee_select_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/flags_bloc.dart';
import 'package:custome_mobile/business_logic/cubit/bottom_nav_bar_cubit.dart';
import 'package:custome_mobile/data/models/package_model.dart';
import 'package:custome_mobile/data/services/calculator_service.dart';
import 'package:custome_mobile/helpers/color_constants.dart';
import 'package:custome_mobile/helpers/formatter.dart';
import 'package:custome_mobile/views/screens/trader/trader_calculator_result_screen.dart';
import 'package:custome_mobile/views/widgets/custom_botton.dart';
import 'package:custome_mobile/views/widgets/highlight_text.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class CalculatorWidget extends StatefulWidget {
  GlobalKey<FormState> calformkey;

  TextEditingController? typeAheadController;

  TextEditingController? wieghtController;

  TextEditingController? originController;

  TextEditingController? valueController;
  bool? tariffButton;
  final Function()? unfocus;

  CalculatorWidget({
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
  State<CalculatorWidget> createState() => _CalculatorWidgetState();
}

class _CalculatorWidgetState extends State<CalculatorWidget> {
  String syrianExchangeValue = "30";

  String syrianTotalValue = "0";

  String totalValueWithEnsurance = "0";

  Package? selectedPackage;
  Origin? selectedOrigin;

  String wieghtUnit = "";
  String wieghtLabel = "الوزن";

  double usTosp = 30;
  double basePrice = 0;
  double wieghtValue = 0;
  var f = NumberFormat("#,###", "en_US");

  bool valueEnabled = true;
  bool allowexport = false;
  bool fillorigin = false;
  bool originerror = false;
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

  @override
  void initState() {
    super.initState();
    // FocusScope.of(context).unfocus();
  }

  void calculateTotalValueWithPrice() {
    var syrianExch = double.parse(widget.wieghtController!.text) *
        double.parse(widget.valueController!.text);
    var syrianTotal = syrianExch * 30;
    var totalEnsurance = (syrianTotal) + (syrianTotal * 0.0012);
    setState(() {
      syrianExchangeValue = syrianExch.round().toString();
      syrianTotalValue = syrianTotal.round().toString();
      totalValueWithEnsurance = totalEnsurance.round().toString();
    });
  }

  void calculateTotalValue() {
    var syrianTotal = double.parse(widget.valueController!.text) * 30;
    var totalEnsurance = (syrianTotal) + (syrianTotal * 0.0012);
    setState(() {
      syrianTotalValue = syrianTotal.round().toString();
      totalValueWithEnsurance = totalEnsurance.round().toString();
    });
  }

  void selectSuggestion(Package suggestion) {
    widget.typeAheadController!.text = suggestion.label!;
    selectedPackage = suggestion;
    if (suggestion.price! > 0) {
      basePrice = suggestion.price!;

      widget.valueController!.text = suggestion.price!.toString();
      setState(() {
        valueEnabled = false;
      });
    } else {
      setState(() {
        basePrice = 0.0;

        widget.valueController!.text = "0.0";
        valueEnabled = true;
        syrianExchangeValue = "30";
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
            wieghtLabel = "الوزن";
          });
          break;
        case "طن":
          setState(() {
            wieghtLabel = "الوزن";
          });
          break;
        case "قيراط":
          setState(() {
            wieghtLabel = "الوزن";
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
              syrianExchangeValue = "30";
            });
          }
        }
      }
      if (origin.countryGroups!.isEmpty) {
        setState(() {
          basePrice = 0.0;

          widget.valueController!.text = "0.0";
          valueEnabled = true;
          syrianExchangeValue = "30";
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
          widget.unfocus;
        },
        child: Form(
          key: widget.calformkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("نوع البضاعة",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(
                height: 15,
              ),
              Focus(
                focusNode: _statenode,
                onFocusChange: (bool focus) {
                  if (!focus) {
                    widget.unfocus;
                  }
                },
                child: TypeAheadField(
                  textFieldConfiguration: TextFieldConfiguration(
                    // autofocus: true,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: widget.typeAheadController,
                    scrollPadding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom + 150),
                    onTap: () {
                      // setSelectedPanel(2);
                      BlocProvider.of<BottomNavBarCubit>(context).emitHide();
                      widget.typeAheadController!.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset:
                              widget.typeAheadController!.value.text.length);
                    },

                    decoration: InputDecoration(
                      labelStyle: const TextStyle(fontSize: 18),
                      labelText: "  نوع البضاعة",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      contentPadding: EdgeInsets.zero,
                      suffixIcon: widget.tariffButton!
                          ? GestureDetector(
                              onTap: () {
                                BlocProvider.of<CalculatorPanelBloc>(context)
                                    .add(TariffPanelOpenEvent());
                                // BlocProvider.of<SectionBloc>(context)
                                //     .add(SectionLoadEvent());
                                widget.unfocus;
                              },
                              child: SizedBox(
                                width: 85.w,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "التعرفة الجمركية",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: AppColor.deepYellow,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : null,
                    ),
                    onSubmitted: (value) {
                      widget.unfocus;
                    },
                  ),
                  loadingBuilder: (context) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                  suggestionsCallback: (pattern) async {
                    if (pattern.isNotEmpty && pattern.length > 2) {
                      setState(() {
                        patternString = pattern;
                      });
                      return await CalculatorService.getpackages(pattern);
                    } else {
                      return [];
                    }
                  },
                  itemBuilder: (context, suggestion) {
                    return Column(
                      children: [
                        ListTile(
                          // leading: Icon(Icons.shopping_cart),
                          title: HighlightText(
                            text: suggestion.label!,
                            highlight: patternString,
                            ignoreCase: false,
                            highlightColor: Colors.orangeAccent,
                          ),
                          // subtitle: Text('\$${suggestion['price']}'),
                        ),
                        const Divider(),
                      ],
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    setState(() {
                      widget.wieghtController!.text = "0.0";
                      widget.valueController!.text = "0.0";
                      syrianExchangeValue = "0.0";
                      syrianTotalValue = "0.0";
                      totalValueWithEnsurance = "0.0";
                    });
                    selectSuggestion(suggestion);
                  },
                ),
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
                visible: isdropdwonVisible,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<Extras>(
                    isExpanded: true,
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
                            syrianExchangeValue = "30";
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
                            syrianExchangeValue = "30";
                          });
                        }
                        evaluatePrice();
                      }
                      setState(() {
                        selectedValue = value;
                      });
                    },
                    buttonStyleData: const ButtonStyleData(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      height: 40,
                      width: 140,
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 40,
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
              BlocBuilder<FlagsBloc, FlagsState>(
                builder: (context, flagstate) {
                  if (flagstate is FlagsLoadedSuccess) {
                    return DropdownButtonHideUnderline(
                      child: DropdownButton2<Origin>(
                        isExpanded: true,
                        hint: Text(
                          "  اختر المنشأ",
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
                                        SvgPicture.network(
                                          item.imageURL!,
                                          height: 35,
                                          // semanticsLabel: 'A shark?!',
                                          placeholderBuilder: (BuildContext
                                                  context) =>
                                              const CircularProgressIndicator(),
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
                                // setSelectedPanel(2);
                                BlocProvider.of<BottomNavBarCubit>(context)
                                    .emitHide();
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
                              onFieldSubmitted: (value) {
                                widget.unfocus;
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
                          width: double.infinity,
                          maxHeight: MediaQuery.of(context).size.height - 142.h,
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
                height: 24,
              ),

              Visibility(
                  visible: originerror,
                  child: const Text(
                    "الرجاء اختيار المنشأ",
                    style: TextStyle(color: Colors.red),
                  )),
              Visibility(
                visible: originerror,
                child: const SizedBox(
                  height: 24,
                ),
              ),
              Focus(
                focusNode: _statenode,
                onFocusChange: (bool focus) {
                  if (!focus) {
                    widget.unfocus;
                  }
                },
                child: TextFormField(
                  controller: widget.wieghtController!,
                  onTap: () {
                    BlocProvider.of<BottomNavBarCubit>(context).emitHide();
                    widget.wieghtController!.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset:
                            widget.wieghtController!.value.text.length);
                  },
                  // enabled: !valueEnabled,
                  scrollPadding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom + 50),
                  keyboardType: const TextInputType.numberWithOptions(
                      signed: true, decimal: true),
                  inputFormatters: [DecimalFormatter()],
                  decoration: InputDecoration(
                    labelStyle: const TextStyle(fontSize: 20),
                    labelText: wieghtLabel,
                    prefixText: showunit ? wieghtUnit : "",
                    prefixStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    contentPadding: EdgeInsets.zero,
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
                  onFieldSubmitted: (value) {
                    widget.unfocus;
                    BlocProvider.of<BottomNavBarCubit>(context).emitShow();
                  },
                ),
              ),

              const SizedBox(
                height: 24,
              ),
              Focus(
                focusNode: _statenode,
                onFocusChange: (bool focus) {
                  if (!focus) {
                    widget.unfocus;
                  }
                },
                child: TextFormField(
                  controller: widget.valueController!,
                  onTap: () {
                    BlocProvider.of<BottomNavBarCubit>(context).emitHide();
                    widget.valueController!.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset:
                            widget.valueController!.value.text.length);
                  },
                  // enabled: valueEnabled,
                  keyboardType: const TextInputType.numberWithOptions(
                      signed: true, decimal: true),
                  inputFormatters: [DecimalFormatter()],
                  scrollPadding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom + 50),
                  decoration: InputDecoration(
                    labelStyle: const TextStyle(fontSize: 18),
                    labelText: valueEnabled
                        ? "  قيمة البضاعة الاجمالية بالدولار"
                        : "  سعر الواحدة لدى الجمارك",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    contentPadding: EdgeInsets.zero,
                  ),
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
                    widget.unfocus;
                    BlocProvider.of<BottomNavBarCubit>(context).emitShow();
                  },
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Visibility(
                visible: isfeeequal001,
                child: CheckboxListTile(
                    value: rawMaterialValue,
                    title: const Text("هل المادة أولية؟"),
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
                    title: const Text("هل المادة صناعية؟"),
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
                    title: const Text("هل البضاعة ماركة؟"),
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
                    title: const Text("هل قياس الأنابيب أقل أو يساوي 3inch؟"),
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
                    title: const Text("هل الخيوط ملونة؟"),
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
                    title: const Text("هل الخيوط ليكرا؟"),
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
              Text(!valueEnabled
                  ? "القيمة الاجمالية بالدولار :"
                  : "قيمة التحويل بالجنيه المصري :"),
              Text(syrianExchangeValue),
              const Text("قيمة الاجمالية بالجنيه المصري: "),
              Text(syrianTotalValue),
              const Text("قيمة البضاعة مع التأمين: "),
              Text(totalValueWithEnsurance),
              const SizedBox(
                height: 12,
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
                                widget.unfocus;
                                result.insurance =
                                    int.parse(totalValueWithEnsurance);
                                result.fee = selectedPackage!.fee!;
                                result.rawMaterial = rawMaterialValue ? 1 : 0;
                                result.industrial = industrialValue ? 1 : 0;
                                result.totalTax =
                                    selectedPackage!.totalTaxes!.totalTax!;
                                result.partialTax =
                                    selectedPackage!.totalTaxes!.partialTax!;
                                result.origin = selectedOrigin!.label!;
                                result.spendingFee =
                                    selectedPackage!.spendingFee!;
                                result.supportFee =
                                    selectedPackage!.supportFee!;
                                result.localFee = selectedPackage!.localFee!;
                                result.protectionFee =
                                    selectedPackage!.protectionFee!;
                                result.naturalFee =
                                    selectedPackage!.naturalFee!;
                                result.taxFee = selectedPackage!.taxFee!;
                                BlocProvider.of<CalculateResultBloc>(context)
                                    .add(CalculateTheResultEvent(result));
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const TraderCalculatorResultScreen(),
                                    ));
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
