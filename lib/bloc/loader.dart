import 'package:async/async.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class LoaderState<ResType> extends Equatable {
  const LoaderState();
}

final class LoaderInitialState<ResType> extends LoaderState<ResType> {
  const LoaderInitialState() : super();

  @override
  List<Object?> get props => [];
}

final class LoaderLoadingState<ResType> extends LoaderState<ResType> {
  final CancelableOperation<ResType> operation;

  const LoaderLoadingState(this.operation) : super();

  @override
  List<Object?> get props => [operation];
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
  final Future<ResType> Function() load;
  final Future<void> Function(ResType) onLoaded;

  LoaderBloc({
    required this.load,
    required this.onLoaded,
  }) : super(LoaderInitialState()) {
    on<LoaderLoadEvent<ResType>>(
      (event, emit) {
        final operation = CancelableOperation.fromFuture(load())
          ..then((response) => add(LoaderLoadedEvent(response)));
        emit(LoaderLoadingState(operation));
      },
    );

    on<LoaderLoadedEvent<ResType>>(
      (event, emit) async {
        await onLoaded(event.data);
        emit(LoaderLoadedState(event.data));
      },
    );
  }

  @override
  Future<void> close() async {
    final state = this.state;
    if (state is LoaderLoadingState<ResType>) {
      await state.operation.cancel();
    }
    return super.close();
  }
}
