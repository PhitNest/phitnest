import 'package:equatable/equatable.dart';

abstract class AppState extends Equatable {
  const AppState() : super();

  @override
  List<Object> get props => [];
}

class AppInitial extends AppState {
  const AppInitial() : super();
}
