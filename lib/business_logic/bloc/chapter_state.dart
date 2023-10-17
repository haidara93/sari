part of 'chapter_bloc.dart';

abstract class ChapterState extends Equatable {
  const ChapterState();

  @override
  List<Object> get props => [];
}

class ChapterInitial extends ChapterState {}

class ChapterLoadingProgress extends ChapterState {}

class ChapterLoadedSuccess extends ChapterState {
  final List<Chapter> chapters;

  ChapterLoadedSuccess(this.chapters);
}

class ChapterLoadedFailed extends ChapterState {
  final String errortext;

  ChapterLoadedFailed(this.errortext);
}
