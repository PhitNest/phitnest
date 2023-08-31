part of 'http.dart';

sealed class HttpResponse<DataType> extends Equatable {
  final Headers? headers;

  const HttpResponse(this.headers) : super();

  @override
  List<Object?> get props => [headers];
}

sealed class HttpResponseSuccess<ResType> extends HttpResponse<ResType> {
  final ResType data;

  const HttpResponseSuccess(this.data, super.headers) : super();

  @override
  List<Object?> get props => [data, headers];
}

final class HttpResponseOk<ResType> extends HttpResponseSuccess<ResType> {
  const HttpResponseOk(super.data, super.headers) : super();
}

final class HttpResponseCache<ResType> extends HttpResponseSuccess<ResType> {
  const HttpResponseCache(ResType data) : super(data, null);
}

final class HttpResponseFailure<ResType> extends HttpResponse<ResType> {
  final Failure failure;

  const HttpResponseFailure(this.failure, super.headers) : super();

  @override
  List<Object?> get props => [failure, headers];
}
