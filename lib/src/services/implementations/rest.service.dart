import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../constants/constants.dart';
import '../../entities/entities.dart';
import '../interfaces/interfaces.dart';
import '../services.dart';

class RestService implements IRestService {
  Uri _getBackendAddress(String route, {Map<String, dynamic>? params}) =>
      Uri.http(
        '${environmentService.backendHost}:${environmentService.backendPort}',
        route,
        params,
      );

  Future<Either<http.Response, Failure>> get(
    String route, {
    Duration? timeout,
    Map<String, dynamic>? params,
    Map<String, String>? headers,
    String? accessToken,
  }) async {
    try {
      return Left(
        await http.get(
          _getBackendAddress(route, params: params),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            ...(headers ?? {}),
            ...(accessToken != null
                ? {"authorization": "Bearer $accessToken"}
                : {})
          },
        ).timeout(timeout ?? requestTimeout),
      );
    } catch (error) {
      return Right(
        Failure("Failed to connect to the network."),
      );
    }
  }

  Future<Either<http.Response, Failure>> post(
    String route, {
    Duration? timeout,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    String? accessToken,
  }) async {
    try {
      return Left(
        await http
            .post(
              _getBackendAddress(route),
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                ...(headers ?? {}),
                ...(accessToken != null
                    ? {"authorization": "Bearer $accessToken"}
                    : {})
              },
              body: jsonEncode(body),
            )
            .timeout(timeout ?? requestTimeout),
      );
    } catch (error) {
      return Right(
        Failure("Failed to connect to the network."),
      );
    }
  }

  Future<Either<http.Response, Failure>> delete(
    String route, {
    Duration? timeout,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    String? accessToken,
  }) async {
    try {
      return Left(
        await http
            .delete(
              _getBackendAddress(route),
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                ...(headers ?? {}),
                ...(accessToken != null
                    ? {"authorization": "Bearer $accessToken"}
                    : {})
              },
              body: jsonEncode(body),
            )
            .timeout(timeout ?? requestTimeout),
      );
    } catch (error) {
      return Right(
        Failure("Failed to connect to the network."),
      );
    }
  }
}
