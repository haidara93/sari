part of 'section_bloc.dart';

abstract class SectionState extends Equatable {
  const SectionState();

  @override
  List<Object> get props => [];
}

class SectionInitial extends SectionState {}

class SectionLoadingProgress extends SectionState {}

class SectionLoadedSuccess extends SectionState {
  final List<Section> sections;

  SectionLoadedSuccess(this.sections);
}

class SectionLoadedFailed extends SectionState {
  final String errortext;

  SectionLoadedFailed(this.errortext);
}
