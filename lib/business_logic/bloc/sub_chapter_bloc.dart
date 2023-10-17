import 'package:bloc/bloc.dart';
import 'package:custome_mobile/data/models/accurdion_model.dart';
import 'package:custome_mobile/data/repositories/accurdion_repository.dart';
import 'package:equatable/equatable.dart';

part 'sub_chapter_event.dart';
part 'sub_chapter_state.dart';

class SubChapterBloc extends Bloc<SubChapterEvent, SubChapterState> {
  late AccordionRepository accordionRepository;
  SubChapterBloc({required this.accordionRepository})
      : super(SubChapterInitial()) {
    on<SubChapterLoadEvent>((event, emit) async {
      emit(SubChapterLoadingProgress());
      try {
        var chapters =
            await accordionRepository.getSubChapters(event.chapterId);
        emit(SubChapterLoadedSuccess(chapters));
      } catch (e) {}
    });
  }
}
