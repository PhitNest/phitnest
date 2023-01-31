import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/registration_event.dart';
import '../state/registration_state.dart';

void onUploadError(
  UploadErrorEvent event,
  Emitter<RegistrationState> emit,
  RegistrationState state,
) {
  if (state is UploadingState) {
    emit(
      UploadErrorState(
        failure: event.failure,
        file: state.file,
        password: state.password,
        response: state.response,
      ),
    );
  } else {
    throw Exception('Invalid state: $state');
  }
}
