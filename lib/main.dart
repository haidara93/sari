import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:custome_mobile/business_logic/bloc/additional_attachment_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/attachment_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/attachment_type_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/attachments_list_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/auth_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/calculate_result_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/calculator_panel_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/chapter_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/cost_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/fee_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/fee_item_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/fee_select_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/fee_trade_description_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/flags_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/group_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/note_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/offer_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/package_type_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/post_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/saved_post_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/search_section_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/section_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/state_custome_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/sub_chapter_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/trader_additional_attachment_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/trader_log_bloc.dart';
import 'package:custome_mobile/business_logic/cubit/bottom_nav_bar_cubit.dart';
import 'package:custome_mobile/business_logic/cubit/internet_cubit.dart';
import 'package:custome_mobile/data/repositories/accurdion_repository.dart';
import 'package:custome_mobile/data/repositories/auth_repository.dart';
import 'package:custome_mobile/data/repositories/post_repository.dart';
import 'package:custome_mobile/data/repositories/state_agency_repository.dart';
// import 'package:custome_mobile/firebase_options.dart';
import 'package:custome_mobile/helpers/color_constants.dart';
import 'package:custome_mobile/views/control_view.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'views/screens/introduction_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  final prefs = await SharedPreferences.getInstance();
  final showHome = prefs.getBool("showHome") ?? false;
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp(showHome: showHome));
}

class MyApp extends StatelessWidget {
  final bool showHome;
  MyApp({super.key, required this.showHome});
  final Connectivity connectivity = Connectivity();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return ScreenUtilInit(
          designSize: orientation == Orientation.portrait
              ? const Size(428, 926)
              : const Size(926, 428),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MultiRepositoryProvider(
              providers: [
                RepositoryProvider(
                  create: (context) => AuthRepository(),
                ),
                RepositoryProvider(
                  create: (context) => PostRepository(),
                ),
                RepositoryProvider(
                  create: (context) => AccordionRepository(),
                ),
                RepositoryProvider(
                  create: (context) => StateAgencyRepository(),
                ),
              ],
              child: MultiBlocProvider(
                providers: [
                  BlocProvider(
                      create: (context) => AuthBloc(
                          authRepository:
                              RepositoryProvider.of<AuthRepository>(context))),
                  BlocProvider(
                    create: (context) => PostBloc(
                        postRepository:
                            RepositoryProvider.of<PostRepository>(context)),
                  ),
                  BlocProvider(
                    create: (context) => SearchSectionBloc(
                        accordionRepository:
                            RepositoryProvider.of<AccordionRepository>(
                                context)),
                  ),
                  BlocProvider(
                    create: (context) => SectionBloc(
                        accordionRepository:
                            RepositoryProvider.of<AccordionRepository>(
                                context)),
                  ),
                  BlocProvider(
                    create: (context) => ChapterBloc(
                        accordionRepository:
                            RepositoryProvider.of<AccordionRepository>(
                                context)),
                  ),
                  BlocProvider(
                    create: (context) => SubChapterBloc(
                        accordionRepository:
                            RepositoryProvider.of<AccordionRepository>(
                                context)),
                  ),
                  BlocProvider(
                    create: (context) => FeeBloc(
                        accordionRepository:
                            RepositoryProvider.of<AccordionRepository>(
                                context)),
                  ),
                  BlocProvider(
                    create: (context) => FeeTradeDescriptionBloc(
                        accordionRepository:
                            RepositoryProvider.of<AccordionRepository>(
                                context)),
                  ),
                  BlocProvider(
                    create: (context) => PackageTypeBloc(
                        stateAgencyRepository:
                            RepositoryProvider.of<StateAgencyRepository>(
                                context)),
                  ),
                  BlocProvider(
                    create: (context) => OfferBloc(
                        stateAgencyRepository:
                            RepositoryProvider.of<StateAgencyRepository>(
                                context)),
                  ),
                  BlocProvider(
                    create: (context) => GroupBloc(
                        postRepository:
                            RepositoryProvider.of<PostRepository>(context)),
                  ),
                  BlocProvider(
                    create: (context) => SavedPostBloc(
                        postRepository:
                            RepositoryProvider.of<PostRepository>(context)),
                  ),
                  BlocProvider(
                    create: (context) => CostBloc(
                        stateAgencyRepository:
                            RepositoryProvider.of<StateAgencyRepository>(
                                context)),
                  ),
                  BlocProvider(
                    create: (context) => TraderLogBloc(
                        stateAgencyRepository:
                            RepositoryProvider.of<StateAgencyRepository>(
                                context)),
                  ),
                  BlocProvider(
                    create: (context) => StateCustomeBloc(
                        stateAgencyRepository:
                            RepositoryProvider.of<StateAgencyRepository>(
                                context)),
                  ),
                  BlocProvider(
                    create: (context) => AttachmentTypeBloc(
                        stateAgencyRepository:
                            RepositoryProvider.of<StateAgencyRepository>(
                                context)),
                  ),
                  BlocProvider(
                    create: (context) => NoteBloc(
                        accordionRepository:
                            RepositoryProvider.of<AccordionRepository>(
                                context)),
                  ),
                  BlocProvider(
                    create: (context) => AttachmentBloc(
                        stateAgencyRepository:
                            RepositoryProvider.of<StateAgencyRepository>(
                                context)),
                  ),
                  BlocProvider(
                    create: (context) => AdditionalAttachmentBloc(
                        stateAgencyRepository:
                            RepositoryProvider.of<StateAgencyRepository>(
                                context)),
                  ),
                  BlocProvider(
                    create: (context) => TraderAdditionalAttachmentBloc(
                        stateAgencyRepository:
                            RepositoryProvider.of<StateAgencyRepository>(
                                context)),
                  ),
                  BlocProvider(
                    create: (context) => AttachmentsListBloc(),
                  ),
                  BlocProvider(
                    create: (context) => CalculateResultBloc(
                        stateAgencyRepository:
                            RepositoryProvider.of<StateAgencyRepository>(
                                context)),
                  ),
                  BlocProvider(
                    create: (context) => FlagsBloc(),
                  ),
                  BlocProvider(
                      create: (context) =>
                          InternetCubit(connectivity: connectivity)),
                  BlocProvider(create: (context) => BottomNavBarCubit()),
                  BlocProvider(create: (context) => CalculatorPanelBloc()),
                  BlocProvider(create: (context) => FeeItemBloc()),
                  BlocProvider(create: (context) => FeeSelectBloc()),
                ],
                child: MaterialApp(
                  title: 'التخليص الجمركي',
                  debugShowCheckedModeBanner: false,
                  localizationsDelegates: const [
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: const [
                    Locale('en', 'US'), //code
                    Locale('ar', 'SY'), // arabic, no country code
                  ],
                  locale: const Locale("ar", "SY"),
                  theme: ThemeData(
                    useMaterial3: true,
                    colorScheme: ColorScheme.fromSwatch().copyWith(
                      primary: AppColor.deepBlue,
                      // secondary: AppColor.lightAppBarBlue,
                      primaryContainer: Colors.white,
                    ),
                    cardTheme: const CardTheme(
                      surfaceTintColor: Colors.white,
                      clipBehavior: Clip.antiAlias,
                    ),
                    inputDecorationTheme: InputDecorationTheme(
                      labelStyle:
                          TextStyle(fontSize: 18, color: Colors.grey[600]!),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 11.0, horizontal: 9.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.black26,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColor.deepBlue,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.red,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.red,
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    textTheme: GoogleFonts.notoNaskhArabicTextTheme(
                      Theme.of(context).textTheme,
                    ),
                  ),
                  home: EasySplashScreen(
                      logoWidth: 120,
                      logo: Image.asset('assets/images/sari_white.png'),
                      backgroundColor: Colors.white,
                      showLoader: false,
                      loaderColor: const Color.fromRGBO(255, 152, 0, 1),
                      durationInSeconds: 5,
                      navigator: showHome
                          ? const ControlView()
                          : const IntroductionView()),
                ),
              ),
            );
          });
    });
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
