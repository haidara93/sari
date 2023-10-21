import 'package:cached_network_image/cached_network_image.dart';
import 'package:custome_mobile/business_logic/bloc/agency_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/calculate_result_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/package_type_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/state_custome_bloc.dart';
import 'package:custome_mobile/data/models/package_model.dart';
import 'package:custome_mobile/data/models/state_custome_agency_model.dart';
import 'package:custome_mobile/data/repositories/state_agency_repository.dart';
import 'package:custome_mobile/data/services/calculator_service.dart';
import 'package:custome_mobile/helpers/color_constants.dart';
import 'package:custome_mobile/views/screens/trader/trader_bill_review.dart';
import 'package:custome_mobile/views/widgets/custom_botton.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class OrderBrokerScreen extends StatefulWidget {
  const OrderBrokerScreen({Key? key}) : super(key: key);

  @override
  State<OrderBrokerScreen> createState() => _OrderBrokerScreenState();
}

class _OrderBrokerScreenState extends State<OrderBrokerScreen> {
  final GlobalKey<FormState> _ordercalformkey = GlobalKey<FormState>();

  final TextEditingController _typeAheadController = TextEditingController();

  final TextEditingController _wieghtController = TextEditingController();

  final TextEditingController _originController = TextEditingController();

  final TextEditingController _valueController = TextEditingController();

  final ScrollController _scrollController = ScrollController();
  String syrianExchangeValue = "0.0";

  String syrianTotalValue = "0.0";

  String totalValueWithEnsurance = "0.0";
  bool haveTabaleh = false;

  Package? selectedPackage;
  Origin? selectedOrigin;

  String wieghtUnit = "";
  String wieghtLabel = "  الوزن";

  double usTosp = 6565;
  double basePrice = 0.0;
  double wieghtValue = 0.0;

  bool valueEnabled = true;
  bool allowexport = false;
  bool fillorigin = false;
  bool originerror = false;
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

  int selectedPanel = 0;
  bool showtypeError = false;
  String selectedRadioTile = "";
  String statePlaceholder = "اختر مديرية";
  String agencyPlaceholder = "اختر أمانة";

  FocusNode _statenode = new FocusNode();
  FocusNode _agencynode = new FocusNode();
  @override
  void initState() {
    super.initState();
    // FocusScope.of(context).unfocus();
  }

  void calculateTotalValueWithPrice() {
    var syrianExch = wieghtValue * double.parse(_valueController.text);
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
    if (suggestion.price! > 0) {
      basePrice = suggestion.price!;

      _valueController.text = suggestion.price!.toString();
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
            wieghtLabel = "  الوزن";
          });
          break;
        case "طن":
          setState(() {
            wieghtLabel = "  الوزن";
          });
          break;
        case "قيراط":
          setState(() {
            wieghtLabel = "  الوزن";
          });
          break;
        case "  كيلو واط بالساعة 1000":
          setState(() {
            wieghtLabel = "  الاستطاعة";
          });
          break;
        case "  الاستطاعة بالطن":
          setState(() {
            wieghtLabel = "  الاستطاعة";
          });
          break;
        case "واط":
          setState(() {
            wieghtLabel = "  الاستطاعة";
          });
          break;
        case "عدد الأزواج":
          setState(() {
            wieghtLabel = "  العدد";
          });
          break;
        case "عدد":
          setState(() {
            wieghtLabel = "  العدد";
          });
          break;
        case "طرد":
          setState(() {
            wieghtLabel = "  العدد";
          });
          break;
        case "قدم":
          setState(() {
            wieghtLabel = "  العدد";
          });
          break;
        case "متر":
          setState(() {
            wieghtLabel = "  الحجم";
          });
          break;
        case "متر مربع":
          setState(() {
            wieghtLabel = "  الحجم";
          });
          break;
        case "متر مكعب":
          setState(() {
            wieghtLabel = "  الحجم";
          });
          break;
        case "لتر":
          setState(() {
            wieghtLabel = "  السعة";
          });
          break;
        default:
          setState(() {
            wieghtLabel = "  الوزن";
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

    if (suggestion.placeholder != null) {
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
  }

  setSelectedRadioTile(String val) {
    setState(() {
      selectedRadioTile = val;
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AgencyBloc(
          stateAgencyRepository:
              RepositoryProvider.of<StateAgencyRepository>(context)),
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: Column(children: [
              Card(
                margin: const EdgeInsets.symmetric(vertical: 7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: selectedPanel == 0
                        ? const LinearGradient(
                            colors: [
                                Color.fromARGB(255, 229, 215, 94),
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
                      children: const [
                        Text("اختر نوع العملية",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .38,
                          child: RadioListTile(
                            value: "I",
                            groupValue: selectedRadioTile,
                            title: const Text("استيراد"),
                            // subtitle: Text("Radio 1 Subtitle"),
                            onChanged: (val) {
                              // print("Radio Tile pressed $val");
                              setSelectedPanel(0);
                              setSelectedRadioTile(val!);
                            },
                            activeColor: AppColor.activeGreen,
                            selected: selectedRadioTile == "I",
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .38,
                          child: RadioListTile(
                            value: "E",
                            groupValue: selectedRadioTile,
                            title: const Text("تصدير"),
                            // subtitle: Text("Radio 2 Subtitle"),
                            onChanged: (val) {
                              // print("Radio Tile pressed $val");
                              setSelectedPanel(0);
                              setSelectedRadioTile(val!);
                            },
                            activeColor: AppColor.activeGreen,

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
              Card(
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
                        ? const LinearGradient(
                            colors: [
                                Color.fromARGB(255, 229, 215, 94),
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
                        const Text("الأمانة الجمركية",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            )),
                        const SizedBox(
                          height: 15,
                        ),
                        BlocBuilder<StateCustomeBloc, StateCustomeState>(
                          builder: (context, state) {
                            if (state is StateCustomeLoadedSuccess) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DropdownButtonHideUnderline(
                                    child: Focus(
                                      focusNode: _statenode,
                                      onFocusChange: (bool focus) {
                                        if (focus) {
                                          setSelectedPanel(1);
                                        }
                                      },
                                      child: DropdownButton2<StateCustome>(
                                        isExpanded: true,
                                        hint: Text(
                                          statePlaceholder,
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Theme.of(context).hintColor,
                                          ),
                                        ),
                                        items: state.states
                                            .map((StateCustome item) =>
                                                DropdownMenuItem<StateCustome>(
                                                  value: item,
                                                  child: Text(
                                                    item.name!,
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ))
                                            .toList(),
                                        value: selectedStateCustome,
                                        onChanged: (StateCustome? value) {
                                          BlocProvider.of<AgencyBloc>(context)
                                              .add(AgenciesLoadEvent(
                                                  value!.id!));
                                          setState(() {
                                            selectedStateCustome = value;
                                            selectedCustomeAgency = null;
                                            // statePlaceholder =
                                            //     selectedStateCustome == null
                                            //         ? 'اختر محافظة'
                                            //         : value.name!;
                                          });
                                          // if (value!.price! > 0) {
                                          //   _valueController.text =
                                          //       value.price!.toString();
                                          //   setState(() {
                                          //     valueEnabled = false;
                                          //   });
                                          // } else {
                                          //   setState(() {
                                          //     _valueController.text = "";
                                          //     valueEnabled = true;
                                          //     syrianExchangeValue = "6565";
                                          //   });
                                          // }
                                          // setState(() {
                                          //   selectedValue = value;
                                          // });
                                        },
                                        buttonStyleData: ButtonStyleData(
                                          height: 50,
                                          width: double.infinity,
                                          padding: const EdgeInsets.only(
                                              left: 14, right: 14),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                              color: Colors.black26,
                                            ),
                                            color: Colors.white,
                                          ),
                                          elevation: 2,
                                        ),
                                        iconStyleData: const IconStyleData(
                                          icon: Icon(
                                            Icons.arrow_forward_ios_outlined,
                                          ),
                                          iconSize: 14,
                                          iconEnabledColor:
                                              AppColor.AccentGreen,
                                          iconDisabledColor: Colors.grey,
                                        ),
                                        dropdownStyleData: DropdownStyleData(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(14),
                                            color: Colors.white,
                                          ),
                                          scrollbarTheme: ScrollbarThemeData(
                                            radius: const Radius.circular(40),
                                            thickness:
                                                MaterialStateProperty.all(6),
                                            thumbVisibility:
                                                MaterialStateProperty.all(true),
                                          ),
                                        ),
                                        menuItemStyleData:
                                            const MenuItemStyleData(
                                          height: 40,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
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
                                            child:
                                                DropdownButton2<CustomeAgency>(
                                              isExpanded: true,
                                              hint: Text(
                                                agencyPlaceholder,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: Theme.of(context)
                                                      .hintColor,
                                                ),
                                              ),
                                              items: state2.agencies
                                                  .map((CustomeAgency item) =>
                                                      DropdownMenuItem<
                                                          CustomeAgency>(
                                                        value: item,
                                                        child: SizedBox(
                                                          width: 200,
                                                          child: Text(
                                                            item.name!,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 15,
                                                            ),
                                                          ),
                                                        ),
                                                      ))
                                                  .toList(),
                                              value: selectedCustomeAgency,
                                              onChanged:
                                                  (CustomeAgency? value) {
                                                setState(() {
                                                  selectedCustomeAgency = value;
                                                });
                                              },
                                              buttonStyleData: ButtonStyleData(
                                                height: 50,
                                                width: double.infinity,
                                                padding: const EdgeInsets.only(
                                                    left: 14, right: 14),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color: Colors.black26,
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
                                                iconEnabledColor: Colors.yellow,
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
                                                  const MenuItemStyleData(
                                                height: 40,
                                              ),
                                            ),
                                          ),
                                        );
                                      } else if (state2
                                          is AgencyLoadingProgress) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else {
                                        return Container();
                                      }
                                    },
                                  ),
                                ],
                              );
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        )
                      ]),
                ),
              ),
              Card(
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
                        ? const LinearGradient(
                            colors: [
                                Color.fromARGB(255, 229, 215, 94),
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
                          const Text("نوع البضاعة",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              )),
                          const SizedBox(
                            height: 15,
                          ),
                          TypeAheadField(
                            textFieldConfiguration: TextFieldConfiguration(
                              // autofocus: true,
                              controller: _typeAheadController,
                              onTap: () {
                                setSelectedPanel(2);
                                _typeAheadController.selection = TextSelection(
                                    baseOffset: 0,
                                    extentOffset:
                                        _typeAheadController.value.text.length);
                              },
                              style: DefaultTextStyle.of(context)
                                  .style
                                  .copyWith(fontStyle: FontStyle.italic),
                              decoration: InputDecoration(
                                  label: const Text("  نوع البضاعة"),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  contentPadding: EdgeInsets.zero),
                            ),
                            suggestionsCallback: (pattern) async {
                              if (pattern.isNotEmpty) {
                                return await CalculatorService.getpackages(
                                    pattern);
                              } else {
                                return [];
                              }
                            },
                            itemBuilder: (context, suggestion) {
                              return Directionality(
                                textDirection: TextDirection.rtl,
                                child: ListTile(
                                  // leading: Icon(Icons.shopping_cart),
                                  title: Text(suggestion.label!),
                                  // subtitle: Text('\$${suggestion['price']}'),
                                ),
                              );
                            },
                            onSuggestionSelected: (suggestion) {
                              setState(() {
                                _wieghtController.text = "0.0";
                                _valueController.text = "0.0";
                                syrianExchangeValue = "0.0";
                                syrianTotalValue = "0.0";
                                totalValueWithEnsurance = "0.0";
                              });
                              selectSuggestion(suggestion);

                              // Navigator.of(context).push(MaterialPageRoute(
                              //   builder: (context) => ProductPage(product: suggestion)
                              // ));
                            },
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Visibility(
                              visible: allowexport,
                              child: const Text(
                                "هذا البند ممنوع من الاستيراد",
                                style: TextStyle(color: Colors.red),
                              )),
                          const SizedBox(
                            height: 12,
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
                          const SizedBox(
                            height: 12,
                          ),

                          TypeAheadField(
                            textFieldConfiguration: TextFieldConfiguration(
                              // autofocus: true,
                              onTap: () {
                                setSelectedPanel(2);
                                _originController.selection = TextSelection(
                                    baseOffset: 0,
                                    extentOffset:
                                        _originController.value.text.length);
                              },
                              controller: _originController,
                              onTapOutside: (event) {
                                FocusManager.instance.primaryFocus!.unfocus();
                              },
                              style: DefaultTextStyle.of(context)
                                  .style
                                  .copyWith(fontStyle: FontStyle.italic),
                              decoration: InputDecoration(
                                  label: const Text("  المنشأ"),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  contentPadding: EdgeInsets.zero,
                                  prefixIcon: _originController.text.isNotEmpty
                                      ? SvgPicture.network(
                                          selectedOrigin!.imageURL!,
                                          height: 25,
                                          // semanticsLabel: 'A shark?!',
                                          placeholderBuilder: (BuildContext
                                                  context) =>
                                              const CircularProgressIndicator(),
                                        )
                                      : null),
                            ),
                            suggestionsCallback: (pattern) async {
                              if (pattern.isNotEmpty) {
                                return await CalculatorService.getorigins(
                                    pattern);
                              } else {
                                return [];
                              }
                            },
                            itemBuilder: (context, suggestion) {
                              return Directionality(
                                textDirection: TextDirection.rtl,
                                child: ListTile(
                                  leading: SvgPicture.network(
                                    suggestion.imageURL,
                                    height: 35,
                                    // semanticsLabel: 'A shark?!',
                                    placeholderBuilder:
                                        (BuildContext context) =>
                                            const CircularProgressIndicator(),
                                  ),
                                  title: Text(suggestion.label!),
                                  // subtitle: Text('\$${suggestion['price']}'),
                                ),
                              );
                            },
                            onSuggestionSelected: (suggestion) {
                              selectOrigin(suggestion);
                              // Navigator.of(context).push(MaterialPageRoute(
                              //   builder: (context) => ProductPage(product: suggestion)
                              // ));
                            },
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Visibility(
                              visible: originerror,
                              child: const Text(
                                "الرجاء اختيار المنشأ",
                                style: TextStyle(color: Colors.red),
                              )),
                          const SizedBox(
                            height: 12,
                          ),
                          TextFormField(
                            controller: _wieghtController,
                            onTap: () {
                              setSelectedPanel(2);
                              _wieghtController.selection = TextSelection(
                                  baseOffset: 0,
                                  extentOffset:
                                      _wieghtController.value.text.length);
                            },
                            enabled: !valueEnabled,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: wieghtLabel,
                              prefixText: showunit ? wieghtUnit : "",
                              prefixStyle: const TextStyle(color: Colors.black),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              contentPadding: EdgeInsets.zero,
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
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          TextFormField(
                            controller: _valueController,
                            onTap: () => _valueController.selection =
                                TextSelection(
                                    baseOffset: 0,
                                    extentOffset:
                                        _valueController.value.text.length),
                            enabled: valueEnabled,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: valueEnabled
                                  ? "  قيمة البضاعة الاجمالية بالدولار"
                                  : "  سعر الواحدة لدى الجمارك",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              contentPadding: EdgeInsets.zero,
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
                                title: const Text("هل المنشأ صناعية؟"),
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
                          Text(!valueEnabled
                              ? "القيمة الاجمالية بالدولار :"
                              : "قيمة التحويل بالليرة السورية :"),
                          Text(syrianExchangeValue),
                          const Text("قيمة الاجمالية بالليرة السورية: "),
                          Text(syrianTotalValue),
                          const Text("قيمة البضاعة مع التأمين: "),
                          Text(totalValueWithEnsurance),
                          const SizedBox(
                            height: 12,
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
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: selectedPanel == 3
                        ? const LinearGradient(
                            colors: [
                                Color.fromARGB(255, 229, 215, 94),
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
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("نوع الطرد"),
                          SizedBox(
                            height: 7.h,
                          ),
                          SizedBox(
                              height: 106.h,
                              child: BlocBuilder<PackageTypeBloc,
                                  PackageTypeState>(
                                builder: (context, state) {
                                  if (state is PackageTypeLoadedSuccess) {
                                    return Scrollbar(
                                      controller: _scrollController,
                                      thumbVisibility: true,
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: ListView.builder(
                                          controller: _scrollController,
                                          itemCount: state.packageTypes.length,
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 3),
                                              child: GestureDetector(
                                                onTap: () {
                                                  setSelectedPanel(3);

                                                  setState(() {
                                                    packageTypeId = state
                                                        .packageTypes[index]
                                                        .id!;
                                                  });
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              7),
                                                      border: Border.all(
                                                          color: packageTypeId ==
                                                                  state
                                                                      .packageTypes[
                                                                          index]
                                                                      .id!
                                                              ? Colors.blue
                                                              : Colors.white,
                                                          width: 2)),
                                                  child: Column(
                                                    children: [
                                                      CachedNetworkImage(
                                                        imageUrl: state
                                                            .packageTypes[index]
                                                            .image!,
                                                        height: 40,
                                                      ),
                                                      Text(state
                                                          .packageTypes[index]
                                                          .name!),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  } else {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                },
                              )),
                          const SizedBox(
                            height: 7,
                          ),
                          CheckboxListTile(
                              value: haveTabaleh,
                              title: const Text("هل يوجد طبالي؟"),
                              onChanged: (value) {
                                setSelectedPanel(3);

                                setState(() {
                                  haveTabaleh = value!;
                                  if (!value) {
                                    tabalehNum = 0;
                                  }
                                });
                              }),
                          Visibility(
                              visible: haveTabaleh,
                              child: Column(
                                children: [
                                  const Text("عدد الطبالي"),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            setSelectedPanel(3);
                                            setState(() {
                                              tabalehNum++;
                                            });
                                          },
                                          child: const Icon(
                                            Icons.add_box_outlined,
                                            size: 38,
                                          )),
                                      Text(
                                        tabalehNum.toString(),
                                        style: const TextStyle(fontSize: 30),
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            setSelectedPanel(3);

                                            if (tabalehNum > 0) {
                                              setState(() {
                                                tabalehNum--;
                                              });
                                            }
                                          },
                                          child: const Icon(
                                            Icons
                                                .indeterminate_check_box_outlined,
                                            size: 38,
                                          )),
                                    ],
                                  ),
                                ],
                              )),
                          const SizedBox(
                            height: 7,
                          ),
                          const Divider(),
                          const Text("عدد الطرود"),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    setSelectedPanel(3);
                                    setState(() {
                                      packageNum++;
                                    });
                                  },
                                  child: const Icon(
                                    Icons.add_box_outlined,
                                    size: 38,
                                  )),
                              Text(
                                packageNum.toString(),
                                style: const TextStyle(fontSize: 30),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    setSelectedPanel(3);
                                    if (packageNum > 0) {
                                      setState(() {
                                        packageNum--;
                                      });
                                    }
                                  },
                                  child: const Icon(
                                    Icons.indeterminate_check_box_outlined,
                                    size: 38,
                                  )),
                            ],
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                        ]),
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
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
                  BlocConsumer<CalculateResultBloc, CalculateResultState>(
                    listener: (context, state) {
                      if (state is CalculateResultSuccessed) {}
                    },
                    builder: (context, state) {
                      if (state is CalculateResultLoading) {
                        return CustomButton(
                            title: const SizedBox(
                                width: 100,
                                child:
                                    Center(child: CircularProgressIndicator())),
                            color: AppColor.deepYellow,
                            onTap: () {});
                      }
                      if (state is CalculateResultFailed) {
                        return Text(state.error);
                      } else {
                        return CustomButton(
                            title: const SizedBox(
                                width: 100,
                                child: Center(child: Text("الرسوم"))),
                            color: AppColor.deepYellow,
                            onTap: () {
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
                              result.supportFee = selectedPackage!.supportFee!;
                              result.localFee = selectedPackage!.localFee!;
                              result.protectionFee =
                                  selectedPackage!.protectionFee!;
                              result.naturalFee = selectedPackage!.naturalFee!;
                              result.taxFee = selectedPackage!.taxFee!;
                              BlocProvider.of<CalculateResultBloc>(context)
                                  .add(CalculateTheResultEvent(result));
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TraderBillReview(
                                      offerType: selectedRadioTile,
                                      customAgency: selectedCustomeAgency!.id!,
                                      customeState: selectedStateCustome!.id!,
                                      origin: selectedOrigin!.id!,
                                      packageType: packageTypeId,
                                      packagesNum: packageNum,
                                      tabalehNum: tabalehNum,
                                      weight: wieghtValue.toInt(),
                                      product: selectedPackage!.id,
                                      price: int.parse(syrianTotalValue),
                                      taxes: int.parse(totalValueWithEnsurance),
                                      rawMaterial: result.rawMaterial,
                                      industrial: result.industrial,
                                    ),
                                  ));
                            });
                      }
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
