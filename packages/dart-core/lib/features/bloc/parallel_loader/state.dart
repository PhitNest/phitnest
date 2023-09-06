part of 'parallel_loader.dart';

final class ParallelOperation<ReqType, ResType>
    with LinkedListEntry<ParallelOperation<ReqType, ResType>>, EquatableMixin {
  final CancelableOperation<ResType> operation;
  final ReqType req;

  ParallelOperation(this.operation, this.req) : super();

  @override
  List<Object?> get props => [operation, req];
}

sealed class ParallelLoaderBaseState<ReqType, ResType> extends Equatable {
  final LinkedList<ParallelOperation<ReqType, ResType>> operations;

  const ParallelLoaderBaseState(this.operations) : super();

  @override
  List<Object?> get props => [operations];
}

final class ParallelLoaderState<ReqType, ResType>
    extends ParallelLoaderBaseState<ReqType, ResType> {
  const ParallelLoaderState(super.operations) : super();
}

final class ParallelLoadedState<ReqType, ResType>
    extends ParallelLoaderState<ReqType, ResType> {
  final ResType data;
  final ReqType req;

  const ParallelLoadedState(super.operations, this.data, this.req) : super();

  @override
  List<Object?> get props => [...super.props, data, req];
}
