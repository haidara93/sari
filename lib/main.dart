import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:custome_mobile/business_logic/bloc/attachment_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/attachment_type_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/auth_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/calculate_result_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/calculator_panel_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/chapter_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/cost_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/fee_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/fee_item_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/fee_trade_description_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/group_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/offer_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/package_type_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/post_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/saved_post_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/section_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/state_custome_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/sub_chapter_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/trader_log_bloc.dart';
import 'package:custome_mobile/business_logic/cubit/internet_cubit.dart';
import 'package:custome_mobile/data/repositories/accurdion_repository.dart';
import 'package:custome_mobile/data/repositories/auth_repository.dart';
import 'package:custome_mobile/data/repositories/post_repository.dart';
import 'package:custome_mobile/data/repositories/state_agency_repository.dart';
import 'package:custome_mobile/firebase_options.dart';
import 'package:custome_mobile/views/control_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'views/screens/introduction_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  messaging.getToken().then((value) {
    print(value);
    // firebase_token = value;
  });

  final prefs = await SharedPreferences.getInstance();
  final showHome = prefs.getBool("showHome") ?? false;

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
                    create: (context) => CalculateResultBloc(
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
                    create: (context) => AttachmentBloc(
                        stateAgencyRepository:
                            RepositoryProvider.of<StateAgencyRepository>(
                                context)),
                  ),
                  // BlocProvider(
                  //   create: (context) => AgencyBloc(
                  //       stateAgencyRepository:
                  //           RepositoryProvider.of<StateAgencyRepository>(
                  //               context)),
                  // ),
                  // BlocProvider(
                  //   create: (context) => NoteBloc(
                  //       accordionRepository:
                  //           RepositoryProvider.of<AccordionRepository>(
                  //               context)),
                  // ),
                  BlocProvider(
                      create: (context) =>
                          InternetCubit(connectivity: connectivity)),
                  BlocProvider(create: (context) => CalculatorPanelBloc()),
                  BlocProvider(create: (context) => FeeItemBloc()),
                ],
                child: MaterialApp(
                  title: 'التخليص الجمركي',
                  theme: ThemeData(
                    primarySwatch: Colors.blue,
                    textTheme: GoogleFonts.changaTextTheme(
                      Theme.of(context).textTheme,
                    ),
                  ),
                  home: showHome ? ControlView() : IntroductionView(),
                ),
              ),
            );
          });
    });
  }
}
