import 'package:async/async.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../errors.dart';

sealed class LoaderState<ResType> extends Equatable {
  const LoaderState();
}

final class LoaderInitialState<ResType> extends LoaderState<ResType> {
  const LoaderInitialState() : super();

  @override
  List<Object?> get props => [];
}

sealed class LoaderLoadingState<ResType> extends LoaderState<ResType> {
  final CancelableOperation<ResType> operation;

  const LoaderLoadingState(this.operation) : super();

  @override
  List<Object?> get props => [operation];
}

final class LoaderInitialLoadingState<ResType>
    extends LoaderLoadingState<ResType> {
  const LoaderInitialLoadingState(super.operation) : super();
}

final class LoaderRefreshingState<ResType> extends LoaderLoadingState<ResType> {
  final ResType data;

  const LoaderRefreshingState(this.data, super.operation) : super();

  @override
  List<Object?> get props => [super.props, data];
}

final class LoaderLoadedState<ResType> extends LoaderState<ResType> {
  final ResType data;

  const LoaderLoadedState(this.data) : super();

  @override
  List<Object?> get props => [data];
}

sealed class LoaderEvent<ResType> extends Equatable {
  const LoaderEvent();
}

final class LoaderLoadEvent<ResType> extends LoaderEvent<ResType> {
  const LoaderLoadEvent() : super();

  @override
  List<Object?> get props => [];
}

final class LoaderLoadedEvent<ResType> extends LoaderEvent<ResType> {
  final ResType data;

  const LoaderLoadedEvent(this.data) : super();

  @override
  List<Object?> get props => [data];
}

final class LoaderBloc<ResType>
    extends Bloc<LoaderEvent<ResType>, LoaderState<ResType>> {
  LoaderBloc({
    required Future<ResType> Function() load,
    ResType? initialData,
    bool loadOnStart = false,
  }) : super(initialData != null
            ? loadOnStart
                ? LoaderRefreshingState(
                    initialData, CancelableOperation.fromFuture(load()))
                : LoaderLoadedState(initialData)
            : loadOnStart
                ? LoaderInitialLoadingState(
                    CancelableOperation.fromFuture(load()))
                : LoaderInitialState()) {
    switch (state) {
      case LoaderLoadingState(operation: final operation) ||
            LoaderRefreshingState(operation: final operation):
        operation.then((response) => add(LoaderLoadedEvent(response)));
      case LoaderLoadedState() || LoaderInitialState():
    }
    on<LoaderLoadEvent<ResType>>(
      (event, emit) {
        CancelableOperation<ResType> operation() =>
            CancelableOperation.fromFuture(load())
              ..then((response) => add(LoaderLoadedEvent(response)));
        switch (state) {
          case LoaderLoadingState():
            badState(state, event);
          case LoaderInitialState():
            emit(LoaderInitialLoadingState(operation()));
          case LoaderLoadedState(data: final data):
            emit(LoaderRefreshingState(data, operation()));
        }
      },
    );

    on<LoaderLoadedEvent<ResType>>(
      (event, emit) async {
        switch (state) {
          case LoaderLoadingState():
            emit(LoaderLoadedState(event.data));
          case LoaderLoadedState() || LoaderInitialState():
            badState(state, event);
        }
      },
    );
  }

  @override
  Future<void> close() async {
    switch (state) {
      case LoaderLoadingState(operation: final operation):
        await operation.cancel();
      case LoaderLoadedState() || LoaderInitialState():
    }
    return super.close();
  }
}
