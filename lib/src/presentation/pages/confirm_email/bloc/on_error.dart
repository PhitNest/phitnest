import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/confirm_email_event.dart';
import '../state/confirm_email_state.dart';

void onErrorEvent(ErrorEvent event, Emitter<ConfirmEmailState> emit,
    ConfirmEmailState state) {}
