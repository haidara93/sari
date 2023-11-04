// import 'package:custome_mobile/business_logic/bloc/attachment_type_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/auth_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/calculate_result_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/calculator_panel_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/fee_item_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/flags_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/group_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/package_type_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/post_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/section_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/state_custome_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/trader_log_bloc.dart';
import 'package:custome_mobile/business_logic/cubit/bottom_nav_bar_cubit.dart';
import 'package:custome_mobile/data/models/package_model.dart';
import 'package:custome_mobile/data/services/calculator_service.dart';
import 'package:custome_mobile/enum/panel_state.dart';
import 'package:custome_mobile/helpers/color_constants.dart';
import 'package:custome_mobile/views/screens/trader/custome_tariff_screen.dart';
import 'package:custome_mobile/views/screens/trader/log_screens/log_screen.dart';
import 'package:custome_mobile/views/screens/trader/order_broker_screen.dart';
import 'package:custome_mobile/views/screens/trader/trader_calculator_screen.dart';
import 'package:custome_mobile/views/screens/trader/trader_main_screen.dart';
import 'package:custome_mobile/views/widgets/custom_app_bar.dart';
import 'package:custome_mobile/views/widgets/custom_botton.dart';
import 'package:custome_mobile/views/widgets/item_taxes_widget.dart';
import 'package:custome_mobile/views/widgets/pens_taxes_widget.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class TraderHomeScreen extends StatefulWidget {
  const TraderHomeScreen({Key? key}) : super(key: key);

  @override
  State<TraderHomeScreen> createState() => _TraderHomeScreenState();
}

class _TraderHomeScreenState extends State<TraderHomeScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  int currentIndex = 2;
  int navigationValue = 2;
  String title = "الرئيسية";
  Widget currentScreen = const TraderMainScreen();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;
  bool _isKeyboardVisible = false;
  late AnimationController _animationController;
  final panelTransation = const Duration(milliseconds: 500);
  PanelState _panelState = PanelState.hidden;
  final GlobalKey<FormState> _calculatorformkey = GlobalKey<FormState>();
  bool calculateFeeScreen = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<PostBloc>(context).add(PostLoadEvent());
    BlocProvider.of<FlagsBloc>(context).add(FlagsLoadEvent());
    BlocProvider.of<GroupBloc>(context).add(GroupLoadEvent());
    _tabController = TabController(
      initialIndex: 2,
      length: 5,
      vsync: this,
    );
    WidgetsBinding.instance.addObserver(this);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 2500,
      ),
    );
  }

  @override
  void dispose() {
    // Remove the WidgetsBindingObserver when the state is disposed
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    // Check the keyboard visibility when the metrics change
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    setState(() {
      _isKeyboardVisible = bottomInset > 0;
    });
  }

  void changeSelectedValue(
      {required int selectedValue, required BuildContext contxt}) async {
    setState(() {
      navigationValue = selectedValue;
    });
    switch (selectedValue) {
      case 0:
        {
          setState(() {
            title = "طلب مخلص";

            BlocProvider.of<StateCustomeBloc>(context)
                .add(StateCustomeLoadEvent());
            BlocProvider.of<PackageTypeBloc>(context)
                .add(PackageTypeLoadEvent());
            currentScreen = const OrderBrokerScreen();
          });
          break;
        }
      case 1:
        {
          setState(() {
            title = "حاسبة الرسوم";

            currentScreen = TraderCalculatorScreen();
          });
          break;
        }
      case 2:
        {
          setState(() {
            title = "الرئيسية";

            BlocProvider.of<PostBloc>(context).add(PostLoadEvent());

            currentScreen = const TraderMainScreen();
          });
          break;
        }
      case 3:
        {
          setState(() {
            title = "التعرفة الجمركية";
            BlocProvider.of<SectionBloc>(context).add(SectionLoadEvent());

            currentScreen = const CustomeTariffScreen();
          });
          break;
        }
      case 4:
        {
          BlocProvider.of<TraderLogBloc>(context)
              .add(const TraderLogLoadEvent("R"));
          setState(() {
            title = "السجل";

            currentScreen = const LogScreen();
          });
          break;
        }
    }
  }

  List<Color> bottomNavbarColor() {
    switch (navigationValue) {
      case 0:
        return [
          AppColor.lighterAppBarBlue,
          AppColor.lightAppBarBlue,
          AppColor.deepAppBarBlue,
          AppColor.deepAppBarBlue,
          AppColor.deepAppBarBlue,
        ];
      case 1:
        return [
          AppColor.lightAppBarBlue,
          AppColor.lighterAppBarBlue,
          AppColor.lightAppBarBlue,
          AppColor.deepAppBarBlue,
          AppColor.deepAppBarBlue,
        ];
      case 2:
        return [
          AppColor.deepAppBarBlue,
          AppColor.lightAppBarBlue,
          AppColor.lighterAppBarBlue,
          AppColor.lightAppBarBlue,
          AppColor.deepAppBarBlue,
        ];
      case 3:
        return [
          AppColor.deepAppBarBlue,
          AppColor.deepAppBarBlue,
          AppColor.lightAppBarBlue,
          AppColor.lighterAppBarBlue,
          AppColor.lightAppBarBlue,
        ];
      case 4:
        return [
          AppColor.deepAppBarBlue,
          AppColor.deepAppBarBlue,
          AppColor.deepAppBarBlue,
          AppColor.lightAppBarBlue,
          AppColor.lighterAppBarBlue,
        ];
      default:
        return [
          AppColor.deepAppBarBlue,
          AppColor.lightAppBarBlue,
          AppColor.lighterAppBarBlue,
          AppColor.lightAppBarBlue,
          AppColor.deepAppBarBlue,
        ];
    }
  }

  double? _getTopForPanel(PanelState state, Size size) {
    if (state == PanelState.open) {
      return 0;
    } else if (state == PanelState.hidden) {
      return (size.height);
    }
    return null;
  }

  double? _getSizeForPanel(PanelState state, Size size) {
    if (state == PanelState.open) {
      return size.height;
    } else if (state == PanelState.hidden) {
      return (size.height * 0.5);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        if (_panelState == PanelState.open) {
          if (calculateFeeScreen) {
            setState(() {
              calculateFeeScreen = false;
            });
          } else {
            BlocProvider.of<CalculatorPanelBloc>(context)
                .add(CalculatorPanelHideEvent());
          }
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, _) {
              return Stack(
                children: [
                  SafeArea(
                    child: Scaffold(
                      key: _scaffoldKey,
                      resizeToAvoidBottomInset: false,
                      appBar: CustomAppBar(
                        title: title,
                        scaffoldKey: _scaffoldKey,
                      ),
                      drawer: Drawer(
                        backgroundColor: AppColor.deepBlue,
                        elevation: 1,
                        width: 250,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: ListView(children: [
                            SizedBox(
                              height: 35.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.yellow,
                                  radius: 35.h,
                                ),
                                Text(
                                  "Haidra",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 26.sp,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            const Divider(
                              color: Colors.white,
                            ),
                            ListTile(
                              leading: SvgPicture.asset(
                                "assets/icons/profile.svg",
                                height: 20.h,
                              ),
                              title: Text(
                                "الملف الشخصي",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            ListTile(
                              leading: SvgPicture.asset(
                                "assets/icons/log.svg",
                                height: 20.h,
                              ),
                              title: Text(
                                "السجل",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            ListTile(
                              leading: Image.asset(
                                "assets/icons/favorite.png",
                                height: 20.h,
                              ),
                              title: Text(
                                "المحفوظات",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            ListTile(
                              leading: SvgPicture.asset(
                                "assets/icons/calculator.svg",
                                height: 20.h,
                              ),
                              title: Text(
                                "حساباتي ",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            ListTile(
                              leading: SvgPicture.asset(
                                "assets/icons/tasks.svg",
                                height: 20.h,
                              ),
                              title: Text(
                                "المهام",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const Divider(
                              color: Colors.white,
                            ),
                            ListTile(
                              leading: SvgPicture.asset(
                                "assets/icons/privacy.svg",
                                height: 20.h,
                              ),
                              title: Text(
                                "سياسة الخصوصية",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            ListTile(
                              leading: Image.asset(
                                "assets/icons/settings.png",
                                height: 20.h,
                              ),
                              title: Text(
                                "الاعدادات",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            ListTile(
                              leading: SvgPicture.asset(
                                "assets/icons/help.svg",
                                height: 20.h,
                              ),
                              title: Text(
                                "مساعدة",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const Divider(
                              color: Colors.white,
                            ),
                            GestureDetector(
                              onTap: () {
                                BlocProvider.of<AuthBloc>(context)
                                    .add(UserLoggedOut());
                              },
                              child: ListTile(
                                leading: SvgPicture.asset(
                                  "assets/icons/log_out.svg",
                                  height: 20.h,
                                ),
                                title: Text(
                                  "تسجيل خروج",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ),
                      bottomNavigationBar:
                          BlocBuilder<BottomNavBarCubit, BottomNavBarState>(
                        builder: (context, state) {
                          if (state is BottomNavBarShown) {
                            return Container(
                                height: 88.h,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: bottomNavbarColor(),
                                    begin: Alignment.centerRight,
                                    end: Alignment.centerLeft,
                                  ),
                                ),
                                child: TabBar(
                                    labelPadding: EdgeInsets.zero,
                                    controller: _tabController,
                                    indicatorColor: AppColor.activeGreen,
                                    labelColor: AppColor.activeGreen,
                                    unselectedLabelColor: Colors.white,
                                    labelStyle: TextStyle(fontSize: 15.sp),
                                    unselectedLabelStyle:
                                        TextStyle(fontSize: 14.sp),
                                    padding: EdgeInsets.zero,
                                    onTap: (value) {
                                      changeSelectedValue(
                                          selectedValue: value,
                                          contxt: context);
                                    },
                                    tabs: [
                                      Tab(
                                        // text: "طلب مخلص",
                                        height: 66.h,
                                        icon: navigationValue == 0
                                            ? Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Image.asset(
                                                    "assets/icons/broker_order_active.png",
                                                    width: 36.w,
                                                    height: 36.h,
                                                  ),
                                                  Text(
                                                    "طلب مخلص",
                                                    style: TextStyle(
                                                        color: AppColor
                                                            .activeGreen,
                                                        fontSize: 15.sp),
                                                  )
                                                ],
                                              )
                                            : Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Image.asset(
                                                    "assets/icons/broker_order.png",
                                                    width: 30.w,
                                                    height: 30.h,
                                                  ),
                                                  const Text(
                                                    "طلب مخلص",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14),
                                                  )
                                                ],
                                              ),
                                      ),
                                      Tab(
                                        // text: "الحاسبة",
                                        height: 66.h,
                                        icon: navigationValue == 1
                                            ? Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Image.asset(
                                                    "assets/icons/calculator_active.png",
                                                    width: 36.w,
                                                    height: 36.h,
                                                  ),
                                                  Text(
                                                    "الحاسبة",
                                                    style: TextStyle(
                                                        color: AppColor
                                                            .activeGreen,
                                                        fontSize: 15.sp),
                                                  )
                                                ],
                                              )
                                            : Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/icons/calculator.svg",
                                                    width: 30.w,
                                                    height: 30.h,
                                                  ),
                                                  Text(
                                                    "الحاسبة",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15.sp),
                                                  )
                                                ],
                                              ),
                                      ),
                                      Tab(
                                        // text: "الرئيسية",
                                        height: 66.h,
                                        icon: navigationValue == 2
                                            ? Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Image.asset(
                                                    "assets/icons/home_active.png",
                                                    width: 36.w,
                                                    height: 36.h,
                                                  ),
                                                  Text(
                                                    "الرئيسية",
                                                    style: TextStyle(
                                                        color: AppColor
                                                            .activeGreen,
                                                        fontSize: 15.sp),
                                                  )
                                                ],
                                              )
                                            : Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/icons/home.svg",
                                                    width: 30.w,
                                                    height: 30.h,
                                                  ),
                                                  Text(
                                                    "الرئيسية",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15.sp),
                                                  )
                                                ],
                                              ),
                                      ),
                                      Tab(
                                        // text: "التعرفة",
                                        height: 66.h,
                                        icon: navigationValue == 3
                                            ? Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Image.asset(
                                                    "assets/icons/tariff_active.png",
                                                    width: 36.w,
                                                    height: 36.h,
                                                  ),
                                                  Text(
                                                    "التعرفة",
                                                    style: TextStyle(
                                                        color: AppColor
                                                            .activeGreen,
                                                        fontSize: 15.sp),
                                                  )
                                                ],
                                              )
                                            : Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/icons/tariff.svg",
                                                    width: 30.w,
                                                    height: 30.h,
                                                  ),
                                                  Text(
                                                    "التعرفة",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15.sp),
                                                  )
                                                ],
                                              ),
                                      ),
                                      Tab(
                                        // text: "السجل",
                                        height: 66.h,
                                        icon: navigationValue == 4
                                            ? Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Image.asset(
                                                    "assets/icons/log_active.png",
                                                    width: 36.w,
                                                    height: 36.h,
                                                  ),
                                                  Text(
                                                    "السجل",
                                                    style: TextStyle(
                                                        color: AppColor
                                                            .activeGreen,
                                                        fontSize: 15.sp),
                                                  )
                                                ],
                                              )
                                            : Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/icons/log.svg",
                                                    width: 30.w,
                                                    height: 30.h,
                                                  ),
                                                  Text(
                                                    "السجل",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15.sp),
                                                  )
                                                ],
                                              ),
                                      ),
                                    ]));
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                      body: currentScreen,
                    ),
                  ),
                  AnimatedPositioned(
                    duration: panelTransation,
                    curve: Curves.decelerate,
                    left: 0,
                    right: 0,
                    top: _getTopForPanel(_panelState, size),
                    height: _getSizeForPanel(_panelState, size),
                    child: Container(
                      color: Colors.white,
                      child: AnimatedSwitcher(
                        duration: panelTransation,
                        child: _buildPanelOption(context),
                      ),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }

  Widget _buildPanelOption(BuildContext context) {
    return BlocConsumer<CalculatorPanelBloc, CalculatorPanelState>(
      listener: (context, state) {
        if (state is CalculatorPanelOpened) {
          setState(() {
            _panelState = PanelState.open;
          });
        } else {
          setState(() {
            _panelState = PanelState.hidden;
          });
        }
      },
      builder: (context, state) {
        if (state is CalculatorPanelOpened) {
          if (!calculateFeeScreen) {
            return _buildPanelWidget(context);
          } else {
            return _buildResultPanel(context);
          }
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

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

  List<Extras> items = [];
  Extras? selectedValue;
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
    setState(() {
      _typeAheadController.text = suggestion.label!;
    });
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
    if (valueEnabled) {
      calculateTotalValue();
    } else {
      calculateTotalValueWithPrice();
    }
  }

  Widget _buildPanelWidget(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[200],
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: BlocConsumer<FeeItemBloc, FeeItemState>(
            listener: (context, state) {
              if (state is FeeItemLoadedSuccess) {
                setState(() {
                  _wieghtController.text = "0.0";
                  _valueController.text = "0.0";
                  syrianExchangeValue = "0.0";
                  syrianTotalValue = "0.0";
                  totalValueWithEnsurance = "0.0";
                });
                selectSuggestion(state.fee);
              }
            },
            builder: (context, state) {
              if (state is FeeItemLoadedSuccess) {
                return Column(
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
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: Form(
                          key: _calculatorformkey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                controller: _typeAheadController,
                                enabled: false,
                                decoration: InputDecoration(
                                  labelText: "نوع البضاعة",
                                  prefixStyle:
                                      const TextStyle(color: Colors.black),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              const Visibility(
                                  // visible: allowexport,
                                  child: Text(
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
                                        extentOffset: _wieghtController
                                            .value.text.length),
                                enabled: !valueEnabled,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: wieghtLabel,
                                  prefixText: showunit ? wieghtUnit : "",
                                  prefixStyle:
                                      const TextStyle(color: Colors.black),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
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
                                      label: const Text("المنشأ"),
                                      border: const OutlineInputBorder(),
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
                                        placeholderBuilder: (BuildContext
                                                context) =>
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
                                      ? "قيمة البضاعة الاجمالية بالدولار"
                                      : "سعر الواحدة لدى الجمارك",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
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
                              Visibility(
                                visible: isfeeequal001,
                                child: const SizedBox(
                                  height: 12,
                                ),
                              ),
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
                                              result.fee =
                                                  selectedPackage!.fee!;
                                              result.rawMaterial =
                                                  rawMaterialValue ? 1 : 0;
                                              result.industrial =
                                                  industrialValue ? 1 : 0;
                                              result.totalTax = selectedPackage!
                                                  .totalTaxes!.totalTax!;
                                              result.partialTax =
                                                  selectedPackage!
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
                                                  selectedPackage!
                                                      .protectionFee!;
                                              result.naturalFee =
                                                  selectedPackage!.naturalFee!;
                                              result.taxFee =
                                                  selectedPackage!.taxFee!;
                                              BlocProvider.of<
                                                          CalculateResultBloc>(
                                                      context)
                                                  .add(CalculateTheResultEvent(
                                                      result));
                                              // Navigator.push(
                                              //     context,
                                              //     MaterialPageRoute(
                                              //       builder: (context) =>
                                              //           const TraderCalculatorResultScreen(),
                                              //     ));
                                              setState(() {
                                                calculateFeeScreen = true;
                                              });
                                            },
                                            child: const Text(
                                                "احسب الرسم الجمركي"));
                                      }
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ]);
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      )),
    );
  }

  Widget _buildResultPanel(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: const Text("طلب مخلص"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 40.h,
              ),
              const Text(
                "الضرائب والرسوم",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(
                height: 20.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: BlocBuilder<CalculateResultBloc, CalculateResultState>(
                  builder: (context, state) {
                    if (state is CalculateResultSuccessed) {
                      return ItemTaxesWidget(
                        customsFee: state.result.customsFee!,
                        spendingFee: state.result.spendingFee!,
                        conservativeLocality:
                            state.result.conservativeLocality!,
                        citiesProtectionFee: state.result.citiesProtectionFee!,
                        feeSupportingLocalProduction:
                            state.result.feeSupportingLocalProduction!,
                        imranLocality: state.result.imranLocality!,
                        incomeTaxFee: state.result.incomeTaxFee!,
                        naturalDisasterFee: state.result.naturalDisasterFee!,
                        finalFee: state.result.finalTotal!,
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: BlocBuilder<CalculateResultBloc, CalculateResultState>(
                  builder: (context, state) {
                    if (state is CalculateResultSuccessed) {
                      return PensTaxesWidget(
                        addedTaxes: state.result.addedTaxes!,
                        customsCertificate: state.result.customsCertificate!,
                        billTax: state.result.billTax!,
                        stampFee: state.result.stampFee!,
                        provincialLocalTax: state.result.provincialLocalTax!,
                        advanceIncomeTax: state.result.advanceIncomeTax!,
                        reconstructionFee: state.result.reconstructionFee!,
                        finalTaxes: state.result.finalTaxes!,
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: BlocBuilder<CalculateResultBloc, CalculateResultState>(
                  builder: (context, state) {
                    if (state is CalculateResultSuccessed) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            border: const Border(
                              left: BorderSide(
                                color: Colors.blue,
                                width: 1.0,
                              ),
                              right: BorderSide(
                                color: Colors.blue,
                                width: 1.0,
                              ),
                              top: BorderSide(
                                color: Colors.blue,
                                width: 1.0,
                              ),
                              bottom: BorderSide(
                                color: Colors.blue,
                                width: 1.0,
                              ),
                            ),
                            color: Colors.white),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              "إجمالي الرسوم:",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 22),
                            ),
                            Divider(color: Colors.yellow[800]),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "مجموع الضرائب والرسوم:",
                                  maxLines: 3,
                                ),
                                Text(
                                  state.result.finalTotal!.toStringAsFixed(2),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              const Text(
                  "هذه الرسوم تقديرية ولا تتضمن مصاريف التخليص الجمركي ورسوم الخدمات"),
              SizedBox(
                height: 30.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomButton(
                    onTap: () {
                      setState(() {
                        calculateFeeScreen = false;
                      });
                    },
                    title: const SizedBox(
                        width: 100, child: Center(child: Text("إلغاء"))),
                  ),
                  CustomButton(
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => TraderBillReview(),
                      //     ));
                    },
                    title: const SizedBox(
                        width: 100, child: Center(child: Text("حفظ"))),
                  ),
                  CustomButton(
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => TraderAttachementScreen(),
                      //     ));
                    },
                    title: const SizedBox(
                        width: 100, child: Center(child: Text("طلب مخلص"))),
                  ),
                ],
              ),
              SizedBox(
                height: 30.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
