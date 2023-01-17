import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/theme.dart';
import '../../../common/validators.dart';
import '../../widgets/styled/styled.dart';
import 'registration_bloc.dart';
import 'registration_state.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocProvider<RegistrationBloc>(
        create: (context) => RegistrationBloc(),
        child: BlocBuilder<RegistrationBloc, RegistrationState>(
          builder: (context, state) {
            final keyboardPadding = MediaQuery.of(context).viewInsets.bottom;
            return Scaffold(
              body: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: SizedBox(
                  height: 1.sh,
                  child: Column(
                    children: [
                      Expanded(
                        child: PageView.builder(
                          controller: state.pageController,
                          onPageChanged: (value) =>
                              context.read<RegistrationBloc>().swipe(value),
                          physics: state.scrollEnabled
                              ? null
                              : NeverScrollableScrollPhysics(),
                          itemCount: 2,
                          itemBuilder: (context, index) {
                            List<Widget>? content;
                            switch (index) {
                              case 0:
                                content = [
                                  Text(
                                    "Let's get started!\nWhat can we call you?",
                                    style: theme.textTheme.headlineLarge,
                                    textAlign: TextAlign.center,
                                  ),
                                  40.verticalSpace,
                                  Form(
                                    key: state.pageOneFormKey,
                                    autovalidateMode: state.autovalidateMode,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        StyledUnderlinedTextField(
                                          width: 291.w,
                                          hint: 'First name',
                                          controller: state.firstNameController,
                                          validator: (value) =>
                                              validateName(value),
                                          textInputAction: TextInputAction.next,
                                          textCapitalization:
                                              TextCapitalization.words,
                                          onChanged: (value) => context
                                              .read<RegistrationBloc>()
                                              .editedPageOne(),
                                          focusNode: state.firstNameFocusNode,
                                        ),
                                        12.verticalSpace,
                                        StyledUnderlinedTextField(
                                          width: 291.w,
                                          hint: 'Last name',
                                          controller: state.lastNameController,
                                          validator: (value) =>
                                              validateName(value),
                                          textCapitalization:
                                              TextCapitalization.words,
                                          onFieldSubmitted: (val) => context
                                              .read<RegistrationBloc>()
                                              .submitPageOne(),
                                          onChanged: (value) => context
                                              .read<RegistrationBloc>()
                                              .editedPageOne(),
                                          focusNode: state.lastNameFocusNode,
                                        ),
                                      ],
                                    ),
                                  ),
                                  (105 - keyboardPadding / 4).verticalSpace,
                                  StyledButton(
                                    onPressed: () => context
                                        .read<RegistrationBloc>()
                                        .submitPageOne(),
                                    text: "NEXT",
                                  ),
                                ];
                                break;
                              case 1:
                                content = [
                                  Text(
                                    "Hi, ${state.firstNameController.text.trim()}.\nLet's make an account.",
                                    style: theme.textTheme.headlineLarge,
                                    textAlign: TextAlign.center,
                                  ),
                                  40.verticalSpace,
                                  Form(
                                    key: state.pageTwoFormKey,
                                    autovalidateMode: state.autovalidateMode,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        StyledUnderlinedTextField(
                                          width: 291.w,
                                          hint: 'Email',
                                          controller: state.emailController,
                                          validator: (value) =>
                                              validateEmail(value),
                                          textInputAction: TextInputAction.next,
                                          focusNode: state.emailFocusNode,
                                        ),
                                        12.verticalSpace,
                                        StyledUnderlinedTextField(
                                          width: 291.w,
                                          hint: 'Password',
                                          controller: state.passwordController,
                                          validator: (value) =>
                                              validatePassword(value),
                                          textInputAction: TextInputAction.next,
                                          obscureText: true,
                                          focusNode: state.passwordFocusNode,
                                        ),
                                        12.verticalSpace,
                                        StyledUnderlinedTextField(
                                          width: 291.w,
                                          hint: 'Confirm password',
                                          controller:
                                              state.confirmPasswordController,
                                          onFieldSubmitted: (val) => context
                                              .read<RegistrationBloc>()
                                              .submitPageTwo(),
                                          obscureText: true,
                                          focusNode:
                                              state.confirmPasswordFocusNode,
                                          validator: (value) => state
                                                      .passwordController
                                                      .text ==
                                                  state
                                                      .confirmPasswordController
                                                      .text
                                              ? null
                                              : "Passwords don't match",
                                        ),
                                      ],
                                    ),
                                  ),
                                  (40 - keyboardPadding / 7).verticalSpace,
                                  StyledButton(
                                    onPressed: () => context
                                        .read<RegistrationBloc>()
                                        .submitPageTwo(),
                                    text: "NEXT",
                                  ),
                                ];
                                break;
                            }
                            return Column(
                              children: [
                                (120 - keyboardPadding / 4).verticalSpace,
                                ...content ?? [],
                              ],
                            );
                          },
                        ),
                      ),
                      StyledPageIndicator(
                        currentPage: state.pageIndex,
                        totalPages: 2,
                      ),
                      48.verticalSpace,
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
}
