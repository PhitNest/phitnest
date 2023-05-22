import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension BlocGetter<T extends Bloc<Event, State>, State, Event>
    on BuildContext {
  T get bloc => BlocProvider.of(this);
}
