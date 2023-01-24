import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/confirm_email_event.dart';
import '../state/confirm_email_state.dart';

void onSuccess(SuccessEvent event, Emitter<ConfirmEmailState> emit,
    ConfirmEmailState state) {}
