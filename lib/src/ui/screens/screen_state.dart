import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

abstract class ScreenCubit<S extends ScreenState> extends Cubit<S> {
  bool _disposed = false;

  @nonVirtual
  bool get disposed => _disposed;

  ScreenCubit(S state) : super(state);

  @nonVirtual
  void setState(S newState) {
    if (!_disposed) {
      emit(newState);
    }
  }

  @mustCallSuper
  @override
  Future<void> close() async {
    _disposed = true;
    await state.dispose();
    return super.close();
  }
}

abstract class ScreenState extends Equatable {
  const ScreenState();

  @override
  List<Object> get props => [];

  @mustCallSuper
  Future<void> dispose() async {}
}
