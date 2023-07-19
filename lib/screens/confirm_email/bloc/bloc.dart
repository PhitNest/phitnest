import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'event.dart';
part 'state.dart';

extension GetConfirmEmailBloc on BuildContext {
  ConfirmEmailBloc get confirmEmailBloc => BlocProvider.of(this);
}

class ConfirmEmailBloc extends Bloc<ConfirmEmailEvent, ConfirmEmailState> {
  final focusNode = FocusNode();
  final codeController = TextEditingController();

  ConfirmEmailBloc() : super(const ConfirmEmailState());

  @override
  Future<void> close() {
    codeController.dispose();
    focusNode.dispose();
    return super.close();
  }
}
