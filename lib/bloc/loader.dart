import 'package:async/async.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../errors.dart';

extension GetLoader on BuildContext {
  LoaderBloc<ReqType, ResType> loader<ReqType, ResType>() =>
      BlocProvider.of(this);
}

typedef LoaderConsumer<ReqType, ResType>
    = BlocConsumer<LoaderBloc<ReqType, ResType>, LoaderState<ResType>>;

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

sealed class LoaderEvent<ReqType, ResType> extends Equatable {
  const LoaderEvent();
}

final class LoaderLoadEvent<ReqType, ResType>
    extends LoaderEvent<ReqType, ResType> {
  final ReqType requestData;

  const LoaderLoadEvent(this.requestData) : super();

  @override
  List<Object?> get props => [requestData];
}

final class LoaderLoadedEvent<ReqType, ResType>
    extends LoaderEvent<ReqType, ResType> {
  final ResType data;

  const LoaderLoadedEvent(this.data) : super();

  @override
  List<Object?> get props => [data];
}

final class LoaderBloc<ReqType, ResType>
    extends Bloc<LoaderEvent<ReqType, ResType>, LoaderState<ResType>> {
  LoaderBloc({
    required Future<ResType> Function(ReqType) load,
    ResType? initialData,
    ({ReqType req})? loadOnStart,
  }) : super(initialData != null
            ? loadOnStart != null
                ? LoaderRefreshingState(initialData,
                    CancelableOperation.fromFuture(load(loadOnStart.req)))
                : LoaderLoadedState(initialData)
            : loadOnStart != null
                ? LoaderInitialLoadingState(
                    CancelableOperation.fromFuture(load(loadOnStart.req)))
                : LoaderInitialState()) {
    switch (state) {
      case LoaderLoadingState(operation: final operation) ||
            LoaderRefreshingState(operation: final operation):
        operation.then((response) => add(LoaderLoadedEvent(response)));
      case LoaderLoadedState() || LoaderInitialState():
    }
    on<LoaderLoadEvent<ReqType, ResType>>(
      (event, emit) {
        CancelableOperation<ResType> operation() =>
            CancelableOperation.fromFuture(load(event.requestData))
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

    on<LoaderLoadedEvent<ReqType, ResType>>(
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
