import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/data_sources/s3/s3.dart';
import '../event/registration_event.dart';
import '../state/registration_state.dart';

void onRegisterSuccess(
  RegisterSuccessEvent event,
  Emitter<RegistrationState> emit,
  RegistrationState state,
  ValueChanged<RegistrationEvent> add,
) {
  if (state is RegisterRequestLoadingState) {
    emit(
      UploadingPhotoState(
        photo: state.photo,
        password: state.passwordController.text,
        registration: event.response,
        uploadOp: CancelableOperation.fromFuture(
          uploadPhoto(
            event.response.uploadUrl,
            state.photo,
          ),
        )..then(
            (res) => res != null
                ? add(UploadErrorEvent(res))
                : add(const UploadSuccessEvent()),
          ),
      ),
    );
  } else {
    throw Exception('Invalid state: $state');
  }
}
