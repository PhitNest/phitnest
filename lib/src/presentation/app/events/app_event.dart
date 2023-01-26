import 'package:equatable/equatable.dart';

abstract class AppEvent extends Equatable {
  const AppEvent() : super();

  @override
  List<Object> get props => [];
}
