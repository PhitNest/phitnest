import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/registration_event.dart';
import '../state/registration_state.dart';

void onUploadError(
  UploadErrorEvent event,
  Emitter<RegistrationState> emit,
  RegistrationState state,
) {
  if (state is UploadingPhotoState) {
    emit(
      UploadErrorState(
        photo: state.photo,
        failure: event.failure,
        registration: state.registration,
        password: state.password,
      ),
    );
  } else {
    throw Exception("Invalid state: $state");
  }
}