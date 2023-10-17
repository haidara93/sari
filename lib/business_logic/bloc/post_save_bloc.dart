import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'post_save_event.dart';
part 'post_save_state.dart';

class PostSaveBloc extends Bloc<PostSaveEvent, PostSaveState> {
  PostSaveBloc() : super(PostSaveInitial()) {
    on<PostSaveEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
