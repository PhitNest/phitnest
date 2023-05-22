import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension BlocGetter on BuildContext {
  T bloc<T extends Bloc<Event, State>, State, Event>() => BlocProvider.of(this);
}
