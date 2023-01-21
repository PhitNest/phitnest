import 'package:equatable/equatable.dart';

import 'domain/entities/entities.dart';

abstract class AppEvent extends Equatable {
  const AppEvent() : super();

  @override
  List<Object> get props => [];
}
