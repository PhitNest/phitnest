part of 'http.dart';

sealed class HttpResponse<DataType> extends Equatable {
  final Headers? headers;

  const HttpResponse(this.headers) : super();

  @override
  List<Object?> get props => [headers];
}

final class HttpResponseOk<ResType> extends HttpResponse<ResType> {
  final ResType data;
  final bool usedCache;

  const HttpResponseOk(this.data, super.headers, this.usedCache) : super();

  @override
  List<Object?> get props => [data, headers, usedCache];
}

final class HttpResponseFailure<ResType> extends HttpResponse<ResType> {
  final Failure failure;

  const HttpResponseFailure(this.failure, super.headers) : super();

  @override
  List<Object?> get props => [failure, headers];
}
