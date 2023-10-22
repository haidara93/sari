import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'calculator_panel_event.dart';
part 'calculator_panel_state.dart';

class CalculatorPanelBloc
    extends Bloc<CalculatorPanelEvent, CalculatorPanelState> {
  CalculatorPanelBloc() : super(CalculatorPanelHidden()) {
    on<CalculatorPanelOpenEvent>((event, emit) {
      emit(CalculatorPanelOpened());
    });

    on<CalculatorPanelHideEvent>((event, emit) {
      emit(CalculatorPanelHidden());
    });
  }
}
