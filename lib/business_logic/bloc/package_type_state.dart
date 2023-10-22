part of 'package_type_bloc.dart';

class PackageTypeState extends Equatable {
  const PackageTypeState();

  @override
  List<Object> get props => [];
}

class PackageTypeInitial extends PackageTypeState {}

class PackageTypeLoadingProgress extends PackageTypeState {}

class PackageTypeLoadedSuccess extends PackageTypeState {
  final List<PackageType> packageTypes;

  const PackageTypeLoadedSuccess(this.packageTypes);
}

class PackageTypeLoadedFailed extends PackageTypeState {
  final String errortext;

  const PackageTypeLoadedFailed(this.errortext);
}
