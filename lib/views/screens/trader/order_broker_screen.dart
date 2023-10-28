import 'package:custome_mobile/business_logic/bloc/additional_attachment_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/agency_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/attachment_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/attachment_type_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/step_order_bloc.dart';
import 'package:custome_mobile/business_logic/cubit/bottom_nav_bar_cubit.dart';
import 'package:custome_mobile/business_logic/cubit/current_step_cubit.dart';
import 'package:custome_mobile/data/repositories/state_agency_repository.dart';
import 'package:custome_mobile/views/screens/trader/stepper_order_broker_screen.dart';
import 'package:custome_mobile/views/screens/trader/trader_attachement_screen.dart';
import 'package:custome_mobile/views/screens/trader/trader_bill_review.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderBrokerScreen extends StatefulWidget {
  const OrderBrokerScreen({Key? key}) : super(key: key);

  @override
  State<OrderBrokerScreen> createState() => _OrderBrokerScreenState();
}

class _OrderBrokerScreenState extends State<OrderBrokerScreen> {
  final FocusNode _statenode = FocusNode();
  // final FocusNode _agencynode = FocusNode();
  @override
  void initState() {
    super.initState();
    // FocusScope.of(context).unfocus();
  }

  int currentStep = 0;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AgencyBloc(
              stateAgencyRepository:
                  RepositoryProvider.of<StateAgencyRepository>(context)),
        ),
        BlocProvider(
          create: (context) => AttachmentTypeBloc(
              stateAgencyRepository:
                  RepositoryProvider.of<StateAgencyRepository>(context)),
        ),
        BlocProvider(
          create: (context) => AttachmentBloc(
              stateAgencyRepository:
                  RepositoryProvider.of<StateAgencyRepository>(context)),
        ),
        BlocProvider(
          create: (context) => AdditionalAttachmentBloc(
              stateAgencyRepository:
                  RepositoryProvider.of<StateAgencyRepository>(context)),
        ),
        BlocProvider(
          create: (context) => CurrentStepCubit(),
        ),
        BlocProvider(
          create: (context) => StepOrderBloc(),
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
            BlocProvider.of<BottomNavBarCubit>(context).emitShow();
          },
          child: BlocBuilder<CurrentStepCubit, CurrentStepInitial>(
            builder: (context, stepstate) {
              return Stepper(
                type: StepperType.horizontal,
                steps: [
                  Step(
                      isActive: stepstate.value >= 0,
                      title: Text(
                        "معلومات الشحنة",
                        style: TextStyle(fontSize: 12.sp),
                      ),
                      content: const StepperOrderBrokerScreen()),
                  Step(
                      isActive: stepstate.value >= 1,
                      title: Text(
                        "حساب الرسوم",
                        style: TextStyle(fontSize: 12.sp),
                      ),
                      content: const TraderBillReview()),
                  Step(
                      isActive: stepstate.value >= 2,
                      title: Text(
                        "المرفقات",
                        style: TextStyle(fontSize: 12.sp),
                      ),
                      content: TraderAttachementScreen()),
                ],
                currentStep: stepstate.value,
                controlsBuilder: (context, details) {
                  return const SizedBox.shrink();
                },
                onStepContinue: () => setState(() {
                  if (stepstate.value < 2) {
                    print(stepstate.value);
                    BlocProvider.of<CurrentStepCubit>(context).increament();
                  }
                }),
                onStepCancel: () => setState(() {
                  if (stepstate.value > 0) {
                    print(stepstate.value);
                    BlocProvider.of<CurrentStepCubit>(context).decreament();
                  }
                }),
              );
            },
          ),
        ),
      ),
    );
  }

  List<Step> getSteps() => [
        Step(
            isActive: currentStep >= 0,
            title: Text(
              "معلومات الشحنة",
              style: TextStyle(fontSize: 12.sp),
            ),
            content: const StepperOrderBrokerScreen()),
        Step(
            isActive: currentStep >= 1,
            title: Text(
              "حساب الرسوم",
              style: TextStyle(fontSize: 12.sp),
            ),
            content: const TraderBillReview()),
        Step(
            isActive: currentStep >= 2,
            title: Text(
              "المرفقات",
              style: TextStyle(fontSize: 12.sp),
            ),
            content: TraderAttachementScreen()),
      ];
}
