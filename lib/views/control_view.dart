import 'package:custome_mobile/business_logic/bloc/attachment/attachment_type_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/auth_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/flags_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/notification_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/section_bloc.dart';
import 'package:custome_mobile/business_logic/bloc/state_custome_bloc.dart';
import 'package:custome_mobile/business_logic/cubit/bottom_nav_bar_cubit.dart';
import 'package:custome_mobile/business_logic/cubit/internet_cubit.dart';
import 'package:custome_mobile/views/screens/broker/broker_home_screen.dart';
import 'package:custome_mobile/views/screens/select_user_type.dart';
import 'package:custome_mobile/views/screens/trader/trader_home_screen.dart';
import 'package:custome_mobile/views/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ControlView extends StatelessWidget {
  const ControlView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<InternetCubit, InternetState>(
        builder: (context, state) {
          if (state is InternetLoading) {
            return const Center(
              child: LoadingIndicator(),
            );
          } else if (state is InternetDisConnected) {
            return const Center(
              child: Text("no internet connection"),
            );
          } else if (state is InternetConnected) {
            return BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthTraderSuccessState) {
                  BlocProvider.of<BottomNavBarCubit>(context).emitShow();
                  BlocProvider.of<NotificationBloc>(context)
                      .add(NotificationLoadEvent());
                  BlocProvider.of<AttachmentTypeBloc>(context)
                      .add(AttachmentTypeLoadEvent());
                  BlocProvider.of<SectionBloc>(context).add(SectionLoadEvent());
                  BlocProvider.of<FlagsBloc>(context).add(FlagsLoadEvent());
                  return const TraderHomeScreen();
                }
                if (state is AuthBrokerSuccessState) {
                  BlocProvider.of<BottomNavBarCubit>(context).emitShow();
                  BlocProvider.of<NotificationBloc>(context)
                      .add(NotificationLoadEvent());
                  BlocProvider.of<AttachmentTypeBloc>(context)
                      .add(AttachmentTypeLoadEvent());
                  BlocProvider.of<SectionBloc>(context).add(SectionLoadEvent());
                  BlocProvider.of<FlagsBloc>(context).add(FlagsLoadEvent());

                  return const BrokerHomeScreen();
                } else if (state is AuthInitial) {
                  BlocProvider.of<AuthBloc>(context).add(AuthCheckRequested());
                  return const Center(
                    child: LoadingIndicator(),
                  );
                } else {
                  return SelectUserType();
                }
              },
            );
          } else {
            return const Center();
          }
        },
      ),
    );
  }
}
