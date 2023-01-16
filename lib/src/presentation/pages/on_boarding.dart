import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../blocs/on_boarding/on_boarding_bloc.dart';
import '../widgets/on_boarding/on_boarding.dart';
import '../widgets/styled/styled.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      body: BlocProvider(
        create: (context) => OnBoardingBloc(),
        child: BlocBuilder<OnBoardingBloc, OnBoardingState>(
          builder: (context, state) {
            if (state is OnBoardingIntroState) {
              return OnBoardingIntro(
                onPressedButton: () =>
                    context.read<OnBoardingBloc>().completeIntro(),
              );
            } else if (state is OnBoardingRegistrationState) {
              return Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: state.pageController,
                      physics: state.scrollEnabled
                          ? null
                          : NeverScrollableScrollPhysics(),
                      itemCount: 5,
                      onPageChanged: (value) =>
                          context.read<OnBoardingBloc>().swipe(value),
                      itemBuilder: (context, index) {
                        return SingleChildScrollView(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          child: () {
                            switch (index) {
                              case 0:
                                return OnBoardingPageOne(
                                  firstNameFocusNode: state.firstNameFocusNode,
                                  lastNameFocusNode: state.lastNameFocusNode,
                                  topSpacer: (120 - bottom / 8).verticalSpace,
                                  bottomSpacer:
                                      (111 - (bottom * 5) / 12).verticalSpace,
                                  onPressedButton: () => context
                                      .read<OnBoardingBloc>()
                                      .completePageOne(),
                                  formKey: state.pageOneFormKey,
                                  autovalidateMode: state.autovalidateMode,
                                  firstNameController:
                                      state.firstNameController,
                                  lastNameController: state.lastNameController,
                                  onEditText: () => context
                                      .read<OnBoardingBloc>()
                                      .onEditPageOneText(),
                                );
                              case 1:
                                return OnBoardingPageTwo(
                                  emailFocusNode: state.emailFocusNode,
                                  passwordFocusNode: state.passwordFocusNode,
                                  confirmPasswordFocusNode:
                                      state.confirmPasswordFocusNode,
                                  topSpacer: (120 - bottom / 3).verticalSpace,
                                  middleSpacer:
                                      (40 - bottom / 16).verticalSpace,
                                  bottomSpacer: (45 - bottom / 7).verticalSpace,
                                  onPressedButton: () => context
                                      .read<OnBoardingBloc>()
                                      .completePageTwo(),
                                  formKey: state.pageTwoFormKey,
                                  autovalidateMode: state.autovalidateMode,
                                  emailController: state.emailController,
                                  passwordController: state.passwordController,
                                  confirmPasswordController:
                                      state.confirmPasswordController,
                                  firstName:
                                      state.firstNameController.text.trim(),
                                );
                              case 2:
                                return OnBoardingPageThree(
                                  onPressedButton: () {},
                                  firstName:
                                      state.firstNameController.text.trim(),
                                );
                              case 3:
                                break;
                              case 4:
                                break;
                            }
                            throw Exception('Invalid index: $index');
                          }(),
                        );
                      },
                    ),
                  ),
                  StyledPageIndicator(
                    currentPage: state.pageIndex,
                    totalPages: 5,
                  ),
                  (48 - bottom / 8).verticalSpace,
                ],
              );
            } else {
              throw Exception('Invalid state: $state');
            }
          },
        ),
      ),
    );
  }
}
