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
  if (state is RegisteringState) {
    emit(
      UploadingPhotoState(
        photo: state.photo,
        password: event.password,
        registration: event.response,
        uploadOp: CancelableOperation.fromFuture(
          photoDatabase.uploadPhoto(
            event.response.uploadUrl,
            state.photo,
          ),
        )..then(
            (res) => res != null
                ? add(UploadErrorEvent(res))
                : add(UploadSuccessEvent()),
          ),
      ),
    );
  } else {
    throw Exception('Invalid state: $state');
  }
}
