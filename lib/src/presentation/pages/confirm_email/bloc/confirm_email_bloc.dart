import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/confirm_email_event.dart';
import '../state/confirm_email_state.dart';

class ConfirmEmailBloc extends Bloc<ConfirmEmailEvent, ConfirmEmailState> {
  ConfirmEmailBloc()
      : super(
          InitialState(
            codeController: TextEditingController(),
            codeFocusNode: FocusNode(),
          ),
        );
}
