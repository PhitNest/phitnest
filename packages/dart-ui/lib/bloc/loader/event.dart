part of 'loader.dart';

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

final class LoaderSetEvent<ReqType, ResType>
    extends LoaderEvent<ReqType, ResType> {
  final ResType data;

  const LoaderSetEvent(this.data) : super();

  @override
  List<Object?> get props => [data];
}

final class LoaderCancelEvent<ReqType, ResType>
    extends LoaderEvent<ReqType, ResType> {
  const LoaderCancelEvent() : super();

  @override
  List<Object?> get props => [];
}
