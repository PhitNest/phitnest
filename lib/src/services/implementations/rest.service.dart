import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../common/logger.dart';
import '../../constants/constants.dart';
import '../../entities/entities.dart';
import '../interfaces/interfaces.dart';
import '../services.dart';

class RestService implements IRestService {
  Uri _getBackendAddress(String route, {Map<String, dynamic>? params}) =>
      environmentService.useHttps
          ? Uri.https(
              '${environmentService.backendHost}:${environmentService.backendPort}',
              route,
              params,
            )
          : Uri.http(
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
      logger.d("Sending a GET request to $route\n\tData: $params");
      return Left(
        await http
            .get(
              _getBackendAddress(route, params: params),
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                ...(headers ?? {}),
                ...(accessToken != null
                    ? {"authorization": "Bearer $accessToken"}
                    : {})
              },
            )
            .timeout(timeout ?? requestTimeout)
            .then(
              (response) {
                logger.d(
                    "Response from $route:\n\tStatus code: ${response.statusCode}\n\tBody: ${response.body}");
                return response;
              },
            ),
      );
    } catch (error) {
      logger.e("Request error: $error");
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
      logger.d("Sending a POST request to $route\n\tData: $body");
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
            .timeout(timeout ?? requestTimeout)
            .then(
          (response) {
            logger.d(
                "Response from $route:\n\tStatus code: ${response.statusCode}\n\tBody: ${response.body}");
            return response;
          },
        ),
      );
    } catch (error) {
      logger.e("Request error: $error");
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
      logger.d("Sending a DELETE request to $route\n\tData: $body");
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
            .timeout(timeout ?? requestTimeout)
            .then(
          (response) {
            logger.d(
                "Response from $route:\n\tStatus code: ${response.statusCode}\n\tBody: ${response.body}");
            return response;
          },
        ),
      );
    } catch (error) {
      logger.e("Request error: $error");
      return Right(
        Failure("Failed to connect to the network."),
      );
    }
  }
}
