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

    on<PostSaveEvent>(
      (event, emit) {
        PostLoadedSuccess currentstate = state as PostLoadedSuccess;
        emit(PostLoadingProgress());
        for (var i = 0; i < currentstate.posts.length; i++) {
          if (currentstate.posts[i].id! == event.postId) {
            currentstate.posts[i].is_saved = event.save;
            break;
          }
        }
        emit(PostLoadedSuccess(currentstate.posts));
      },
    );
  }
}
