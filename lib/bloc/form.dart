import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class FormBlocState extends Equatable {
  final AutovalidateMode autovalidateMode;

  const FormBlocState({
    required this.autovalidateMode,
  }) : super();

  @override
  List<Object?> get props => [autovalidateMode];
}

final class FormSetValidationEvent extends Equatable {
  final AutovalidateMode autovalidateMode;

  const FormSetValidationEvent(this.autovalidateMode) : super();

  @override
  List<Object?> get props => [autovalidateMode];
}

abstract class FormControllers {
  void dispose();
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
      add(FormSetValidationEvent(AutovalidateMode.always));
    }
  }

  FormBloc(this.controllers)
      : super(FormBlocState(autovalidateMode: AutovalidateMode.disabled)) {
    on<FormSetValidationEvent>(
      (event, emit) {
        emit(FormBlocState(autovalidateMode: event.autovalidateMode));
      },
    );
  }

  @override
  Future<void> close() {
    controllers.dispose();
    return super.close();
  }
}
