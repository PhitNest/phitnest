import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/registration_event.dart';
import '../state/registration_state.dart';

void onUploadSuccess(
  UploadSuccessEvent event,
  Emitter<RegistrationState> emit,
  RegistrationState state,
) {
  if (state is UploadingPhotoState) {
    emit(
      UploadSuccessState(
        registration: state.registration,
      ),
    );
  } else {
    throw Exception("Invalid state: $state");
  }
}
