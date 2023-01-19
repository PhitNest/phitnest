import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phitnest_mobile/src/presentation/pages/registration/bloc/on_gym_loading_error.dart';

import '../../../../domain/use_cases/use_cases.dart';
import '../event/registration_event.dart';
import '../state/registration_state.dart';
import 'on_edit_first_name.dart';
import 'on_loaded_gyms.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final pageController = PageController();

  RegistrationBloc()
      : super(
          InitialState(
            firstNameConfirmed: false,
            loadGymsOp: CancelableOperation.fromFuture(loadGyms()),
          ),
        ) {
    (state as InitialState).loadGymsOp.then(
          (either) => either.fold(
            (success) => add(LoadedGymsEvent(success.value1, success.value2)),
            (failure) => add(GymsLoadingErrorEvent(failure)),
          ),
        );
    on<EditFirstNameEvent>(
        (event, emit) => onEditFirstName(event, emit, state));
    on<LoadedGymsEvent>((event, emit) => onLoadedGyms(event, emit, state));
    on<GymsLoadingErrorEvent>(
        (event, emit) => onGymsLoadingError(event, emit, state));
  }

  @override
  Future<void> close() async {
    if (state is InitialState) {
      await (state as InitialState).loadGymsOp.cancel();
    }
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    pageController.dispose();
    return super.close();
  }
}
