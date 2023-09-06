part of 'parallel_loader.dart';

sealed class ParallelLoaderEvent<ReqType, ResType> extends Equatable {
  const ParallelLoaderEvent() : super();
}

final class ParallelPushEvent<ReqType, ResType>
    extends ParallelLoaderEvent<ReqType, ResType> {
  final ReqType requestData;

  const ParallelPushEvent(this.requestData) : super();

  @override
  List<Object?> get props => [requestData];
}

final class ParallelPopEvent<ReqType, ResType>
    extends ParallelLoaderEvent<ReqType, ResType> {
  final ParallelOperation<ReqType, ResType> operation;
  final ResType res;

  const ParallelPopEvent(this.operation, this.res) : super();

  @override
  List<Object?> get props => [operation, res];
}

final class ParallelClearEvent<ReqType, ResType>
    extends ParallelLoaderEvent<ReqType, ResType> {
  const ParallelClearEvent() : super();

  @override
  List<Object?> get props => [];
}
