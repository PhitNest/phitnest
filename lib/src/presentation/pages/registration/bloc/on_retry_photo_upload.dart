import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/use_cases/use_cases.dart';
import '../event/registration_event.dart';
import '../state/registration_state.dart';

void onRetryPhotoUpload(
  RetryPhotoUploadEvent event,
  Emitter<RegistrationState> emit,
  RegistrationState state,
  ValueChanged<RegistrationEvent> add,
) {
  if (state is UploadErrorState) {
    emit(
      UploadingPhotoState(
        uploadOp: CancelableOperation.fromFuture(
          uploadPhotoUnauthorized(
            state.registration.email,
            state.registration.cognitoId,
            state.photo,
          ),
        )..then(
            (res) => res != null
                ? add(UploadErrorEvent(res))
                : add(UploadSuccessEvent()),
          ),
        photo: state.photo,
        registration: state.registration,
      ),
    );
  } else {
    throw Exception("Invalid state: $state");
  }
}
