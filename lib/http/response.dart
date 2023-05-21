part of 'http.dart';

sealed class HttpResponse<DataType> extends Equatable {
  final Headers headers;

  const HttpResponse(this.headers) : super();

  @override
  List<Object?> get props => [headers];
}

class HttpResponseOk<ResType> extends HttpResponse<ResType> {
  final ResType data;

  const HttpResponseOk(this.data, super.headers) : super();
}

class HttpResponseFailure<ResType> extends HttpResponse<ResType> {
  final Failure failure;

  const HttpResponseFailure(this.failure, super.headers) : super();
}
