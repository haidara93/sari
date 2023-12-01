// import 'package:custome_mobile/business_logic/bloc/attachment_type_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/auth_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/calculate_result_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/calculator_panel_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/chapter_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/fee_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/fee_item_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/fee_select_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/flags_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/group_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/package_type_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/post_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/search_section_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/section_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/state_custome_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/sub_chapter_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/trader_log_bloc.dart';
import 'package:custome_mobile/business_logic/cubit/bottom_nav_bar_cubit.dart';
import 'package:custome_mobile/constants/enums.dart';
import 'package:custome_mobile/data/models/accurdion_model.dart';
import 'package:custome_mobile/data/models/package_model.dart';
import 'package:custome_mobile/enum/panel_state.dart';
import 'package:custome_mobile/helpers/color_constants.dart';
import 'package:custome_mobile/helpers/formatter.dart';
import 'package:custome_mobile/views/screens/trader/custome_tariff_screen.dart';
import 'package:custome_mobile/views/screens/trader/log_screens/log_screen.dart';
import 'package:custome_mobile/views/screens/trader/order_broker_screen.dart';
import 'package:custome_mobile/views/screens/trader/trader_calculator_screen.dart';
import 'package:custome_mobile/views/screens/trader/trader_main_screen.dart';
import 'package:custome_mobile/views/widgets/calculator_loading_screen.dart';
import 'package:custome_mobile/views/widgets/custom_app_bar.dart';
import 'package:custome_mobile/views/widgets/custom_botton.dart';
import 'package:custome_mobile/views/widgets/highlight_text.dart';
import 'package:custome_mobile/views/widgets/item_taxes_widget.dart';
import 'package:custome_mobile/views/widgets/pens_taxes_widget.dart';
import 'package:custome_mobile/views/widgets/tariff_info_icon.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_img/flutter_img.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

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
    BlocProvider.of<SectionBloc>(context).add(SectionLoadEvent());

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
    scroll.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    // Check the keyboard visibility when the metrics change
  }

  void changeSelectedValue(
      {required int selectedValue, required BuildContext contxt}) async {
    setState(() {
      navigationValue = selectedValue;
    });
    _tabController.animateTo(selectedValue);

    switch (selectedValue) {
      case 0:
        {
          BlocProvider.of<TraderLogBloc>(context)
              .add(const TraderLogLoadEvent("R"));
          setState(() {
            title = "السجل";

            currentScreen = const LogScreen();
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
          print(MediaQuery.of(context).size.width);
          print(MediaQuery.of(context).size.height);
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

            currentScreen = const CustomeTariffScreen();
          });
          break;
        }
      case 4:
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
                    child: GestureDetector(
                      onTap: () {
                        BlocProvider.of<BottomNavBarCubit>(context).emitShow();
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      child: Scaffold(
                        key: _scaffoldKey,
                        resizeToAvoidBottomInset: false,
                        appBar: CustomAppBar(
                          title: title,
                          scaffoldKey: _scaffoldKey,
                          onTap: () => changeSelectedValue(
                              selectedValue: 2, contxt: context),
                        ),
                        drawer: Drawer(
                          backgroundColor: AppColor.deepAppBarBlue,
                          elevation: 1,
                          width: 250.w,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            child: ListView(children: [
                              SizedBox(
                                height: 35.h,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: AppColor.goldenYellow,
                                    radius: 35.h,
                                  ),
                                  Text(
                                    "Morad",
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
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                trailing: Container(
                                  width: 35.w,
                                  height: 20.h,
                                  decoration: BoxDecoration(
                                      color: AppColor.goldenYellow,
                                      borderRadius: BorderRadius.circular(2)),
                                  child: Center(
                                    child: Text(
                                      "soon",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  changeSelectedValue(
                                      selectedValue: 0, contxt: context);
                                  _scaffoldKey.currentState!.closeDrawer();
                                },
                                child: ListTile(
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
                                trailing: Container(
                                  width: 35.w,
                                  height: 20.h,
                                  decoration: BoxDecoration(
                                      color: AppColor.goldenYellow,
                                      borderRadius: BorderRadius.circular(2)),
                                  child: Center(
                                    child: Text(
                                      "soon",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ),
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
                                trailing: Container(
                                  width: 35.w,
                                  height: 20.h,
                                  decoration: BoxDecoration(
                                      color: AppColor.goldenYellow,
                                      borderRadius: BorderRadius.circular(2)),
                                  child: Center(
                                    child: Text(
                                      "soon",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ),
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
                                trailing: Container(
                                  width: 35.w,
                                  height: 20.h,
                                  decoration: BoxDecoration(
                                      color: AppColor.goldenYellow,
                                      borderRadius: BorderRadius.circular(2)),
                                  child: Center(
                                    child: Text(
                                      "soon",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ),
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
                                      indicatorColor: AppColor.goldenYellow,
                                      labelColor: AppColor.goldenYellow,
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
                                                    SvgPicture.asset(
                                                      "assets/icons/log_active.svg",
                                                      width: 36.w,
                                                      height: 36.h,
                                                    ),
                                                    Text(
                                                      "السجل",
                                                      style: TextStyle(
                                                          color: AppColor
                                                              .goldenYellow,
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
                                        Tab(
                                          // text: "الحاسبة",
                                          height: 66.h,
                                          icon: navigationValue == 1
                                              ? Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/icons/calculator_active.svg",
                                                      width: 36.w,
                                                      height: 36.h,
                                                    ),
                                                    Text(
                                                      "الحاسبة",
                                                      style: TextStyle(
                                                          color: AppColor
                                                              .goldenYellow,
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
                                                    SvgPicture.asset(
                                                      "assets/icons/home_active.svg",
                                                      width: 36.w,
                                                      height: 36.h,
                                                    ),
                                                    Text(
                                                      "الرئيسية",
                                                      style: TextStyle(
                                                          color: AppColor
                                                              .goldenYellow,
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
                                                    SvgPicture.asset(
                                                      "assets/icons/tariff_active.svg",
                                                      width: 36.w,
                                                      height: 36.h,
                                                    ),
                                                    Text(
                                                      "التعرفة",
                                                      style: TextStyle(
                                                          color: AppColor
                                                              .goldenYellow,
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
                                                    SvgPicture.asset(
                                                      "assets/icons/broker_order_active.svg",
                                                      width: 36.w,
                                                      height: 36.h,
                                                    ),
                                                    Text(
                                                      "طلب مخلص",
                                                      style: TextStyle(
                                                          color: AppColor
                                                              .goldenYellow,
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
                                      ]));
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        ),
                        body: currentScreen,
                      ),
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
        if (state is CalculatorPanelOpened || state is TariffPanelOpened) {
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
        } else if (state is TariffPanelOpened) {
          return _buildTariffPanel(context);
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

  double usTosp = 30;
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
  final FocusNode _statenode = FocusNode();

  List<Extras> items = [];
  Extras? selectedValue;
  void calculateTotalValueWithPrice() {
    var syrianExch = double.parse(_wieghtController.text) *
        double.parse(_valueController.text);
    var syrianTotal = syrianExch * 30;
    var totalEnsurance = (syrianTotal) + (syrianTotal * 0.0012);
    setState(() {
      syrianExchangeValue = syrianExch.round().toString();
      syrianTotalValue = syrianTotal.round().toString();
      totalValueWithEnsurance = totalEnsurance.round().toString();
    });
  }

  void calculateTotalValue() {
    var syrianTotal = double.parse(_valueController.text) * 30;
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
        case "كيلو واط بالساعة 1000":
          setState(() {
            wieghtLabel = "  الاستطاعة";
          });
          break;
        case "الاستطاعة بالطن":
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
              syrianExchangeValue = "30";
            });
          }
        }
      }
      if (origin.countryGroups!.isEmpty) {
        setState(() {
          basePrice = 0.0;

          _valueController.text = "0.0";
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
      appBar: AppBar(
        backgroundColor: AppColor.deepBlue,
        title: const Text(
          "احسب الرسوم",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: GestureDetector(
            onTap: () {
              setState(() {
                selected = -1;
                chapterselected = -1;
                subchapterselected = -1;
                feeselected = -1;
              });
              BlocProvider.of<CalculatorPanelBloc>(context)
                  .add(CalculatorPanelHideEvent());
            },
            child: const Icon(Icons.arrow_back, color: Colors.white)),
        elevation: 0,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
            BlocProvider.of<BottomNavBarCubit>(context).emitShow();
          },
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
                          height: 25,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 35, horizontal: 15),
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
                                  maxLines: null,
                                  decoration: InputDecoration(
                                    labelText: "نوع البضاعة",
                                    prefixStyle: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 19,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 9.0, vertical: 11.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 12,
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
                                                child: Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                      bottom: BorderSide(
                                                          color: AppColor
                                                              .goldenYellow,
                                                          width: 1),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    item.label!,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                    ),
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
                                              syrianExchangeValue = "30";
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
                                              syrianExchangeValue = "30";
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
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Focus(
                                  focusNode: _statenode,
                                  onFocusChange: (bool focus) {
                                    if (!focus) {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      BlocProvider.of<BottomNavBarCubit>(
                                              context)
                                          .emitShow();
                                    }
                                  },
                                  child: TextFormField(
                                    controller: _wieghtController,
                                    onTap: () => _wieghtController.selection =
                                        TextSelection(
                                            baseOffset: 0,
                                            extentOffset: _wieghtController
                                                .value.text.length),
                                    // enabled: !valueEnabled,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            signed: true, decimal: true),
                                    inputFormatters: [DecimalFormatter()],
                                    decoration: InputDecoration(
                                      labelText: wieghtLabel,
                                      prefixText: showunit ? wieghtUnit : "",
                                      prefixStyle: const TextStyle(
                                        color: Colors.black,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 9.0, vertical: 11.0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
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
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                BlocBuilder<FlagsBloc, FlagsState>(
                                  builder: (context, flagstate) {
                                    if (flagstate is FlagsLoadedSuccess) {
                                      return DropdownButtonHideUnderline(
                                        child: DropdownButton2<Origin>(
                                          isExpanded: true,
                                          hint: Text(
                                            " اختر المنشأ",
                                            style: TextStyle(
                                              fontSize: 15,
                                              color:
                                                  Theme.of(context).hintColor,
                                            ),
                                          ),
                                          items: flagstate.origins
                                              .map((Origin item) =>
                                                  DropdownMenuItem<Origin>(
                                                    value: item,
                                                    child: SizedBox(
                                                      // width: 200,
                                                      child: Row(
                                                        children: [
                                                          SvgPicture.network(
                                                            item.imageURL!,
                                                            height: 35,
                                                            // semanticsLabel: 'A shark?!',
                                                            placeholderBuilder:
                                                                (BuildContext
                                                                        context) =>
                                                                    const CircularProgressIndicator(),
                                                          ),
                                                          const SizedBox(
                                                              width: 7),
                                                          Container(
                                                            constraints:
                                                                BoxConstraints(
                                                              maxWidth: 280.w,
                                                            ),
                                                            child: Text(
                                                              item.label!,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
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
                                          dropdownSearchData:
                                              DropdownSearchData(
                                            searchController: _originController,
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
                                                controller: _originController,
                                                onTap: () {
                                                  _originController.selection =
                                                      TextSelection(
                                                          baseOffset: 0,
                                                          extentOffset:
                                                              _originController
                                                                  .value
                                                                  .text
                                                                  .length);
                                                },
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                    horizontal: 10,
                                                    vertical: 8,
                                                  ),
                                                  hintText: 'اختر المنشأ',
                                                  hintStyle: const TextStyle(
                                                      fontSize: 12),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            searchMatchFn: (item, searchValue) {
                                              return item.value!.label!
                                                  .contains(searchValue);
                                            },
                                          ),
                                          onMenuStateChange: (isOpen) {
                                            if (isOpen) {
                                              setState(() {
                                                _originController.clear();
                                              });
                                            }
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
                                            // elevation: 2,
                                          ),
                                          iconStyleData: const IconStyleData(
                                            icon: Icon(
                                              Icons.keyboard_arrow_down_sharp,
                                            ),
                                            iconSize: 20,
                                            iconEnabledColor:
                                                AppColor.AccentBlue,
                                            iconDisabledColor: Colors.grey,
                                          ),
                                          dropdownStyleData: DropdownStyleData(
                                            width: double.infinity,
                                            maxHeight: MediaQuery.of(context)
                                                    .size
                                                    .height -
                                                160.h,
                                            padding: const EdgeInsets.all(8.0),
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
                                                  MaterialStateProperty.all(
                                                      true),
                                            ),
                                          ),
                                          menuItemStyleData:
                                              const MenuItemStyleData(
                                            height: 40,
                                          ),
                                        ),
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
                                    }
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
                                Visibility(
                                  visible: originerror,
                                  child: const SizedBox(
                                    height: 12,
                                  ),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Focus(
                                  focusNode: _statenode,
                                  onFocusChange: (bool focus) {
                                    if (!focus) {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      BlocProvider.of<BottomNavBarCubit>(
                                              context)
                                          .emitShow();
                                    }
                                  },
                                  child: TextFormField(
                                    controller: _valueController,
                                    onTap: () => _valueController.selection =
                                        TextSelection(
                                            baseOffset: 0,
                                            extentOffset: _valueController
                                                .value.text.length),
                                    // enabled: valueEnabled,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            signed: true, decimal: true),
                                    inputFormatters: [DecimalFormatter()],
                                    decoration: InputDecoration(
                                      labelText: valueEnabled
                                          ? "قيمة البضاعة الاجمالية بالدولار"
                                          : "سعر الواحدة لدى الجمارك",
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 9.0, vertical: 11.0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
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
                                    BlocConsumer<CalculateResultBloc,
                                        CalculateResultState>(
                                      listener: (context, state) {
                                        if (state
                                            is CalculateResultSuccessed) {}
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
                                          return CustomButton(
                                              onTap: () {
                                                result.insurance = int.parse(
                                                    totalValueWithEnsurance);
                                                result.fee =
                                                    selectedPackage!.fee!;
                                                result.rawMaterial =
                                                    rawMaterialValue ? 1 : 0;
                                                result.industrial =
                                                    industrialValue ? 1 : 0;
                                                result.totalTax =
                                                    selectedPackage!
                                                        .totalTaxes!.totalTax!;
                                                result.partialTax =
                                                    selectedPackage!.totalTaxes!
                                                        .partialTax!;
                                                result.origin =
                                                    selectedOrigin!.label!;
                                                result.spendingFee =
                                                    selectedPackage!
                                                        .spendingFee!;
                                                result.supportFee =
                                                    selectedPackage!
                                                        .supportFee!;
                                                result.localFee =
                                                    selectedPackage!.localFee!;
                                                result.protectionFee =
                                                    selectedPackage!
                                                        .protectionFee!;
                                                result.naturalFee =
                                                    selectedPackage!
                                                        .naturalFee!;
                                                result.taxFee =
                                                    selectedPackage!.taxFee!;
                                                BlocProvider.of<
                                                            CalculateResultBloc>(
                                                        context)
                                                    .add(
                                                        CalculateTheResultEvent(
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
                                              title: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8.0,
                                                    horizontal: 12.w),
                                                child: const Text(
                                                    "احسب الرسم الجمركي"),
                                              ));
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
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
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
          backgroundColor: AppColor.deepBlue,
          title: const Text(
            "الضرائب والرسوم",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          leading: GestureDetector(
              onTap: () {
                setState(() {
                  calculateFeeScreen = false;
                });
              },
              child: const Icon(Icons.arrow_back, color: Colors.white)),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
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
                      return const CalculatorLoadingScreen();
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
                      return const CalculatorLoadingScreen();
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
                            Divider(color: AppColor.goldenYellow),
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
                      return const CalculatorLoadingScreen();
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
                        width: 100, child: Center(child: Text("رجوع"))),
                  ),
                  // CustomButton(
                  //   onTap: () {
                  //     // Navigator.push(
                  //     //     context,
                  //     //     MaterialPageRoute(
                  //     //       builder: (context) => TraderBillReview(),
                  //     //     ));
                  //   },
                  //   title: const SizedBox(
                  //       width: 100, child: Center(child: Text("حفظ"))),
                  // ),
                  // CustomButton(
                  //   onTap: () {
                  //     // Navigator.push(
                  //     //     context,
                  //     //     MaterialPageRoute(
                  //     //       builder: (context) => TraderAttachementScreen(),
                  //     //     ));
                  //   },
                  //   title: const SizedBox(
                  //       width: 100, child: Center(child: Text("طلب مخلص"))),
                  // ),
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

  int? selected;
  int? chapterselected;
  int? subchapterselected;
  int? feeselected = -1;
  String? feeselectedId;
  bool shownote = false;
  NoteType noteType = NoteType.None;
  final ScrollController scroll = ScrollController();
  bool isSearch = false;
  final TextEditingController _searchController = TextEditingController();

  Widget _buildTariffPanel(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: AppColor.deepBlue,
          title: const Text(
            "اختر البند الجمركي",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          leading: GestureDetector(
              onTap: () {
                setState(() {
                  selected = -1;
                  chapterselected = -1;
                  subchapterselected = -1;
                  feeselected = -1;
                });
                BlocProvider.of<CalculatorPanelBloc>(context)
                    .add(CalculatorPanelHideEvent());
              },
              child: const Icon(Icons.arrow_back, color: Colors.white)),
          elevation: 0,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Focus(
                      focusNode: _statenode,
                      onFocusChange: (bool focus) {
                        if (!focus) {
                          BlocProvider.of<BottomNavBarCubit>(context)
                              .emitShow();
                          FocusManager.instance.primaryFocus?.unfocus();
                        }
                      },
                      child:
                          BlocListener<SearchSectionBloc, SearchSectionState>(
                        listener: (context, state) {
                          if (state is SearchSectionLoadedSuccess) {
                            // print(jsonEncode(state.sections));
                          }
                          if (state is SearchSectionLoadedFailed) {
                            print(state.error);
                          }
                        },
                        child: TextFormField(
                          controller: _searchController,
                          onTap: () {
                            BlocProvider.of<BottomNavBarCubit>(context)
                                .emitHide();
                            _searchController.selection = TextSelection(
                                baseOffset: 0,
                                extentOffset:
                                    _searchController.value.text.length);
                          },
                          scrollPadding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom +
                                  50),
                          decoration: InputDecoration(
                            labelText: "بحث",
                            suffixIcon: InkWell(
                              onTap: () {
                                BlocProvider.of<BottomNavBarCubit>(context)
                                    .emitShow();
                                FocusManager.instance.primaryFocus?.unfocus();

                                if (_searchController.text.isNotEmpty) {
                                  BlocProvider.of<SearchSectionBloc>(context)
                                      .add(SearchSectionLoadEvent(
                                          _searchController.text));
                                  setState(() {
                                    isSearch = true;
                                  });
                                }
                              },
                              child: const Icon(
                                Icons.search,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            if (value.isEmpty) {
                              setState(() {
                                isSearch = false;
                              });
                            }
                          },
                          onFieldSubmitted: (value) {
                            BlocProvider.of<BottomNavBarCubit>(context)
                                .emitShow();
                            _searchController.text = value;
                            if (value.isNotEmpty) {
                              BlocProvider.of<SearchSectionBloc>(context)
                                  .add(SearchSectionLoadEvent(value));
                              setState(() {
                                isSearch = true;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  isSearch
                      ? BlocBuilder<SearchSectionBloc, SearchSectionState>(
                          builder: (context, state) {
                            if (state is SearchSectionLoadedSuccess) {
                              return ListView.builder(
                                key: Key('builder ${selected.toString()}'),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: state.sections.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 4.h, horizontal: 3.w),
                                    clipBehavior: Clip.none,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      side: BorderSide(
                                          color: AppColor.goldenYellow,
                                          width: 2),
                                    ),
                                    color: Colors.white,
                                    // decoration: BoxDecoration(
                                    //   borderRadius: BorderRadius.circular(10),
                                    //   border: selected == index
                                    //       ? Border.all(
                                    //           color: Colors.yellow[600]!, width: 2)
                                    //       : null,
                                    // ),
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                          dividerColor: Colors.transparent),
                                      child: ExpansionTile(
                                        key: Key(index.toString()), //attention
                                        initiallyExpanded: true,
                                        tilePadding: EdgeInsets.symmetric(
                                            horizontal: 5.w),

                                        title: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 65.w,
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    width: 36.w,
                                                    height: 36.h,
                                                    child: Img(
                                                      "https://across-mena.com${state.sections[index]!.image!}",
                                                      placeholder: Container(
                                                        color: Colors.grey[200],
                                                        width: 36.w,
                                                        height: 36.h,
                                                      ),
                                                      errorWidget: Container(
                                                        color: Colors.grey[200],
                                                        width: 36.w,
                                                        height: 36.h,
                                                        child: const Center(
                                                            child:
                                                                Text("error")),
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    "(${state.sections[index]!.end!}__${state.sections[index]!.start!})",
                                                    style: const TextStyle(
                                                        fontSize: 14),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5.w,
                                            ),
                                            Flexible(
                                              child: HighlightText(
                                                highlightStyle: TextStyle(
                                                  height: 1.3,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColor.goldenYellow,
                                                ),
                                                style: const TextStyle(
                                                  height: 1.3,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                text: state
                                                    .sections[index]!.label!,
                                                highlight:
                                                    _searchController.text,
                                                ignoreCase: false,
                                              ),
                                            ),
                                          ],
                                        ),

                                        children: buildSearchChapterTiles(
                                            state.sections[index]!.chapterSet!),
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else if (state is SearchSectionLoading) {
                              return Shimmer.fromColors(
                                baseColor: (Colors.grey[300])!,
                                highlightColor: (Colors.grey[100])!,
                                enabled: true,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemBuilder: (_, __) => Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 3),
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: SizedBox(
                                      height: 90.h,
                                    ),
                                  ),
                                  itemCount: 10,
                                ),
                              );
                            } else {
                              return Center(
                                child: GestureDetector(
                                  onTap: () {
                                    // BlocProvider.of<SectionBloc>(context)
                                    //     .add(SectionLoadEvent());
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
                        )
                      : Padding(
                          padding: EdgeInsets.all(8.h),
                          child: BlocConsumer<SectionBloc, SectionState>(
                            listener: (context, state) {
                              // if(state is)
                            },
                            builder: (context, state) {
                              if (state is SectionLoadedSuccess) {
                                return ListView.builder(
                                  key: Key('builder ${selected.toString()}'),
                                  shrinkWrap: true,
                                  controller: scroll,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: state.sections.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      margin: EdgeInsets.symmetric(
                                          vertical: 4.h, horizontal: 3.w),
                                      clipBehavior: Clip.none,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                        side: BorderSide(
                                            color: AppColor.goldenYellow,
                                            width: 2),
                                      ),
                                      color: Colors.white,
                                      child: Theme(
                                        data: Theme.of(context).copyWith(
                                            dividerColor: Colors.transparent),
                                        child: ExpansionTile(
                                          key:
                                              Key(index.toString()), //attention
                                          initiallyExpanded: index == selected,
                                          tilePadding: EdgeInsets.symmetric(
                                              horizontal: 5.w),
                                          title: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              // Padding(
                                              //   padding: const EdgeInsets.symmetric(
                                              //       horizontal: 3),
                                              //   child: SizedBox(
                                              //     width: 36.w,
                                              //     height: 36.h,
                                              //     child: Img(
                                              //       state.sections[index].image!,
                                              //     ),
                                              //   ),
                                              // ),
                                              SizedBox(
                                                width: 65.w,
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      width: 36.w,
                                                      height: 36.h,
                                                      child: Img(
                                                        state.sections[index]!
                                                            .image!,
                                                        placeholder: Container(
                                                          color:
                                                              Colors.grey[200],
                                                          width: 36.w,
                                                          height: 36.h,
                                                        ),
                                                        errorWidget: Container(
                                                          color:
                                                              Colors.grey[200],
                                                          width: 36.w,
                                                          height: 36.h,
                                                          child: const Center(
                                                              child: Text(
                                                                  "error")),
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      "(${state.sections[index]!.end!}__${state.sections[index]!.start!})",
                                                      style: const TextStyle(
                                                          fontSize: 14),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5.w,
                                              ),
                                              Flexible(
                                                child: Text(
                                                  state.sections[index]!.label!,
                                                  maxLines: 10,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),

                                          onExpansionChanged: (value) {
                                            if (value) {
                                              BlocProvider.of<ChapterBloc>(
                                                      context)
                                                  .add(ChapterLoadEvent(state
                                                      .sections[index]!.id!));
                                              setState(() {
                                                selected = index;
                                                chapterselected = -1;
                                                subchapterselected = -1;
                                              });

                                              scroll.animateTo(
                                                  index +
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          2,
                                                  duration: const Duration(
                                                      seconds: 1),
                                                  curve: Curves.easeIn);
                                            } else {
                                              setState(() {
                                                selected = -1;
                                                shownote = false;
                                                noteType = NoteType.None;
                                              });
                                            }
                                          },
                                          children: buildChapterTiles(),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              } else if (state is SectionLoadingProgress) {
                                return Shimmer.fromColors(
                                  baseColor: (Colors.grey[300])!,
                                  highlightColor: (Colors.grey[100])!,
                                  enabled: true,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemBuilder: (_, __) => Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 3),
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: SizedBox(
                                        height: 90.h,
                                      ),
                                    ),
                                    itemCount: 10,
                                  ),
                                );
                              } else {
                                return Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      BlocProvider.of<SectionBloc>(context)
                                          .add(SectionLoadEvent());
                                    },
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                        ),
                  SizedBox(
                    height: 70.h,
                  )
                ],
              ),
            ),
            Visibility(
              visible: feeselected != -1,
              child: Positioned(
                bottom: 0.h,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  color: AppColor.deepBlue,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // CustomButton(
                      //   onTap: () {
                      //     setState(() {
                      //       feeselected = -1;
                      //       feeselectedId = "";
                      //     });
                      //   },
                      //   color: Colors.white,
                      //   bordercolor: Colors.red,
                      //   title: const SizedBox(
                      //       width: 100, child: Center(child: Text("إلغاء"))),
                      // ),
                      CustomButton(
                        onTap: () {
                          setState(() {
                            selected = -1;
                            chapterselected = -1;
                            subchapterselected = -1;
                            feeselected = -1;
                            _searchController.text = "";
                            isSearch = false;
                          });
                          BlocProvider.of<FeeSelectBloc>(context)
                              .add(FeeSelectLoadEvent(id: feeselectedId!));
                          BlocProvider.of<CalculatorPanelBloc>(context)
                              .add(CalculatorPanelHideEvent());
                        },
                        color: Colors.white,
                        bordercolor: Colors.green,
                        title: SizedBox(
                            width: 100.w,
                            child: const Center(child: Text("موافق"))),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  buildSearchChapterTiles(List<ChapterSet?> chapters) {
    // _CustomeTariffScreenState? stateobject =
    //     context.findAncestorStateOfType<_CustomeTariffScreenState>();
    List<Widget> list = [];
    list.add(Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.only(top: 3.0),
      child: ListView.builder(
        key: Key('chapterbuilder ${chapterselected.toString()}'),
        shrinkWrap: true,
        itemCount: chapters.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index2) {
          return Column(
            children: [
              Card(
                margin: const EdgeInsets.all(2),
                clipBehavior: Clip.antiAlias,
                elevation: 1,
                color: Colors.grey[200],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                      color: Colors.grey[200]!,
                      // color: chapterselected == index2
                      //     ? subchapterselected == -1
                      //         ? AppColor.goldenYellow
                      //         : Colors.grey[200]!
                      //     : Colors.grey[200]!,
                      width: 2),
                ),
                child: ListTileTheme(
                  contentPadding: const EdgeInsets.all(0),
                  dense: true,
                  horizontalTitleGap: 0.0,
                  minLeadingWidth: 0,
                  child: ExpansionTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 17.w,
                        ),
                        Flexible(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                chapters[index2]!.id!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Flexible(
                                child: HighlightText(
                                  highlightStyle: TextStyle(
                                    height: 1.3,
                                    fontSize: 17,
                                    color: AppColor.goldenYellow,
                                  ),
                                  style: const TextStyle(
                                    height: 1.3,
                                    fontSize: 17,
                                  ),
                                  text: chapters[index2]!.label!,
                                  highlight: _searchController.text,
                                  ignoreCase: false,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    key: Key(index2.toString()), //attention
                    initiallyExpanded: true,
                    children: buildSearchSubChapterTiles(
                        chapters[index2]!.subChapterSet!),
                  ),
                ),
              ),
              chapters.length - 1 == index2
                  ? const SizedBox.shrink()
                  : Divider(
                      height: 1,
                      color: AppColor.goldenYellow,
                    ),
            ],
          );
        },
      ),
    ));

    return list;
  }

  buildSearchSubChapterTiles(List<SubChapterSet?> subchapters) {
    List<Widget> list = [];
    list.add(Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 0.0),
      child: ListView.builder(
        key: Key('subchapterbuilder ${subchapterselected.toString()}'),
        shrinkWrap: true,
        itemCount: subchapters.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index3) {
          return Column(
            children: [
              Card(
                margin: const EdgeInsets.all(2),
                clipBehavior: Clip.antiAlias,
                elevation: subchapterselected == index3 ? 1 : 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                      color: subchapterselected == index3
                          ? feeselected == -1
                              ? AppColor.goldenYellow
                              : Colors.white
                          : Colors.white,
                      width: 2),
                ),
                child: ExpansionTile(
                  key: Key(index3.toString()), //attention
                  initiallyExpanded: true,
                  tilePadding: EdgeInsets.zero,

                  // controlAffinity: ListTileControlAffinity.leading,
                  childrenPadding: EdgeInsets.zero,
                  // leading: Container(
                  //   margin: EdgeInsets.symmetric(horizontal: 7),
                  //   child: subchapterselected == index3
                  //       ? const Icon(Icons.remove)
                  //       : const Icon(Icons.add),
                  // ),
                  // leading: const SizedBox.shrink(),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 15.w,
                      ),
                      Flexible(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              subchapters[index3]!.id!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Flexible(
                              child: HighlightText(
                                highlightStyle: TextStyle(
                                  height: 1.3,
                                  fontSize: 17,
                                  color: AppColor.goldenYellow,
                                ),
                                style: const TextStyle(
                                  height: 1.3,
                                  fontSize: 17,
                                ),
                                text: subchapters[index3]!.label!,
                                highlight: _searchController.text,
                                ignoreCase: false,
                              ),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                          ],
                        ),
                      ),
                      // GestureDetector(
                      //   onTap: () {},
                      //   child: const TariffInfoIcon(),
                      // ),
                    ],
                  ),

                  children: subchapters[index3]!.feeSet == null
                      ? []
                      : buildSearchFeesTiles(subchapters[index3]!.feeSet!),
                ),
              ),
              subchapters.length - 1 == index3
                  ? const SizedBox.shrink()
                  : Divider(
                      height: 1,
                      color: AppColor.goldenYellow,
                    ),
            ],
          );
        },
      ),
    ));

    return list;
  }

  buildSearchFeesTiles(List<FeeSet?> feeslist) {
    List<Widget> list = [];
    List<FeeSet?> fees = [];
    for (var element in feeslist) {
      if (fees.singleWhere((it) => it!.id == element!.id, orElse: () => null) ==
          null) {
        fees.add(element);
      }
    }
    list.add(Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.all(3.0),
      child: ListView.builder(
        key: Key('feebuilder ${feeselected.toString()}'),
        shrinkWrap: true,
        itemCount: fees.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index4) {
          return Container(
            margin: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    if (feeselected == index4) {
                      setState(() {
                        feeselected = -1;
                        feeselectedId = "";
                      });
                    } else {
                      setState(() {
                        feeselected = index4;
                        feeselectedId = fees[index4]!.id!;
                      });
                    }
                  },
                  child: Row(
                    children: [
                      Flexible(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 2.w,
                            ),
                            Text(
                              fees[index4]!.id!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Flexible(
                                child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: feeselected == index4
                                    ? null
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: HighlightText(
                                highlightStyle: TextStyle(
                                  height: 1.3,
                                  fontSize: 17,
                                  color: AppColor.goldenYellow,
                                ),
                                style: const TextStyle(
                                  height: 1.3,
                                  fontSize: 17,
                                ),
                                text: fees[index4]!.label!,
                                highlight: _searchController.text,
                                ignoreCase: false,
                              ),
                            )),
                          ],
                        ),
                      ),
                      feeselected == index4
                          ? const Icon(
                              Icons.check_box_outlined,
                              color: Colors.green,
                            )
                          : Icon(
                              Icons.check_box_outline_blank,
                              color: AppColor.deepBlue,
                            ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                index4 == (fees.length - 1)
                    ? const SizedBox.shrink()
                    : Divider(
                        height: 1,
                        color: AppColor.goldenYellow,
                      ),
              ],
            ),
          );
        },
      ),
    ));

    return list;
  }

  buildFeesTiles(int index3) {
    List<Widget> list = [];
    list.add(BlocBuilder<FeeBloc, FeeState>(
      builder: (context, state) {
        if (state is FeeLoadedSuccess) {
          return Container(
            color: Colors.grey[200],
            child: ListView.builder(
              key: Key('feebuilder ${feeselected.toString()}'),
              shrinkWrap: true,
              itemCount: state.fees.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index4) {
                return Container(
                  margin: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          if (feeselected == index4) {
                            setState(() {
                              feeselected = -1;
                              feeselectedId = "";
                            });
                          } else {
                            setState(() {
                              feeselected = index4;
                              feeselectedId = state.fees[index4].id!;
                            });
                          }
                        },
                        child: Row(
                          children: [
                            Flexible(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 2.w,
                                  ),
                                  Text(
                                    state.fees[index4].id!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Flexible(
                                      child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: feeselected == index4
                                          ? null
                                          : Colors.grey[200],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      state.fees[index4].label!,
                                      style: const TextStyle(
                                        height: 1.3,
                                        fontSize: 17,
                                      ),
                                      maxLines: 10,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )),
                                ],
                              ),
                            ),
                            feeselected == index4
                                ? const Icon(
                                    Icons.check_box_outlined,
                                    color: Colors.green,
                                  )
                                : Icon(
                                    Icons.check_box_outline_blank,
                                    color: AppColor.deepBlue,
                                  ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      index4 != (state.fees.length - 1)
                          ? const Divider(
                              height: 1,
                              color: Color.fromARGB(255, 229, 215, 94),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                );
              },
            ),
          );
        } else {
          return Shimmer.fromColors(
            baseColor: (Colors.grey[300])!,
            highlightColor: (Colors.grey[100])!,
            enabled: true,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * .65,
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (_, __) => Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 3),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SizedBox(
                    height: 40.h,
                  ),
                ),
                itemCount: 4,
              ),
            ),
          );
        }
      },
    ));
    return list;
  }

  buildSubChapterTiles(int index2) {
    List<Widget> list = [];
    list.add(BlocBuilder<SubChapterBloc, SubChapterState>(
      builder: (context, state) {
        if (state is SubChapterLoadedSuccess) {
          return Container(
            color: Colors.white,
            child: ListView.builder(
              key: Key('subchapterbuilder ${subchapterselected.toString()}'),
              shrinkWrap: true,
              itemCount: state.subchapters.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index3) {
                return Column(
                  children: [
                    Card(
                      margin: const EdgeInsets.all(2),
                      clipBehavior: Clip.antiAlias,
                      // decoration: BoxDecoration(
                      //   color: subchapterselected == index3
                      //       ? Colors.white
                      //       : null,
                      //   border: subchapterselected == index3
                      //       ? feeselected == -1
                      //           ? Border.all(
                      //               color: AppColor.goldenYellow, width: 2)
                      //           : null
                      //       : null,
                      //   borderRadius: BorderRadius.circular(10),
                      // ),
                      elevation: subchapterselected == index3 ? 1 : 0,
                      color: subchapterselected == index3
                          ? Colors.white
                          : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                            color: subchapterselected == index3
                                ? feeselected == -1
                                    ? AppColor.goldenYellow
                                    : Colors.white
                                : Colors.white,
                            width: 2),
                      ),
                      child: ExpansionTile(
                        key: Key(index3.toString()), //attention
                        initiallyExpanded: index3 == subchapterselected,
                        tilePadding: EdgeInsets.zero,
                        childrenPadding: EdgeInsets.zero,
                        title: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 11.w,
                            ),
                            Text(
                              state.subchapters[index3].id!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Flexible(
                                child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              width: double.infinity,
                              child: Text(
                                state.subchapters[index3].label!,
                                maxLines: 10,
                                style: const TextStyle(
                                  height: 1.3,
                                  fontSize: 17,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            )),
                          ],
                        ),

                        onExpansionChanged: (value) {
                          if (value) {
                            BlocProvider.of<FeeBloc>(context).add(
                                FeeLoadEvent(state.subchapters[index3].id!));
                            setState(() {
                              subchapterselected = index3;
                            });
                          } else {
                            setState(() {
                              subchapterselected = -1;
                              shownote = false;
                              noteType = NoteType.None;
                            });
                          }
                        },
                        children: buildFeesTiles(index3),
                      ),
                    ),
                    index3 != state.subchapters.length - 1
                        ? const Divider(
                            height: 1,
                            color: Color.fromARGB(255, 229, 215, 94),
                          )
                        : const SizedBox.shrink(),
                  ],
                );
              },
            ),
          );
        } else {
          return Shimmer.fromColors(
            baseColor: (Colors.grey[300])!,
            highlightColor: (Colors.grey[100])!,
            enabled: true,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * .7,
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (_, __) => Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 3),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SizedBox(
                    height: 40.h,
                  ),
                ),
                itemCount: 4,
              ),
            ),
          );
        }
      },
    ));

    return list;
  }

  buildChapterTiles() {
    // _CustomeTariffScreenState? stateobject =
    //     context.findAncestorStateOfType<_CustomeTariffScreenState>();
    List<Widget> list = [];
    list.add(BlocBuilder<ChapterBloc, ChapterState>(
      builder: (context, state) {
        if (state is ChapterLoadedSuccess) {
          return Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.only(top: 3.0),
            child: ListView.builder(
              key: Key('chapterbuilder ${chapterselected.toString()}'),
              shrinkWrap: true,
              itemCount: state.chapters.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index2) {
                return Column(
                  children: [
                    Card(
                      margin: const EdgeInsets.all(2),
                      clipBehavior: Clip.antiAlias,
                      elevation: chapterselected == index2 ? 1 : 0,
                      color: chapterselected == index2
                          ? Colors.grey[200]
                          : Colors.grey[200],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                            color: chapterselected == index2
                                ? subchapterselected == -1
                                    ? AppColor.goldenYellow
                                    : Colors.grey[200]!
                                : Colors.grey[200]!,
                            width: 2),
                      ),
                      child: ListTileTheme(
                        contentPadding: EdgeInsets.symmetric(horizontal: 9.w),
                        dense: true,
                        horizontalTitleGap: 0.0,
                        minLeadingWidth: 0,
                        child: ExpansionTile(
                          title: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 6.w,
                              ),
                              Text(
                                state.chapters[index2].id!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Flexible(
                                  child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  state.chapters[index2].label!,
                                  style: const TextStyle(
                                    height: 1.3,
                                    fontSize: 17,
                                  ),
                                  maxLines: 10,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )),
                            ],
                          ),
                          key: Key(index2.toString()), //attention
                          initiallyExpanded: index2 == chapterselected,

                          onExpansionChanged: (value) {
                            if (value) {
                              BlocProvider.of<SubChapterBloc>(context).add(
                                  SubChapterLoadEvent(
                                      state.chapters[index2].id!));
                              setState(() {
                                chapterselected = index2;

                                subchapterselected = -1;
                              });
                            } else {
                              setState(() {
                                chapterselected = -1;
                                shownote = false;
                                noteType = NoteType.None;
                              });
                            }
                          },
                          children: buildSubChapterTiles(index2),
                        ),
                      ),
                    ),
                    index2 != (state.chapters.length - 1)
                        ? const Divider(
                            height: 1,
                            color: Color.fromARGB(255, 229, 215, 94),
                          )
                        : const SizedBox.shrink(),
                  ],
                );
              },
            ),
          );
        } else {
          return Shimmer.fromColors(
            baseColor: (Colors.grey[300])!,
            highlightColor: (Colors.grey[100])!,
            enabled: true,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * .75,
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (_, __) => Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 3),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SizedBox(
                    height: 40.h,
                  ),
                ),
                itemCount: 4,
              ),
            ),
          );
        }
      },
    ));

    return list;
  }
}
