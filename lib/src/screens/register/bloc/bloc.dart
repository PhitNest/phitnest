import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'event.dart';
part 'state.dart';

extension GetRegisterBloc on BuildContext {
  RegisterBloc get registerBloc => BlocProvider.of(this);
}

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final inviterEmailController = TextEditingController();
  final pageController = PageController();
  final formKey = GlobalKey<FormState>();

  RegisterBloc()
      : super(
          const RegisterState(
            autovalidateMode: AutovalidateMode.disabled,
          ),
        ) {
    on<RegisterFormRejectedEvent>(
      (event, emit) => emit(
        const RegisterState(
          autovalidateMode: AutovalidateMode.always,
        ),
      ),
    );
  }

  @override
  Future<void> close() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    inviterEmailController.dispose();
    pageController.dispose();
    return super.close();
  }
}
