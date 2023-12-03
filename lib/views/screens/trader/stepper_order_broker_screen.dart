import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:custome_mobile/business_logic/bloc/agency_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/attachment_type_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/calculate_result_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/calculator_panel_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/fee_select_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/flags_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/package_type_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/state_custome_bloc.dart';
import 'package:custome_mobile/business_logic/cubit/bottom_nav_bar_cubit.dart';
import 'package:custome_mobile/data/models/package_model.dart';
import 'package:custome_mobile/data/models/state_custome_agency_model.dart';
import 'package:custome_mobile/data/services/calculator_service.dart';
import 'package:custome_mobile/helpers/color_constants.dart';
import 'package:custome_mobile/helpers/depouncer.dart';
import 'package:custome_mobile/helpers/formatter.dart';
import 'package:custome_mobile/views/screens/trader/trader_attachement_screen.dart';
import 'package:custome_mobile/views/screens/trader/trader_calculator_result_screen.dart';
import 'package:custome_mobile/views/widgets/custom_botton.dart';
import 'package:custome_mobile/views/widgets/highlight_text.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:ensure_visible_when_focused/ensure_visible_when_focused.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_img/flutter_img.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:shimmer/shimmer.dart';

class StepperOrderBrokerScreen extends StatefulWidget {
  const StepperOrderBrokerScreen({Key? key}) : super(key: key);

  @override
  State<StepperOrderBrokerScreen> createState() =>
      _StepperOrderBrokerScreenState();
}

class _StepperOrderBrokerScreenState extends State<StepperOrderBrokerScreen> {
  final GlobalKey<FormState> _ordercalformkey = GlobalKey<FormState>();
  final FocusNode _ordernode = FocusNode();
  final FocusNode _orderTypenode = FocusNode();
  final FocusNode _stateCustomenode = FocusNode();
  final GlobalKey<FormState> _packagesformkey = GlobalKey<FormState>();

  var key1 = GlobalKey();
  var key2 = GlobalKey();
  var key3 = GlobalKey();

  final TextEditingController _typeAheadController = TextEditingController();

  final TextEditingController _wieghtController = TextEditingController();

  final TextEditingController _originController = TextEditingController();

  final TextEditingController _valueController = TextEditingController();

  final TextEditingController _tabalehNumController = TextEditingController();

  final TextEditingController _packagesNumController = TextEditingController();

  final ScrollController _scrollController = ScrollController();
  String syrianExchangeValue = "6565";

  String syrianTotalValue = "0.0";

  String totalValueWithEnsurance = "0.0";
  String totalFees = "0.0";
  bool totalFeesloading = false;
  bool totalFeesdone = false;

  bool haveTabaleh = false;

  Package? selectedPackage;
  Origin? selectedOrigin;

  String wieghtUnit = "";
  String wieghtLabel = "الوزن";

  double usTosp = 6565;
  double basePrice = 0.0;
  double wieghtValue = 0.0;

  bool valueEnabled = true;
  bool allowexport = false;
  bool fillorigin = false;
  bool originerror = false;
  bool feeerror = false;
  bool isfeeequal001 = false;
  bool isBrand = false;
  bool brandValue = false;
  bool isTubes = false;
  bool tubesValue = false;
  bool rawMaterialValue = false;
  bool industrialValue = false;
  bool isLycra = false;
  bool lycraValue = false;
  bool isColored = false;
  bool colorValue = false;
  bool showunit = false;
  bool isdropdwonVisible = false;
  String _placeholder = "";

  CalculateObject result = CalculateObject();

  int agencyId = 0;
  int packageTypeId = 0;
  int packageNum = 0;
  int tabalehNum = 0;

  int selectedPanel = -1;
  bool showtypeError = false;
  String selectedRadioTile = "";
  bool selectedRadioTileError = false;
  bool selectedStateError = false;
  bool calculatorError = false;
  bool packageError = false;
  String statePlaceholder = "اختر مديرية";
  String agencyPlaceholder = "اختر أمانة";
  String originPlaceholder = "اختر المنشأ";
  var f = NumberFormat("#,###", "en_US");

  String patternString = "";

  final FocusNode _statenode = FocusNode();
  // final FocusNode _agencynode = FocusNode();
  @override
  void initState() {
    super.initState();
    _tabalehNumController.text = "0";
    BlocProvider.of<AttachmentTypeBloc>(context).add(AttachmentTypeLoadEvent());
    // FocusScope.of(context).unfocus();
  }

  void calculateTotalValueWithPrice() {
    var syrianExch = double.parse(_wieghtController.text) *
        double.parse(_valueController.text);
    var syrianTotal = syrianExch * 6565;
    var totalEnsurance = (syrianTotal) + (syrianTotal * 0.0012);
    setState(() {
      syrianExchangeValue = syrianExch.round().toString();
      syrianTotalValue = syrianTotal.round().toString();
      totalValueWithEnsurance = totalEnsurance.round().toString();
    });
  }

  void calculateTotalValue() {
    var syrianTotal = double.parse(_valueController.text) * 6565;
    var totalEnsurance = (syrianTotal) + (syrianTotal * 0.0012);
    setState(() {
      syrianTotalValue = syrianTotal.round().toString();
      totalValueWithEnsurance = totalEnsurance.round().toString();
    });
  }

  void selectSuggestion(Package suggestion) {
    _typeAheadController.text = suggestion.label!;
    selectedPackage = suggestion;
    setState(() {
      feeerror = false;
    });
    if (suggestion.price! > 0) {
      basePrice = suggestion.price!;

      _valueController.text = suggestion.price!.toString();
      setState(() {
        valueEnabled = false;
      });
    } else {
      setState(() {
        basePrice = 0.0;

        if (_valueController.text.isEmpty) {
          _valueController.text = "0.0";
        }
        valueEnabled = true;
        syrianExchangeValue = "6565";
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
        case "  كيلو واط بالساعة 1000":
          setState(() {
            wieghtLabel = "الاستطاعة";
          });
          break;
        case "  الاستطاعة بالطن":
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
    _originController.text = " ${origin.label!}";
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
              _valueController.text = element.price!.toString();
              basePrice = element.price!;

              setState(() {
                valueEnabled = false;
              });
              break outerLoop;
            }
          } else {
            setState(() {
              basePrice = 0.0;
              _valueController.text = "0.0";
              valueEnabled = true;
              syrianExchangeValue = "6565";
            });
          }
        }
      }
      if (origin.countryGroups!.isEmpty) {
        setState(() {
          basePrice = 0.0;

          _valueController.text = "0.0";
          valueEnabled = true;
          syrianExchangeValue = "6565";
        });
      }
    }
    evaluatePrice();
  }

  void calculateExtrasPrice(double percentage, bool add) {
    var price = 0.0;
    if (add) {
      price = double.parse(_valueController.text) + (basePrice * percentage);

      setState(() {
        _valueController.text = price.toString();
      });
    } else {
      price = double.parse(_valueController.text) - (basePrice * percentage);

      setState(() {
        _valueController.text = price.toString();
      });
    }
  }

  void evaluatePrice() {
    if (valueEnabled) {
      calculateTotalValue();
    } else {
      calculateTotalValueWithPrice();
    }
    calculateTheFees();
  }

  void calculateTheFees() {
    _ordercalformkey.currentState?.save();
    if (_ordercalformkey.currentState!.validate()) {
      setState(() {
        packageError = false;
      });
      // print(
      //     '$totalValueWithEnsurance\n${selectedPackage!.fee!}\n$rawMaterialValue\n$industrialValue\n${selectedPackage!.totalTaxes!.totalTax!}\n${selectedPackage!.totalTaxes!.partialTax!}\n${selectedOrigin!.label!}\n${selectedPackage!.spendingFee!}\n${selectedPackage!.supportFee!}\n${selectedPackage!.localFee!}\n${selectedPackage!.protectionFee!}\n${selectedPackage!.naturalFee!}${selectedPackage!.taxFee!}\n');
      result.insurance = int.parse(totalValueWithEnsurance);
      result.fee = selectedPackage!.fee!;
      result.rawMaterial = rawMaterialValue ? 1 : 0;
      result.industrial = industrialValue ? 1 : 0;
      result.totalTax = selectedPackage!.totalTaxes!.totalTax!;
      result.partialTax = selectedPackage!.totalTaxes!.partialTax!;
      result.origin = selectedOrigin!.label!;
      result.spendingFee = selectedPackage!.spendingFee!;
      result.supportFee = selectedPackage!.supportFee!;
      result.localFee = selectedPackage!.localFee!;
      result.protectionFee = selectedPackage!.protectionFee!;
      result.naturalFee = selectedPackage!.naturalFee!;
      result.taxFee = selectedPackage!.taxFee!;
      result.weight = wieghtValue.toInt();
      result.price = basePrice.toInt();
      result.cnsulate = 1;
      result.dolar = 6565;
      result.arabic_stamp = 650;
      result.import_fee = 0.01;
      BlocProvider.of<CalculateResultBloc>(context)
          .add(CalculateTheResultEvent(result));
    }
  }

  setSelectedRadioTile(String val) {
    setState(() {
      selectedRadioTile = val;
      selectedRadioTileError = false;
    });
  }

  setSelectedPanel(int val) {
    if (selectedPanel != val) {
      setState(() {
        selectedPanel = val;
      });
    }
  }

  List<Extras> items = [];
  Extras? selectedValue;

  StateCustome? selectedStateCustome;
  CustomeAgency? selectedCustomeAgency;
  final _debouncer = Debouncer(milliseconds: 1000);

  final FocusNode _nodeWeight = FocusNode();
  final FocusNode _nodeValue = FocusNode();

  final FocusNode _nodePackages = FocusNode();
  final FocusNode _nodeTabaleh = FocusNode();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocListener<FeeSelectBloc, FeeSelectState>(
        listener: (context, state) {
          if (state is FeeSelectSuccess) {
            setState(() {
              _wieghtController.text = "0.0";
              _valueController.text = "0.0";
              syrianExchangeValue = "6565";
              syrianTotalValue = "0.0";
              totalValueWithEnsurance = "0.0";
            });
            selectSuggestion(state.package);
          } else {
            // print("ghjhgjgh");
          }
        },
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
            BlocProvider.of<BottomNavBarCubit>(context).emitShow();
          },
          child: Column(
            children: [
              // SizedBox(
              //   height: 96.h,
              //   child: Theme(
              //     data: ThemeData(
              //       // accentColor: Colors.orange,
              //       colorScheme: ColorScheme.light(
              //         primary: AppColor.deepBlue,
              //       ),
              //     ),
              //     child: Stepper(
              //       type: StepperType.horizontal,
              //       steps: [
              //         Step(
              //             isActive: true,
              //             title: Text(
              //               "معلومات الشحنة",
              //               style: TextStyle(fontSize: 12.sp),
              //             ),
              //             content: const SizedBox.shrink()),
              //         Step(
              //             isActive: false,
              //             title: GestureDetector(
              //               onTap: () {
              //                 var snackBar = SnackBar(
              //                   elevation: 0,
              //                   duration: const Duration(seconds: 4),
              //                   backgroundColor: Colors.transparent,
              //                   content: Column(
              //                     children: [
              //                       AwesomeSnackbarContent(
              //                         title: 'تنبيه',
              //                         message:
              //                             'لا يمكن الانتقال إلى هذه الشاشة إلا بعد اكمال ادخال البيانات اللازمة.',

              //                         /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
              //                         contentType: ContentType.warning,
              //                       ),
              //                       SizedBox(
              //                         height: 90.h,
              //                       ),
              //                     ],
              //                   ),
              //                 );

              //                 ScaffoldMessenger.of(context)
              //                     .showSnackBar(snackBar);
              //               },
              //               child: Text(
              //                 "المرفقات",
              //                 style: TextStyle(fontSize: 12.sp),
              //               ),
              //             ),
              //             content: const SizedBox.shrink()),
              //         Step(
              //             isActive: false,
              //             title: GestureDetector(
              //               onTap: () {
              //                 var snackBar = SnackBar(
              //                   elevation: 0,
              //                   duration: const Duration(seconds: 4),
              //                   backgroundColor: Colors.transparent,
              //                   content: Column(
              //                     children: [
              //                       AwesomeSnackbarContent(
              //                         title: 'تنبيه',
              //                         message:
              //                             'لا يمكن الانتقال إلى هذه الشاشة إلا بعد اكمال ادخال البيانات اللازمة.',

              //                         /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
              //                         contentType: ContentType.warning,
              //                       ),
              //                       SizedBox(
              //                         height: 90.h,
              //                       ),
              //                     ],
              //                   ),
              //                 );

              //                 ScaffoldMessenger.of(context)
              //                     .showSnackBar(snackBar);
              //               },
              //               child: Text(
              //                 "تم",
              //                 style: TextStyle(fontSize: 12.sp),
              //               ),
              //             ),
              //             content: const SizedBox.shrink()),
              //       ],
              //       currentStep: 1,
              //       controlsBuilder: (context, details) {
              //         return const SizedBox.shrink();
              //       },
              //       onStepContinue: () => setState(() {}),
              //       onStepCancel: () => setState(() {}),
              //     ),
              //   ),
              // ),
              // SizedBox(height: 96.h,
              // child:Row(children: [
              //   TimelineTile(

              //   )
              // ],) ,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  EnsureVisibleWhenFocused(
                    focusNode: _orderTypenode,
                    child: Card(
                      key: key1,
                      margin: const EdgeInsets.symmetric(vertical: 7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: selectedPanel == 0
                              ? selectedRadioTileError
                                  ? LinearGradient(
                                      colors: [
                                          Colors.red[300]!,
                                          Colors.white,
                                          Colors.white,
                                          Colors.white,
                                        ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter)
                                  : LinearGradient(
                                      colors: [
                                          AppColor.goldenYellow,
                                          Colors.white,
                                          Colors.white,
                                          Colors.white,
                                        ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter)
                              : null,
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("اختر نوع العملية",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.deepBlue,
                                  )),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .38,
                                child: RadioListTile(
                                  value: "I",
                                  groupValue: selectedRadioTile,
                                  title: const Text(
                                    "استيراد",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  // subtitle: Text("Radio 1 Subtitle"),
                                  onChanged: (val) {
                                    // print("Radio Tile pressed $val");
                                    setSelectedPanel(0);
                                    setSelectedRadioTile(val!);
                                  },
                                  activeColor: AppColor.goldenYellow,
                                  selected: selectedRadioTile == "I",
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .38,
                                child: RadioListTile(
                                  value: "E",
                                  groupValue: selectedRadioTile,
                                  title: const Text(
                                    "تصدير",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  // subtitle: Text("Radio 2 Subtitle"),
                                  onChanged: (val) {
                                    // print("Radio Tile pressed $val");
                                    setSelectedPanel(0);
                                    setSelectedRadioTile(val!);
                                  },
                                  activeColor: AppColor.goldenYellow,

                                  selected: selectedRadioTile == "E",
                                ),
                              )
                            ],
                          ),
                          Visibility(
                              visible: showtypeError,
                              child: const Text("الرجاء اختيار نوع العملية",
                                  style: TextStyle(color: Colors.red)))
                        ]),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: selectedRadioTileError,
                    child: const Padding(
                      padding: EdgeInsets.only(
                          top: 2.0, bottom: 8.0, right: 25.0, left: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "الرجاء اختيار نوع العملية",
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  EnsureVisibleWhenFocused(
                    focusNode: _stateCustomenode,
                    child: Card(
                      key: key2,
                      margin: const EdgeInsets.symmetric(vertical: 7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        width: double.infinity,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: selectedPanel == 1
                              ? selectedStateError
                                  ? LinearGradient(
                                      colors: [
                                          Colors.red[300]!,
                                          Colors.white,
                                          Colors.white,
                                          Colors.white,
                                          Colors.white,
                                        ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter)
                                  : LinearGradient(
                                      colors: [
                                          AppColor.goldenYellow,
                                          Colors.white,
                                          Colors.white,
                                          Colors.white,
                                          Colors.white,
                                        ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter)
                              : null,
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("الأمانة الجمركية",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.deepBlue,
                                  )),
                              const SizedBox(
                                height: 15,
                              ),
                              BlocBuilder<StateCustomeBloc, StateCustomeState>(
                                builder: (context, state) {
                                  if (state is StateCustomeLoadedSuccess) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        DropdownButtonHideUnderline(
                                          child: Focus(
                                            focusNode: _statenode,
                                            onFocusChange: (bool focus) {
                                              if (focus) {
                                                setSelectedPanel(1);
                                              }
                                            },
                                            child:
                                                DropdownButton2<StateCustome>(
                                              isExpanded: true,
                                              barrierLabel: statePlaceholder,
                                              hint: Text(
                                                statePlaceholder,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Theme.of(context)
                                                      .hintColor,
                                                ),
                                              ),
                                              items: state.states
                                                  .map((StateCustome item) =>
                                                      DropdownMenuItem<
                                                          StateCustome>(
                                                        value: item,
                                                        child: Text(
                                                          item.name!,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 17,
                                                          ),
                                                        ),
                                                      ))
                                                  .toList(),
                                              value: selectedStateCustome,
                                              onChanged: (StateCustome? value) {
                                                BlocProvider.of<AgencyBloc>(
                                                        context)
                                                    .add(AgenciesLoadEvent(
                                                        value!.id!));
                                                setState(() {
                                                  selectedStateCustome = value;
                                                  selectedCustomeAgency = null;
                                                });
                                              },
                                              buttonStyleData: ButtonStyleData(
                                                height: 50,
                                                width: double.infinity,

                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 9.0,
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color: Colors.black26,
                                                  ),
                                                  color: Colors.white,
                                                ),
                                                // elevation: 2,
                                              ),
                                              iconStyleData:
                                                  const IconStyleData(
                                                icon: Icon(
                                                  Icons
                                                      .keyboard_arrow_down_sharp,
                                                ),
                                                iconSize: 20,
                                                iconEnabledColor:
                                                    AppColor.AccentBlue,
                                                iconDisabledColor: Colors.grey,
                                              ),
                                              dropdownStyleData:
                                                  DropdownStyleData(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                  color: Colors.white,
                                                ),
                                                scrollbarTheme:
                                                    ScrollbarThemeData(
                                                  radius:
                                                      const Radius.circular(40),
                                                  thickness:
                                                      MaterialStateProperty.all(
                                                          6),
                                                  thumbVisibility:
                                                      MaterialStateProperty.all(
                                                          true),
                                                ),
                                              ),
                                              menuItemStyleData:
                                                  MenuItemStyleData(
                                                height: 40.h,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 24,
                                        ),
                                        BlocBuilder<AgencyBloc, AgencyState>(
                                          builder: (context, state2) {
                                            if (state2 is AgencyLoadedSuccess) {
                                              return DropdownButtonHideUnderline(
                                                child: Focus(
                                                  focusNode: _statenode,
                                                  onFocusChange: (bool focus) {
                                                    if (focus) {
                                                      setSelectedPanel(1);
                                                    }
                                                  },
                                                  child: DropdownButton2<
                                                      CustomeAgency>(
                                                    isExpanded: true,
                                                    hint: Text(
                                                      agencyPlaceholder,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        color: Theme.of(context)
                                                            .hintColor,
                                                      ),
                                                    ),
                                                    items: state2.agencies
                                                        .map((CustomeAgency
                                                                item) =>
                                                            DropdownMenuItem<
                                                                CustomeAgency>(
                                                              value: item,
                                                              child: SizedBox(
                                                                width: 200,
                                                                child: Text(
                                                                  item.name!,
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        17,
                                                                  ),
                                                                ),
                                                              ),
                                                            ))
                                                        .toList(),
                                                    value:
                                                        selectedCustomeAgency,
                                                    onChanged:
                                                        (CustomeAgency? value) {
                                                      setState(() {
                                                        selectedCustomeAgency =
                                                            value;
                                                        selectedStateError =
                                                            false;
                                                      });
                                                    },
                                                    buttonStyleData:
                                                        ButtonStyleData(
                                                      height: 50,
                                                      width: double.infinity,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 9.0,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        border: Border.all(
                                                          color: Colors.black26,
                                                        ),
                                                        color: Colors.white,
                                                      ),
                                                      // elevation: 2,
                                                    ),
                                                    iconStyleData:
                                                        const IconStyleData(
                                                      icon: Icon(
                                                        Icons
                                                            .keyboard_arrow_down_sharp,
                                                      ),
                                                      iconSize: 20,
                                                      iconEnabledColor:
                                                          AppColor.AccentBlue,
                                                      iconDisabledColor:
                                                          Colors.grey,
                                                    ),
                                                    dropdownStyleData:
                                                        DropdownStyleData(
                                                      decoration: BoxDecoration(
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
                                                ),
                                              );
                                            } else if (state2
                                                is AgencyLoadingProgress) {
                                              return const Center(
                                                child:
                                                    LinearProgressIndicator(),
                                              );
                                            } else if (state
                                                is AgencyLoadedFailed) {
                                              return Center(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    BlocProvider.of<AgencyBloc>(
                                                            context)
                                                        .add(AgenciesLoadEvent(
                                                            selectedStateCustome!
                                                                .id!));
                                                  },
                                                  child: const Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "حدث خطأأثناء تحميل القائمة...  ",
                                                        style: TextStyle(
                                                            color: Colors.red),
                                                      ),
                                                      Icon(
                                                        Icons.refresh,
                                                        color: Colors.grey,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return Container();
                                            }
                                          },
                                        ),
                                      ],
                                    );
                                  } else if (state
                                      is StateCustomeLoadedFailed) {
                                    return Center(
                                      child: GestureDetector(
                                        onTap: () {
                                          BlocProvider.of<StateCustomeBloc>(
                                                  context)
                                              .add(StateCustomeLoadEvent());
                                        },
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "حدث خطأأثناء تحميل القائمة...  ",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                            Icon(
                                              Icons.refresh,
                                              color: Colors.grey,
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  } else {
                                    return const Center(
                                      child: LinearProgressIndicator(),
                                    );
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 7,
                              ),
                            ]),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: selectedStateError,
                    child: const Padding(
                      padding: EdgeInsets.only(
                          top: 2.0, bottom: 8.0, right: 25.0, left: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "الرجاء اختيار الأمانة الجمركية",
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    key: key3,
                    margin: const EdgeInsets.symmetric(vertical: 7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      // margin: const EdgeInsets.symmetric(vertical: 7),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: selectedPanel == 2
                            ? calculatorError
                                ? LinearGradient(
                                    colors: [
                                        Colors.red[300]!,
                                        Colors.white,
                                        Colors.white,
                                        Colors.white,
                                        Colors.white,
                                        Colors.white,
                                        Colors.white,
                                        Colors.white,
                                        Colors.white,
                                        Colors.white,
                                      ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter)
                                : LinearGradient(
                                    colors: [
                                        AppColor.goldenYellow,
                                        Colors.white,
                                        Colors.white,
                                        Colors.white,
                                        Colors.white,
                                        Colors.white,
                                        Colors.white,
                                        Colors.white,
                                        Colors.white,
                                        Colors.white,
                                      ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter)
                            : null,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          key: _ordercalformkey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Focus(
                                    focusNode: _ordernode,
                                    child: Text("تفاصيل البضاعة",
                                        style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold,
                                          color: AppColor.deepBlue,
                                        )),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      BlocProvider.of<CalculatorPanelBloc>(
                                              context)
                                          .add(TariffPanelOpenEvent());
                                      // BlocProvider.of<SectionBloc>(context)
                                      //     .add(SectionLoadEvent());
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      BlocProvider.of<BottomNavBarCubit>(
                                              context)
                                          .emitShow();
                                    },
                                    child: SizedBox(
                                      height: 40.h,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
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
                                  ),
                                ],
                              ),

                              Focus(
                                focusNode: _statenode,
                                onFocusChange: (bool focus) {
                                  if (!focus) {
                                    BlocProvider.of<BottomNavBarCubit>(context)
                                        .emitShow();
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  }
                                },
                                child: TypeAheadField(
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
                                    // autofocus: true,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    controller: _typeAheadController,
                                    scrollPadding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom +
                                            150),
                                    onTap: () {
                                      setSelectedPanel(2);
                                      BlocProvider.of<BottomNavBarCubit>(
                                              context)
                                          .emitHide();
                                      _typeAheadController.selection =
                                          TextSelection(
                                              baseOffset: 0,
                                              extentOffset: _typeAheadController
                                                  .value.text.length);
                                    },
                                    style: const TextStyle(fontSize: 17),
                                    decoration: const InputDecoration(
                                      labelText: "نوع البضاعة",
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 11.0, horizontal: 9.0),
                                    ),
                                    onSubmitted: (value) {
                                      BlocProvider.of<BottomNavBarCubit>(
                                              context)
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
                                  suggestionsCallback: (pattern) async {
                                    // _debouncer.run(() {

                                    // });
                                    setState(() {
                                      patternString = pattern;
                                    });
                                    return await CalculatorService.getpackages(
                                        pattern);
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
                                              highlightColor:
                                                  AppColor.goldenYellow,
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
                                    setState(() {
                                      _wieghtController.text = "";
                                      _valueController.text = "";
                                      syrianExchangeValue = "6565";
                                      syrianTotalValue = "0.0";
                                      totalValueWithEnsurance = "0.0";
                                    });
                                    selectSuggestion(suggestion);
                                    BlocProvider.of<BottomNavBarCubit>(context)
                                        .emitShow();
                                    // Navigator.of(context).push(MaterialPageRoute(
                                    //   builder: (context) => ProductPage(product: suggestion)
                                    // ));
                                  },
                                ),
                              ),
                              Visibility(
                                visible: allowexport,
                                child: const SizedBox(
                                  height: 7,
                                ),
                              ),
                              Visibility(
                                visible: allowexport,
                                child: const Text(
                                  "   هذا البند ممنوع من الاستيراد",
                                  style: TextStyle(color: Colors.red),
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
                              const SizedBox(
                                height: 24,
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
                                        .map((Extras item) =>
                                            DropdownMenuItem<Extras>(
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

                                          _valueController.text =
                                              value.price!.toString();
                                          setState(() {
                                            valueEnabled = false;
                                          });
                                        } else {
                                          setState(() {
                                            basePrice = 0.0;

                                            _valueController.text = "0.0";
                                            valueEnabled = true;
                                            syrianExchangeValue = "6565";
                                          });
                                        }
                                        evaluatePrice();
                                      } else {
                                        if (value.price! > 0) {
                                          basePrice = value.price!;

                                          _valueController.text =
                                              value.price!.toString();
                                          setState(() {
                                            valueEnabled = false;
                                          });
                                        } else {
                                          setState(() {
                                            basePrice = 0.0;

                                            _valueController.text = "0.0";
                                            valueEnabled = true;
                                            syrianExchangeValue = "6565";
                                          });
                                        }
                                        evaluatePrice();
                                      }
                                      setState(() {
                                        selectedValue = value;
                                      });
                                    },
                                    buttonStyleData: const ButtonStyleData(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
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
                                    return DropdownSearch<Origin>(
                                      popupProps: PopupProps.modalBottomSheet(
                                        showSearchBox: true,

                                        itemBuilder:
                                            (context, item, isSelected) {
                                          return Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12.w),
                                            // width: 200,
                                            child: Row(
                                              children: [
                                                SvgPicture.network(
                                                  item.imageURL!,
                                                  height: 45.h,
                                                  width: 55.w,
                                                  placeholderBuilder:
                                                      (context) => Container(
                                                    height: 45.h,
                                                    width: 55.w,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[200],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Container(
                                                  constraints: BoxConstraints(
                                                    maxWidth: 280.w,
                                                  ),
                                                  child: Text(
                                                    item.label!,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    // maxLines: 2,
                                                    style: const TextStyle(
                                                      fontSize: 19,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                              // subtitle: Text('\$${suggestion['price']}'),
                                            ),
                                          );
                                        },
                                        modalBottomSheetProps:
                                            const ModalBottomSheetProps(
                                          padding: EdgeInsets.all(8),
                                        ),

                                        containerBuilder:
                                            (context, popupWidget) {
                                          return Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height -
                                                50.h,
                                            padding: const EdgeInsets.all(8),
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.zero,
                                            ),
                                            child: popupWidget,
                                          );
                                        },
                                        // title: Text("اختر المنشأ"),
                                      ),
                                      items: flagstate.origins,
                                      dropdownDecoratorProps:
                                          const DropDownDecoratorProps(
                                        dropdownSearchDecoration:
                                            InputDecoration(
                                          // labelText: "اختر المنشأ",
                                          hintText: "اختر المنشأ من القائمة",
                                        ),
                                      ),
                                      dropdownBuilder: (context, selectedItem) {
                                        return selectedItem != null
                                            ? Row(
                                                children: [
                                                  SvgPicture.network(
                                                    selectedItem!.imageURL!,
                                                    height: 35.h,
                                                    width: 45.w,
                                                    placeholderBuilder:
                                                        (context) => Container(
                                                      height: 35.h,
                                                      width: 45.w,
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[200],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Container(
                                                    constraints: BoxConstraints(
                                                      maxWidth: 280.w,
                                                    ),
                                                    child: Text(
                                                      selectedItem!.label!,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      // maxLines: 2,
                                                      style: const TextStyle(
                                                        fontSize: 19,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                                // subtitle: Text('\$${suggestion['price']}'),
                                              )
                                            : Text(
                                                "اختر المنشأ",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.grey[600]!),
                                              );
                                      },
                                      dropdownButtonProps:
                                          const DropdownButtonProps(
                                        icon: Icon(
                                          Icons.keyboard_arrow_down_sharp,
                                          color: AppColor.AccentBlue,
                                        ),
                                        iconSize: 20,
                                      ),
                                      filterFn: (item, filter) {
                                        return item.label!.contains(filter);
                                      },
                                      onChanged: (value) {
                                        selectOrigin(value!);
                                      },
                                      selectedItem: selectedOrigin,
                                    );
                                  } else if (flagstate
                                      is FlagsLoadingProgressState) {
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "حدث خطأأثناء تحميل القائمة...  ",
                                              style:
                                                  TextStyle(color: Colors.red),
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

                              // BlocBuilder<FlagsBloc, FlagsState>(
                              //   builder: (context, flagstate) {
                              //     if (flagstate is FlagsLoadedSuccess) {
                              //       return DropdownButtonHideUnderline(
                              //         child: Focus(
                              //           focusNode: _statenode,
                              //           onFocusChange: (bool focus) {
                              //             if (focus) {
                              //               setSelectedPanel(2);
                              //             }
                              //           },
                              //           child: DropdownButton2<Origin>(
                              //             isExpanded: true,
                              //             hint: Text(
                              //               originPlaceholder,
                              //               style: TextStyle(
                              //                 fontSize: 18,
                              //                 color:
                              //                     Theme.of(context).hintColor,
                              //               ),
                              //             ),
                              //             items: flagstate.origins
                              //                 .map((Origin item) =>
                              //                     DropdownMenuItem<Origin>(
                              //                       value: item,
                              //                       child: SizedBox(
                              //                         // width: 200,
                              //                         child: Row(
                              //                           children: [
                              //                             SvgPicture.network(
                              //                               item.imageURL!,
                              //                               height: 35.h,
                              //                               width: 45.w,
                              //                               placeholderBuilder:
                              //                                   (context) =>
                              //                                       Container(
                              //                                 height: 35.h,
                              //                                 width: 45.w,
                              //                                 decoration:
                              //                                     BoxDecoration(
                              //                                   color: Colors
                              //                                       .grey[200],
                              //                                   borderRadius:
                              //                                       BorderRadius
                              //                                           .circular(
                              //                                               5),
                              //                                 ),
                              //                               ),
                              //                             ),
                              //                             const SizedBox(
                              //                                 width: 7),
                              //                             Container(
                              //                               constraints:
                              //                                   BoxConstraints(
                              //                                 maxWidth: 280.w,
                              //                               ),
                              //                               child: Text(
                              //                                 item.label!,
                              //                                 overflow:
                              //                                     TextOverflow
                              //                                         .ellipsis,
                              //                                 // maxLines: 2,
                              //                                 style:
                              //                                     const TextStyle(
                              //                                   fontSize: 17,
                              //                                 ),
                              //                               ),
                              //                             ),
                              //                           ],
                              //                           // subtitle: Text('\$${suggestion['price']}'),
                              //                         ),
                              //                       ),
                              //                     ))
                              //                 .toList(),
                              //             value: selectedOrigin,
                              //             onChanged: (Origin? value) {
                              //               // setState(() {
                              //               //   selectedOrigin = value;
                              //               // });
                              //               selectOrigin(value!);
                              //             },
                              //             dropdownSearchData:
                              //                 DropdownSearchData(
                              //               searchController: _originController,
                              //               searchInnerWidgetHeight: 60,
                              //               searchInnerWidget: Container(
                              //                 height: 60,
                              //                 padding: const EdgeInsets.only(
                              //                   top: 8,
                              //                   bottom: 4,
                              //                   right: 8,
                              //                   left: 8,
                              //                 ),
                              //                 child: TextFormField(
                              //                   expands: true,
                              //                   maxLines: null,
                              //                   controller: _originController,
                              //                   onTap: () {
                              //                     setSelectedPanel(2);

                              //                     _originController.selection =
                              //                         TextSelection(
                              //                             baseOffset: 0,
                              //                             extentOffset:
                              //                                 _originController
                              //                                     .value
                              //                                     .text
                              //                                     .length);
                              //                   },
                              //                   decoration: InputDecoration(
                              //                     isDense: true,
                              //                     contentPadding:
                              //                         const EdgeInsets
                              //                             .symmetric(
                              //                       horizontal: 10,
                              //                       vertical: 8,
                              //                     ),
                              //                     hintText: 'اختر المنشأ',
                              //                     hintStyle: const TextStyle(
                              //                         fontSize: 12),
                              //                     border: OutlineInputBorder(
                              //                       borderRadius:
                              //                           BorderRadius.circular(
                              //                               8),
                              //                     ),
                              //                   ),
                              //                   onFieldSubmitted: (value) {
                              //                     BlocProvider.of<
                              //                                 BottomNavBarCubit>(
                              //                             context)
                              //                         .emitShow();
                              //                   },
                              //                 ),
                              //               ),
                              //               searchMatchFn: (item, searchValue) {
                              //                 return item.value!.label!
                              //                     .contains(searchValue);
                              //               },
                              //             ),
                              //             onMenuStateChange: (isOpen) {
                              //               if (isOpen) {
                              //                 setState(() {
                              //                   _originController.clear();
                              //                 });
                              //               }
                              //             },
                              //             buttonStyleData: ButtonStyleData(
                              //               height: 50,
                              //               width: double.infinity,
                              //               padding: const EdgeInsets.symmetric(
                              //                 horizontal: 9.0,
                              //               ),

                              //               decoration: BoxDecoration(
                              //                 borderRadius:
                              //                     BorderRadius.circular(12),
                              //                 border: Border.all(
                              //                   color: Colors.black26,
                              //                 ),
                              //                 color: Colors.white,
                              //               ),
                              //               // elevation: 2,
                              //             ),
                              //             iconStyleData: const IconStyleData(
                              //               icon: Icon(
                              //                 Icons.keyboard_arrow_down_sharp,
                              //               ),
                              //               iconSize: 20,
                              //               iconEnabledColor:
                              //                   AppColor.AccentBlue,
                              //               iconDisabledColor: Colors.grey,
                              //             ),
                              //             dropdownStyleData: DropdownStyleData(
                              //               width: double.infinity,
                              //               maxHeight: MediaQuery.of(context)
                              //                       .size
                              //                       .height *
                              //                   .85,
                              //               padding: const EdgeInsets.all(8.0),
                              //               decoration: BoxDecoration(
                              //                 borderRadius:
                              //                     BorderRadius.circular(14),
                              //                 color: Colors.white,
                              //               ),
                              //               scrollbarTheme: ScrollbarThemeData(
                              //                 radius: const Radius.circular(40),
                              //                 thickness:
                              //                     MaterialStateProperty.all(6),
                              //                 thumbVisibility:
                              //                     MaterialStateProperty.all(
                              //                         true),
                              //               ),
                              //             ),
                              //             menuItemStyleData:
                              //                 const MenuItemStyleData(
                              //               height: 40,
                              //             ),
                              //           ),
                              //         ),
                              //       );
                              //     } else if (flagstate
                              //         is FlagsLoadingProgressState) {
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
                              //             mainAxisAlignment:
                              //                 MainAxisAlignment.center,
                              //             children: [
                              //               Text(
                              //                 "حدث خطأأثناء تحميل القائمة...  ",
                              //                 style:
                              //                     TextStyle(color: Colors.red),
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
                              const SizedBox(
                                height: 24,
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
                              Focus(
                                focusNode: _statenode,
                                onFocusChange: (bool focus) {
                                  if (!focus) {
                                    BlocProvider.of<BottomNavBarCubit>(context)
                                        .emitShow();
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  }
                                },
                                child: TextFormField(
                                  controller: _wieghtController,
                                  onTap: () {
                                    setSelectedPanel(2);

                                    BlocProvider.of<BottomNavBarCubit>(context)
                                        .emitHide();
                                    _wieghtController.selection = TextSelection(
                                        baseOffset: 0,
                                        extentOffset: _wieghtController
                                            .value.text.length);
                                  },
                                  focusNode: _nodeWeight,
                                  // enabled: !valueEnabled,
                                  scrollPadding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom +
                                          50),
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          signed: true, decimal: true),
                                  inputFormatters: [DecimalFormatter()],
                                  decoration: InputDecoration(
                                    labelText: wieghtLabel,
                                    prefixText: showunit ? wieghtUnit : "",
                                    prefixStyle:
                                        const TextStyle(color: Colors.black),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 11.0, horizontal: 9.0),
                                  ),
                                  onChanged: (value) {
                                    if (_originController.text.isNotEmpty) {
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
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "الرجاء ادخال القيمة";
                                    }
                                    return null;
                                  },
                                  onSaved: (newValue) {
                                    _wieghtController.text = newValue!;
                                  },
                                  onFieldSubmitted: (value) {
                                    BlocProvider.of<BottomNavBarCubit>(context)
                                        .emitShow();
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
                                    BlocProvider.of<BottomNavBarCubit>(context)
                                        .emitShow();
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  }
                                },
                                child: TextFormField(
                                  controller: _valueController,
                                  onTap: () {
                                    BlocProvider.of<BottomNavBarCubit>(context)
                                        .emitHide();
                                    _valueController.selection = TextSelection(
                                        baseOffset: 0,
                                        extentOffset:
                                            _valueController.value.text.length);
                                  },
                                  focusNode: _nodeValue,
                                  // enabled: valueEnabled,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          signed: true, decimal: true),
                                  scrollPadding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom +
                                          50),
                                  inputFormatters: [DecimalFormatter()],
                                  decoration: InputDecoration(
                                    labelText: valueEnabled
                                        ? "قيمة البضاعة الاجمالية بالدولار"
                                        : "سعر الواحدة لدى الجمارك",
                                  ),
                                  onChanged: (value) {
                                    if (_originController.text.isNotEmpty) {
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
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "الرجاء ادخال القيمة";
                                    }
                                    return null;
                                  },
                                  onSaved: (newValue) {
                                    _valueController.text = newValue!;
                                  },
                                  onFieldSubmitted: (value) {
                                    BlocProvider.of<BottomNavBarCubit>(context)
                                        .emitShow();
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
                                    title: const Text(
                                        "هل قياس الأنابيب أقل أو يساوي 3inch؟"),
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
                              Text(
                                !valueEnabled
                                    ? "القيمة الاجمالية بالدولار :"
                                    : "قيمة التحويل بالجنيه المصري :",
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(f.format(
                                  double.parse(syrianExchangeValue).toInt())),
                              const Text(
                                "قيمة الاجمالية بالجنيه المصري: ",
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(f.format(
                                  double.parse(syrianTotalValue).toInt())),
                              const Text(
                                "قيمة البضاعة مع التأمين: ",
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(f.format(
                                  double.parse(totalValueWithEnsurance)
                                      .toInt())),
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "الرسوم :  ",
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: AppColor.deepBlue,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 230.w,
                                        child: BlocBuilder<CalculateResultBloc,
                                            CalculateResultState>(
                                          builder: (context, state) {
                                            if (state
                                                    is CalculateResultSuccessed &&
                                                totalValueWithEnsurance !=
                                                    "0.0") {
                                              return Text(
                                                f.format(state
                                                    .result.finalTotal!
                                                    .toInt()),
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            } else if (state
                                                is CalculateResultLoading) {
                                              return const LinearProgressIndicator();
                                            } else {
                                              return const Text(
                                                " _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ ",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  BlocBuilder<CalculateResultBloc,
                                      CalculateResultState>(
                                    builder: (context, state) {
                                      if (state is CalculateResultSuccessed &&
                                          totalValueWithEnsurance != "0.0") {
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    TraderCalculatorResultScreen(),
                                              ),
                                            );
                                          },
                                          child: SizedBox(
                                            height: 50,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "تفاصيل الرسوم",
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                    color: AppColor.deepBlue,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      } else {
                                        return const SizedBox.shrink();
                                      }
                                    },
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: selectedPanel == 3
                            ? LinearGradient(
                                colors: [
                                    AppColor.goldenYellow,
                                    Colors.white,
                                    Colors.white,
                                    Colors.white,
                                    Colors.white,
                                    Colors.white,
                                    Colors.white,
                                    Colors.white,
                                    Colors.white,
                                    Colors.white,
                                  ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter)
                            : null,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 2.h,
                          ),
                          Text(
                            "نوع الطرد",
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
                                  if (state is PackageTypeLoadedSuccess) {
                                    return Scrollbar(
                                      controller: _scrollController,
                                      thumbVisibility: true,
                                      thickness: 2.0,
                                      child: Padding(
                                        padding: EdgeInsets.all(2.h),
                                        child: ListView.builder(
                                          controller: _scrollController,
                                          itemCount: state.packageTypes.length,
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5.w,
                                                  vertical: 15.h),
                                              child: GestureDetector(
                                                onTap: () {
                                                  setSelectedPanel(3);
                                                  setState(() {
                                                    packageTypeId = state
                                                        .packageTypes[index]
                                                        .id!;
                                                  });
                                                },
                                                child: Stack(
                                                  clipBehavior: Clip.none,
                                                  children: [
                                                    Container(
                                                      width: 145.w,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(7),
                                                        border: Border.all(
                                                          color: packageTypeId ==
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
                                                          SvgPicture.network(
                                                            state
                                                                .packageTypes[
                                                                    index]
                                                                .image!,
                                                            height: 50.h,
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
                                                            style: TextStyle(
                                                              fontSize: 17.sp,
                                                              color: AppColor
                                                                  .deepBlue,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    packageTypeId ==
                                                            state
                                                                .packageTypes[
                                                                    index]
                                                                .id!
                                                        ? Positioned(
                                                            right: -7.w,
                                                            top: -10.h,
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(2),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: AppColor
                                                                    .goldenYellow,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            45),
                                                              ),
                                                              child: Icon(
                                                                  Icons.check,
                                                                  size: 16.w,
                                                                  color: Colors
                                                                      .white),
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
                                      highlightColor: (Colors.grey[100])!,
                                      enabled: true,
                                      direction: ShimmerDirection.rtl,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (_, __) => Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5.w, vertical: 15.h),
                                          child: Container(
                                            clipBehavior: Clip.antiAlias,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                          SizedBox(
                            height: 7.h,
                          ),
                          const Divider(),
                          SizedBox(
                            height: 7.h,
                          ),
                          Form(
                            key: _packagesformkey,
                            child: TextFormField(
                              controller: _packagesNumController,
                              textAlign: TextAlign.center,
                              focusNode: _nodePackages,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true, signed: true),
                              inputFormatters: [DecimalFormatter()],
                              style: const TextStyle(fontSize: 17),
                              decoration: const InputDecoration(
                                labelText: "عدد الطرود",
                              ),
                              scrollPadding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom +
                                          50),
                              onTap: () {
                                setSelectedPanel(2);
                                BlocProvider.of<BottomNavBarCubit>(context)
                                    .emitHide();
                                _packagesNumController.selection =
                                    TextSelection(
                                        baseOffset: 0,
                                        extentOffset: _packagesNumController
                                            .value.text.length);
                              },
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  setState(() {
                                    _packagesNumController.text = "0";
                                    packageNum = 0;
                                  });
                                } else {
                                  packageNum = int.parse(
                                      double.parse(_packagesNumController.text)
                                          .toInt()
                                          .toString());
                                }
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value!.isEmpty || value == "0") {
                                  return "الرجاء ادخال القيمة";
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                _packagesNumController.text = newValue!;
                              },
                              onFieldSubmitted: (value) {
                                BlocProvider.of<BottomNavBarCubit>(context)
                                    .emitShow();
                              },
                            ),
                          ),
                          SizedBox(
                            height: 7.h,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 18.w),
                            child: CheckboxListTile(
                                value: haveTabaleh,
                                title: const Text("مع طبالي؟"),
                                activeColor: AppColor.goldenYellow,
                                contentPadding: EdgeInsets.zero,
                                onChanged: (value) {
                                  setSelectedPanel(3);

                                  setState(() {
                                    haveTabaleh = value!;
                                    if (!value) {
                                      _tabalehNumController.text = "0";
                                      tabalehNum = 0;
                                    }
                                  });
                                }),
                          ),
                          Visibility(
                            visible: haveTabaleh,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setSelectedPanel(3);
                                      setState(() {
                                        tabalehNum++;
                                        _tabalehNumController.text =
                                            tabalehNum.toString();
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey[600]!,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(45),
                                      ),
                                      child: Icon(Icons.add,
                                          size: 40.w, color: Colors.blue[200]!),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 200.w,
                                    height: 55.h,
                                    child: TextField(
                                      controller: _tabalehNumController,
                                      focusNode: _nodeTabaleh,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 17),
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true, signed: true),
                                      inputFormatters: [DecimalFormatter()],
                                      decoration: const InputDecoration(
                                        labelText: "العدد",
                                        alignLabelWithHint: true,
                                      ),
                                      scrollPadding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom +
                                              50),
                                      onTap: () {
                                        setSelectedPanel(2);
                                        BlocProvider.of<BottomNavBarCubit>(
                                                context)
                                            .emitHide();
                                        _tabalehNumController.selection =
                                            TextSelection(
                                                baseOffset: 0,
                                                extentOffset:
                                                    _tabalehNumController
                                                        .value.text.length);
                                      },
                                      onChanged: (value) {
                                        if (value.isEmpty) {
                                          setState(() {
                                            tabalehNum = 0;
                                          });
                                        } else {
                                          tabalehNum = int.parse(double.parse(
                                                  _tabalehNumController.text)
                                              .toInt()
                                              .toString());
                                        }
                                      },
                                      onSubmitted: (value) {
                                        BlocProvider.of<BottomNavBarCubit>(
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
                                        setSelectedPanel(3);

                                        if (tabalehNum > 0) {
                                          setState(() {
                                            tabalehNum--;
                                            _tabalehNumController.text =
                                                tabalehNum.toString();
                                          });
                                        }
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
                                        child: Icon(Icons.remove,
                                            size: 40.w,
                                            color: Colors.grey[600]!),
                                      )),
                                ],
                              ),
                            ),
                          ),
                          const Divider(),
                          SizedBox(
                            height: 7.h,
                          ),
                          Visibility(
                            visible: selectedStateError ||
                                selectedRadioTileError ||
                                calculatorError ||
                                packageError,
                            child: const Padding(
                              padding: EdgeInsets.only(
                                  top: 2.0,
                                  bottom: 8.0,
                                  right: 25.0,
                                  left: 25.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "الرجاء ملء الحقول الفارغة واستكمال باقي الخيارات",
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                              BlocConsumer<CalculateResultBloc,
                                  CalculateResultState>(
                                listener: (context, state) {
                                  if (state is CalculateResultSuccessed) {}
                                },
                                builder: (context, state) {
                                  if (state is CalculateResultLoading) {
                                    return CustomButton(
                                        title: SizedBox(
                                            width: 250.w,
                                            child: const Center(
                                                child:
                                                    CircularProgressIndicator())),
                                        // color: AppColor.deepYellow,
                                        onTap: () {});
                                  }
                                  if (state is CalculateResultFailed) {
                                    return Text(state.error);
                                  } else {
                                    return CustomButton(
                                      title: SizedBox(
                                        width: 250.w,
                                        child: const Center(
                                          child: Text(
                                            "التالي",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // color: AppColor.deepYellow,
                                      onTap: () {
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                        if (selectedRadioTile.isNotEmpty) {
                                          if (selectedStateCustome != null &&
                                              selectedCustomeAgency != null) {
                                            _ordercalformkey.currentState
                                                ?.save();
                                            if (_ordercalformkey.currentState!
                                                .validate()) {
                                              setState(() {
                                                calculatorError = false;
                                              });
                                              _packagesformkey.currentState
                                                  ?.save();
                                              if (_packagesformkey.currentState!
                                                  .validate()) {
                                                setState(() {
                                                  packageError = false;
                                                });

                                                if (selectedOrigin != null) {
                                                  if (selectedPackage != null) {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            TraderAttachementScreen(
                                                          offerType:
                                                              selectedRadioTile,
                                                          customAgency:
                                                              selectedCustomeAgency!
                                                                  .id!,
                                                          customeState:
                                                              selectedStateCustome!
                                                                  .id!,
                                                          origin:
                                                              selectedOrigin!
                                                                  .id!,
                                                          packageType:
                                                              packageTypeId,
                                                          packagesNum:
                                                              packageNum,
                                                          tabalehNum:
                                                              tabalehNum,
                                                          weight: wieghtValue
                                                              .toInt(),
                                                          product:
                                                              selectedPackage!
                                                                  .id,
                                                          price: int.parse(
                                                              syrianTotalValue),
                                                          taxes: int.parse(
                                                              totalValueWithEnsurance),
                                                          rawMaterial: result
                                                              .rawMaterial,
                                                          industrial:
                                                              result.industrial,
                                                        ),
                                                      ),
                                                    );
                                                  } else {
                                                    setState(() {
                                                      feeerror = true;
                                                      calculatorError = true;
                                                    });
                                                    setSelectedPanel(2);
                                                    Scrollable.ensureVisible(
                                                      key3.currentContext!,
                                                      duration: const Duration(
                                                        milliseconds: 500,
                                                      ),
                                                    );
                                                  }
                                                } else {
                                                  setState(() {
                                                    originerror = true;
                                                    calculatorError = true;
                                                  });
                                                  setSelectedPanel(2);
                                                  Scrollable.ensureVisible(
                                                    key3.currentContext!,
                                                    duration: const Duration(
                                                      milliseconds: 500,
                                                    ),
                                                  );
                                                }
                                              } else {
                                                setSelectedPanel(3);

                                                setState(() {
                                                  packageError = true;
                                                });
                                              }
                                            } else {
                                              setSelectedPanel(2);

                                              setState(() {
                                                calculatorError = true;
                                              });
                                              Scrollable.ensureVisible(
                                                key3.currentContext!,
                                                duration: const Duration(
                                                  milliseconds: 500,
                                                ),
                                              );
                                            }
                                          } else {
                                            setSelectedPanel(1);
                                            setState(() {
                                              selectedStateError = true;
                                            });
                                            Scrollable.ensureVisible(
                                              key2.currentContext!,
                                              duration: const Duration(
                                                milliseconds: 500,
                                              ),
                                            );
                                          }
                                        } else {
                                          setSelectedPanel(0);
                                          setState(() {
                                            selectedRadioTileError = true;
                                          });
                                          Scrollable.ensureVisible(
                                            key1.currentContext!,
                                            duration: const Duration(
                                              milliseconds: 500,
                                            ),
                                          );
                                        }
                                      },
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 7.h,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 7.h,
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
