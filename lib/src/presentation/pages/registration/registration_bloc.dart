import 'package:flutter/material.dart';

import '../bloc.dart';
import 'registration_event.dart';
import 'registration_state.dart';

class RegistrationBloc extends PageBloc<RegistrationEvent, RegistrationState> {
  RegistrationBloc()
      : super(
          RegistrationInitial(
            firstNameController: TextEditingController(),
            lastNameController: TextEditingController(),
            emailController: TextEditingController(),
            passwordController: TextEditingController(),
            confirmPasswordController: TextEditingController(),
            autovalidateMode: AutovalidateMode.disabled,
            firstNameFocusNode: FocusNode(),
            lastNameFocusNode: FocusNode(),
            emailFocusNode: FocusNode(),
            passwordFocusNode: FocusNode(),
            confirmPasswordFocusNode: FocusNode(),
            pageOneFormKey: GlobalKey(),
            pageTwoFormKey: GlobalKey(),
            pageController: PageController(),
            scrollEnabled: false,
            pageIndex: 0,
          ),
        ) {
    on<SwipeEvent>(
      (event, emit) {
        state.firstNameFocusNode.unfocus();
        state.lastNameFocusNode.unfocus();
        state.emailFocusNode.unfocus();
        state.passwordFocusNode.unfocus();
        state.confirmPasswordFocusNode.unfocus();
        emit(
          (state as RegistrationInitial).copyWith(
            pageIndex: event.pageIndex,
          ),
        );
      },
    );
    on<SubmitPageOne>(
      (event, emit) {
        final initialState = state as RegistrationInitial;
        if (state.pageOneFormKey.currentState!.validate()) {
          state.pageController.nextPage(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
          emit(
            initialState.copyWith(
              pageIndex: 1,
              autovalidateMode: AutovalidateMode.disabled,
              scrollEnabled: true,
            ),
          );
        } else {
          emit(
            initialState.copyWith(
              autovalidateMode: AutovalidateMode.always,
              scrollEnabled: false,
            ),
          );
        }
      },
    );
    on<PageOneTextEdited>(
      (event, emit) {
        emit(
          (state as RegistrationInitial).copyWith(
            scrollEnabled: false,
          ),
        );
      },
    );
  }

  void editedPageOne() => add(const PageOneTextEdited());

  void submitPageOne() => add(const SubmitPageOne());

  void submitPageTwo() => add(const SubmitPageTwo());

  void swipe(int pageIndex) => add(SwipeEvent(pageIndex: pageIndex));
}
