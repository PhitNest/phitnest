import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

import '../../../../common/utils/utils.dart';
import 'auth/auth.dart';
import 'empty.request.dart';

export 'auth/auth.dart';
export 'empty.request.dart';

final request = GetIt.instance;

abstract class Request extends Equatable with ToJson {
  const Request() : super();

  @override
  Map<String, dynamic> toJson();
}

void injectRequests() {
  request.registerSingleton(EmptyRequest());
  request.registerSingleton(ConfirmRegisterRequest.kEmpty);
  request.registerSingleton(ForgotPasswordSubmitRequest.kEmpty);
  request.registerSingleton(ForgotPasswordRequest.kEmpty);
  request.registerSingleton(LoginRequest.kEmpty);
  request.registerSingleton(RefreshSessionRequest.kEmpty);
  request.registerSingleton(RegisterRequest.kEmpty);
  request.registerSingleton(ResendConfirmationRequest.kEmpty);
  request.registerSingleton(SignOutRequest.kEmpty);
}
