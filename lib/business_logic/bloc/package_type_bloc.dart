import 'package:bloc/bloc.dart';
import 'package:custome_mobile/data/models/state_custome_agency_model.dart';
import 'package:custome_mobile/data/repositories/state_agency_repository.dart';
import 'package:equatable/equatable.dart';

part 'package_type_event.dart';
part 'package_type_state.dart';

class PackageTypeBloc extends Bloc<PackageTypeEvent, PackageTypeState> {
  late StateAgencyRepository stateAgencyRepository;
  PackageTypeBloc({required this.stateAgencyRepository})
      : super(PackageTypeInitial()) {
    on<PackageTypeLoadEvent>((event, emit) async {
      emit(PackageTypeLoadingProgress());
      try {
        var packageTypes = await stateAgencyRepository.getPackageTypes();
        emit(PackageTypeLoadedSuccess(packageTypes));
      } catch (e) {}
    });
  }
}
