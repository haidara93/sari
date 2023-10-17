import 'package:bloc/bloc.dart';
import 'package:custome_mobile/data/models/state_custome_agency_model.dart';
import 'package:custome_mobile/data/repositories/state_agency_repository.dart';
import 'package:equatable/equatable.dart';

part 'cost_event.dart';
part 'cost_state.dart';

class CostBloc extends Bloc<CostEvent, CostState> {
  late StateAgencyRepository stateAgencyRepository;

  CostBloc({required this.stateAgencyRepository}) : super(CostInitial()) {
    on<CostSubmitEvent>((event, emit) async {
      emit(CostListLoadingProgress());
      try {
        var data = await stateAgencyRepository.createCosts(event.costs);
        if (data) {
          emit(CostListLoadedSuccess());
        } else {
          emit(CostLoadedFailed("error"));
        }
      } catch (e) {
        emit(CostLoadedFailed(e.toString()));
      }
    });
  }
}
