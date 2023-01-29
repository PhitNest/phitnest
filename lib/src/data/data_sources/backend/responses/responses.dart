import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

import '../../../../common/utils/utils.dart';
import 'auth/auth.dart';
import 'empty.response.dart';

export 'auth/auth.dart';
export 'empty.response.dart';

abstract class Response<T> extends Equatable with FromJson<T> {
  const Response() : super();

  static T jsonFactory<T extends Response>(Map<String, dynamic> json) =>
      responses.get<T>().fromJson(json);

  static List<T> listFactory<T extends Response>(List<dynamic> jsonList) =>
      jsonList.map((json) => jsonFactory<T>(json)).toList();
}

final responses = GetIt.instance;

void injectResponses() {
  responses.registerSingleton(EmptyResponse());
  responses.registerSingleton(LoginResponse.kEmpty);
  responses.registerSingleton(LoginResponse.kEmpty);
  responses.registerSingleton(RegisterResponse.kEmpty);
}
