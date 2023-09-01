import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'event.dart';
part 'state.dart';

abstract class FormControllers {
  void dispose();
}

extension FormBlocGetter on BuildContext {
  FormBloc<T> formBloc<T extends FormControllers>() => BlocProvider.of(this);
}

typedef FormConsumer<Controllers extends FormControllers>
    = BlocConsumer<FormBloc<Controllers>, FormBlocState>;

final class FormBloc<Controllers extends FormControllers>
    extends Bloc<FormSetValidationEvent, FormBlocState> {
  final Controllers controllers;
  final formKey = GlobalKey<FormState>();

  void submit({
    required void Function() onAccept,
    void Function()? onReject,
  }) {
    if (formKey.currentState!.validate()) {
      onAccept();
    } else {
      onReject?.call();
      add(const FormSetValidationEvent(AutovalidateMode.always));
    }
  }

  FormBloc(this.controllers)
      : super(
            const FormBlocState(autovalidateMode: AutovalidateMode.disabled)) {
    on<FormSetValidationEvent>((event, emit) =>
        emit(FormBlocState(autovalidateMode: event.autovalidateMode)));
  }

  @override
  Future<void> close() {
    controllers.dispose();
    return super.close();
  }
}
