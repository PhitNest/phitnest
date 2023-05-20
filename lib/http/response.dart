import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../failure.dart';

sealed class HttpResponse<DataType> extends Equatable {
  final DataType data;
  final Headers headers;

  const HttpResponse(this.data, this.headers) : super();

  @override
  List<Object?> get props => [data, headers];
}

class HttpResponseOk<ResType> extends HttpResponse<ResType> {
  const HttpResponseOk(super.data, super.headers) : super();
}

class HttpResponseFailure extends HttpResponse<Failure> {
  const HttpResponseFailure(super.data, super.headers) : super();
}
