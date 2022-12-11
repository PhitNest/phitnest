import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';
import 'package:http/http.dart' as http;

abstract class IRestService {
  Future<Either<http.Response, Failure>> get(
    String route, {
    Duration? timeout,
    Map<String, dynamic>? params,
    Map<String, String>? headers,
    String? accessToken,
  });

  Future<Either<http.Response, Failure>> post(
    String route, {
    Duration? timeout,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    String? accessToken,
  });

  Future<Either<http.Response, Failure>> delete(
    String route, {
    Duration? timeout,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    String? accessToken,
  });
}
