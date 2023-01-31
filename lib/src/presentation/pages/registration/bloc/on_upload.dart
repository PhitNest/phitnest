import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/data_sources/s3/s3.dart';
import '../../../../domain/use_cases/use_cases.dart';
import '../event/registration_event.dart';
import '../state/registration_state.dart';

void onUpload(
  UploadEvent event,
  Emitter<RegistrationState> emit,
  RegistrationState state,
  ValueChanged<RegistrationEvent> add,
) {
  if (state is RegisterSuccessState) {
    emit(
      UploadingState(
        password: state.password,
        file: event.file,
        response: state.response,
        uploadImage: CancelableOperation.fromFuture(
          () async {
            return await uploadPhoto(state.response.uploadUrl, event.file) ??
                await uploadPhotoUnauthorized(
                    state.response.user.email, state.password, event.file);
          }(),
        )..then(
            (failure) => failure != null
                ? add(UploadErrorEvent(failure))
                : add(const UploadSuccessEvent()),
          ),
      ),
    );
  } else {
    throw Exception('Invalid state: $state');
  }
}
