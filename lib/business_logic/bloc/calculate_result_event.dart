part of 'calculate_result_bloc.dart';

class CalculateResultEvent extends Equatable {
  const CalculateResultEvent();

  @override
  List<Object> get props => [];
}

class CalculateTheResultEvent extends CalculateResultEvent {
  final CalculateObject object;

  CalculateTheResultEvent(this.object);
}
