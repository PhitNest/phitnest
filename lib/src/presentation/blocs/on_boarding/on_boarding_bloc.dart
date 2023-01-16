import 'package:flutter/material.dart';

import '../bloc.dart';
import 'on_boarding_event.dart';
import 'on_boarding_state.dart';

export 'on_boarding_event.dart';
export 'on_boarding_state.dart';

class OnBoardingBloc extends Bloc<OnBoardingEvent, OnBoardingState> {
  OnBoardingBloc() : super(const OnBoardingIntroState()) {
    on<OnBoardingCompleteIntro>(
      (event, emit) {
        emit(
          OnBoardingRegistrationState(
            pageController: PageController(),
            pageIndex: 0,
            scrollEnabled: false,
            pageOneFormKey: GlobalKey(),
            pageTwoFormKey: GlobalKey(),
            firstNameController: TextEditingController(),
            lastNameController: TextEditingController(),
            emailController: TextEditingController(),
            passwordController: TextEditingController(),
            confirmPasswordController: TextEditingController(),
            firstNameFocusNode: FocusNode(),
            lastNameFocusNode: FocusNode(),
            emailFocusNode: FocusNode(),
            passwordFocusNode: FocusNode(),
            confirmPasswordFocusNode: FocusNode(),
          ),
        );
      },
    );
    on<OnBoardingCompletePageOneEvent>(
      (event, emit) {
        final OnBoardingRegistrationState registrationState =
            state as OnBoardingRegistrationState;
        if (registrationState.pageOneFormKey.currentState!.validate()) {
          registrationState.pageController.nextPage(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
          );
          emit(
            registrationState.copyWith(
              scrollEnabled: true,
              autovalidateMode: AutovalidateMode.disabled,
              pageIndex: 1,
            ),
          );
        } else {
          emit(
            registrationState.copyWith(
              autovalidateMode: AutovalidateMode.always,
              scrollEnabled: false,
            ),
          );
        }
      },
    );
    on<OnBoardingEditPageOneEvent>(
      ((event, emit) => emit(
            (state as OnBoardingRegistrationState).copyWith(
              scrollEnabled: false,
            ),
          )),
    );
    on<OnBoardingCompletePageTwoEvent>((event, emit) {
      final registrationState = state as OnBoardingRegistrationState;
      if (registrationState.pageTwoFormKey.currentState!.validate()) {
        registrationState.pageController.nextPage(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
        emit(
          registrationState.copyWith(
            autovalidateMode: AutovalidateMode.disabled,
            pageIndex: 2,
          ),
        );
      } else {
        emit(
          registrationState.copyWith(
            autovalidateMode: AutovalidateMode.always,
          ),
        );
      }
    });
    on<OnBoardingSwipeEvent>((event, emit) {
      final registrationState = state as OnBoardingRegistrationState;
      registrationState.firstNameFocusNode.unfocus();
      registrationState.lastNameFocusNode.unfocus();
      registrationState.emailFocusNode.unfocus();
      registrationState.passwordFocusNode.unfocus();
      registrationState.confirmPasswordFocusNode.unfocus();
      emit(registrationState.copyWith(pageIndex: event.pageIndex));
    });
  }

  void completeIntro() => add(const OnBoardingCompleteIntro());

  void completePageOne() => add(const OnBoardingCompletePageOneEvent());

  void completePageTwo() => add(const OnBoardingCompletePageTwoEvent());

  void onEditPageOneText() => add(const OnBoardingEditPageOneEvent());

  void swipe(int pageIndex) => add(OnBoardingSwipeEvent(pageIndex: pageIndex));
}
