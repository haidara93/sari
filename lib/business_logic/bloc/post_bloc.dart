import 'package:bloc/bloc.dart';
import 'package:custome_mobile/data/models/post_model.dart';
import 'package:custome_mobile/data/repositories/post_repository.dart';
import 'package:equatable/equatable.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  late PostRepository postRepository;
  PostBloc({required this.postRepository}) : super(PostInitial()) {
    on<PostLoadEvent>((event, emit) async {
      emit(PostLoadingProgress());
      try {
        print("dfg");
        var posts = await postRepository.getposts();
        emit(PostLoadedSuccess(posts));
      } catch (e) {}
    });
  }
}
