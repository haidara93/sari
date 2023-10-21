import 'package:custome_mobile/business_logic/bloc/calculate_result_bloc.dart';
import 'package:custome_mobile/data/models/package_model.dart';
import 'package:custome_mobile/data/services/calculator_service.dart';
import 'package:custome_mobile/views/screens/trader/trader_calculator_result_screen.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class TraderCalculatorScreen extends StatefulWidget {
  const TraderCalculatorScreen({Key? key}) : super(key: key);

  @override
  State<TraderCalculatorScreen> createState() => _TraderCalculatorScreenState();
}

class _TraderCalculatorScreenState extends State<TraderCalculatorScreen> {
  final GlobalKey<FormState> _calformkey = GlobalKey<FormState>();

  final TextEditingController _typeAheadController = TextEditingController();

  final TextEditingController _wieghtController = TextEditingController();

  final TextEditingController _originController = TextEditingController();

  final TextEditingController _valueController = TextEditingController();

  String syrianExchangeValue = "0.0";

  String syrianTotalValue = "0.0";

  String totalValueWithEnsurance = "0.0";

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

  CalculateObject result = CalculateObject();

  @override
  void initState() {
    super.initState();
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
    print(valueEnabled);
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
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.grey[200],
          body: SafeArea(
              child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 35,
                    ),
                    Text(
                      "حاسبة الرسوم الجمركية",
                      style: TextStyle(
                          color: Colors.yellow[700],
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      "تتيح أداة حاسبة الرسوم الجمركية تقدير التكلفة الإجمالية لاستيراد البضائع وفقاً للتعرفة الجمركية والقوانين الضريبية في الجمهورية العربية السورية، وتوفر مجموعة واسعة من المعلومات المفصلة حول الرسوم الجمركية بما في ذلك الأحكام والشروط والأسعار الاسترشادية المتوفرة.",
                      maxLines: 10,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 7),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        gradient: const LinearGradient(
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
                              Colors.white,
                              Colors.white,
                              Colors.white,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter),
                      ),
                      width: double.infinity,
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: _calformkey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 12,
                            ),
                            TypeAheadField(
                              textFieldConfiguration: TextFieldConfiguration(
                                // autofocus: true,
                                controller: _typeAheadController,
                                onTap: () => _typeAheadController.selection =
                                    TextSelection(
                                        baseOffset: 0,
                                        extentOffset: _typeAheadController
                                            .value.text.length),
                                style: DefaultTextStyle.of(context)
                                    .style
                                    .copyWith(fontStyle: FontStyle.italic),
                                decoration: InputDecoration(
                                    label: const Text("  نوع البضاعة"),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
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
                            const SizedBox(
                              height: 12,
                            ),
                            TextFormField(
                              controller: _wieghtController,
                              onTap: () => _wieghtController.selection =
                                  TextSelection(
                                      baseOffset: 0,
                                      extentOffset:
                                          _wieghtController.value.text.length),
                              enabled: !valueEnabled,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  labelText: wieghtLabel,
                                  prefixText: showunit ? wieghtUnit : "",
                                  prefixStyle:
                                      const TextStyle(color: Colors.black),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  contentPadding: EdgeInsets.zero),
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
                            TypeAheadField(
                              textFieldConfiguration: TextFieldConfiguration(
                                // autofocus: true,
                                onTap: () => _originController.selection =
                                    TextSelection(
                                        baseOffset: 0,
                                        extentOffset: _originController
                                            .value.text.length),
                                controller: _originController,
                                style: DefaultTextStyle.of(context)
                                    .style
                                    .copyWith(fontStyle: FontStyle.italic),
                                decoration: InputDecoration(
                                    label: const Text("  المنشأ"),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    contentPadding: EdgeInsets.zero,
                                    prefixIcon:
                                        _originController.text.isNotEmpty
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
                                  "  الرجاء اختيار المنشأ",
                                  style: TextStyle(color: Colors.red),
                                )),
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
                                  contentPadding: EdgeInsets.zero),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                BlocConsumer<CalculateResultBloc,
                                    CalculateResultState>(
                                  listener: (context, state) {
                                    if (state is CalculateResultSuccessed) {}
                                  },
                                  builder: (context, state) {
                                    if (state is CalculateResultLoading) {
                                      return ElevatedButton(
                                          onPressed: () {},
                                          child:
                                              const CircularProgressIndicator());
                                    }
                                    if (state is CalculateResultFailed) {
                                      return Text(state.error);
                                    } else {
                                      return ElevatedButton(
                                          onPressed: () {
                                            result.insurance = int.parse(
                                                totalValueWithEnsurance);
                                            result.fee = selectedPackage!.fee!;
                                            result.rawMaterial =
                                                rawMaterialValue ? 1 : 0;
                                            result.industrial =
                                                industrialValue ? 1 : 0;
                                            result.totalTax = selectedPackage!
                                                .totalTaxes!.totalTax!;
                                            result.partialTax = selectedPackage!
                                                .totalTaxes!.partialTax!;
                                            result.origin =
                                                selectedOrigin!.label!;
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
                                            result.taxFee =
                                                selectedPackage!.taxFee!;
                                            BlocProvider.of<
                                                        CalculateResultBloc>(
                                                    context)
                                                .add(CalculateTheResultEvent(
                                                    result));
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const TraderCalculatorResultScreen(),
                                                ));
                                          },
                                          child:
                                              const Text("احسب الرسم الجمركي"));
                                    }
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ]),
            ),
          )),
        ));
  }
}
