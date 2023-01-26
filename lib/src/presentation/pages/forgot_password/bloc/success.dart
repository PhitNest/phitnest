import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/success.dart';
import '../state/success.dart';
import 'forgot_password_bloc.dart';

void onSuccess(
  ForgotPasswordSuccessEvent event,
  Emitter<ForgotPasswordState> emit,
) =>
    emit(ForgotPasswordSuccessState(
      email: event.email,
      password: event.password,
    ));
