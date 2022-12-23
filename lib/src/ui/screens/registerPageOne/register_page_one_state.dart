import 'package:flutter/material.dart';

import '../screen_state.dart';

class RegisterPageOneState extends ScreenState {
  final AutovalidateMode autovalidateMode;

  const RegisterPageOneState({required this.autovalidateMode}) : super();

  @override
  List<Object> get props => [autovalidateMode];
}

class RegisterPageOneCubit extends ScreenCubit<RegisterPageOneState> {
  RegisterPageOneCubit()
      : super(const RegisterPageOneState(
            autovalidateMode: AutovalidateMode.disabled));

  void enableAutovalidateMode() =>
      setState(RegisterPageOneState(autovalidateMode: AutovalidateMode.always));
}
