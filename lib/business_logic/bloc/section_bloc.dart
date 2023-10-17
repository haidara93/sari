import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:custome_mobile/data/models/accurdion_model.dart';
import 'package:custome_mobile/data/repositories/accurdion_repository.dart';
import 'package:equatable/equatable.dart';

part 'section_event.dart';
part 'section_state.dart';

class SectionBloc extends Bloc<SectionEvent, SectionState> {
  late AccordionRepository accordionRepository;
  SectionBloc({required this.accordionRepository}) : super(SectionInitial()) {
    on<SectionLoadEvent>((event, emit) async {
      emit(SectionLoadingProgress());
      try {
        var sections = await accordionRepository.getSections();
        emit(SectionLoadedSuccess(sections));
      } catch (e) {}
    });

    on<SectionSelectedEvent>(
      (event, emit) async {
        SectionLoadedSuccess currentState = state as SectionLoadedSuccess;

        for (var element in currentState.sections) {
          if (element.id == event.section.id) {
            print(jsonEncode(element));
            // element.chapters = event.chapters;
          }
        }
        emit(SectionLoadedSuccess(currentState.sections));
      },
    );
  }
}
