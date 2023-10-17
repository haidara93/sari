import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:custome_mobile/constants/enums.dart';
import 'package:equatable/equatable.dart';

part 'internet_state.dart';

class InternetCubit extends Cubit<InternetState> {
  final Connectivity connectivity;
  late StreamSubscription connectivityStreamSubscription;

  InternetCubit({required this.connectivity}) : super(InternetLoading()) {
    connectivityStreamSubscription =
        connectivity.onConnectivityChanged.listen((connectionResult) {
      if (connectionResult == ConnectivityResult.wifi) {
        emitInternetConnected(ConnectionType.Wifi);
      } else if (connectionResult == ConnectivityResult.mobile) {
        emit(InternetConnected(connectionType: ConnectionType.Mobile));
      } else if (connectionResult == ConnectivityResult.none) {
        emit(InternetDisConnected());
      }
    });
  }

  void emitInternetConnected(ConnectionType connectionType) =>
      emit(InternetConnected(connectionType: connectionType));

  void emitInternetDisConnected() => emit(InternetDisConnected());

  @override
  Future<void> close() {
    connectivityStreamSubscription.cancel();
    return super.close();
  }
}
