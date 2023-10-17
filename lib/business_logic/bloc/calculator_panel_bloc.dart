import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

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
