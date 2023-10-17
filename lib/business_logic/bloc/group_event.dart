part of 'group_bloc.dart';

class GroupEvent extends Equatable {
  const GroupEvent();

  @override
  List<Object> get props => [];
}

class GroupLoadEvent extends GroupEvent {}

class GroupAddEvent extends GroupEvent {
  final String name;

  GroupAddEvent(this.name);
}

class SavePostEvent extends GroupEvent {
  final int postId;
  final int groupId;

  SavePostEvent(this.postId, this.groupId);
}

class UnSavePostEvent extends GroupEvent {
  final int postId;

  UnSavePostEvent(this.postId);
}
