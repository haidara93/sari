import 'package:bloc/bloc.dart';
import 'package:custome_mobile/data/models/accurdion_model.dart';
import 'package:custome_mobile/data/models/package_model.dart';
import 'package:custome_mobile/data/services/calculator_service.dart';
import 'package:equatable/equatable.dart';

part 'fee_item_event.dart';
part 'fee_item_state.dart';

class FeeItemBloc extends Bloc<FeeItemEvent, FeeItemState> {
  FeeItemBloc() : super(FeeItemInitial()) {
    on<FeeItemLoadEvent>((event, emit) async {
      print("pppp");
      emit(FeeItemLoadingProgress());
      try {
        var fees = await CalculatorService.getpackages(event.feeId);
        print("lllll");
        emit(FeeItemLoadedSuccess(fees[0]));
      } catch (e) {}
    });
  }
}
