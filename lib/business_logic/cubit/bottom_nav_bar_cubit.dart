import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'bottom_nav_bar_state.dart';

class BottomNavBarCubit extends Cubit<BottomNavBarState> {
  BottomNavBarCubit() : super(BottomNavBarShown());

  void emitShow() => emit(BottomNavBarShown());
  void emitHide() => emit(BottomNavBarHidden());
}
