import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/utils.dart';
import '../../../common/validators.dart';
import '../../../repositories/repositories.dart';
import '../../widgets/widgets.dart';
import '../screen_provider.dart';
import '../screens.dart';
import 'register_page_two_state.dart';
import 'register_page_two_view.dart';

class RegisterPageTwoProvider
    extends ScreenProvider<RegisterPageTwoCubit, RegisterPageTwoState> {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final scrollController = ScrollController();
  final String firstName;
  final String lastName;
  final String? initialEmail;
  final String? initialPassword;
  final String? initialErrorMessage;
  late final FocusNode emailFocus = FocusNode()
    ..addListener(
      () {
        if (emailFocus.hasFocus) {
          scrollToEmail();
        }
      },
    );
  late final FocusNode passwordFocus = FocusNode()
    ..addListener(
      () {
        if (passwordFocus.hasFocus) {
          scrollToPassword();
        }
      },
    );
  late final FocusNode confirmPasswordFocus = FocusNode()
    ..addListener(
      () {
        if (confirmPasswordFocus.hasFocus) {
          scrollToConfirmPassword();
        }
      },
    );

  void scrollToEmail() => scroll(scrollController, 10.h);

  void scrollToPassword() => scroll(scrollController, 20.h);

  void scrollToConfirmPassword() => scroll(scrollController, 30.h);

  RegisterPageTwoProvider({
    required this.firstName,
    required this.lastName,
    this.initialEmail,
    this.initialPassword,
    this.initialErrorMessage,
  })  : emailController = TextEditingController(text: initialEmail),
        passwordController = TextEditingController(text: initialPassword),
        super();

  @override
  RegisterPageTwoCubit buildCubit() => RegisterPageTwoCubit();

  @override
  Future<void> listener(
    BuildContext context,
    RegisterPageTwoCubit cubit,
    RegisterPageTwoState state,
  ) async {
    if (initialErrorMessage != null) {
      cubit.transitionToError(initialErrorMessage!);
    }
  }

  @override
  Widget builder(
    BuildContext context,
    RegisterPageTwoCubit cubit,
    RegisterPageTwoState state,
  ) =>
      RegisterPageTwoView(
        scrollController: scrollController,
        formKey: formKey,
        autovalidateMode: state.autovalidateMode,
        emailController: emailController,
        passwordController: passwordController,
        confirmPasswordController: confirmPasswordController,
        validateEmail: (value) => validateEmail(value),
        validatePassword: (value) => validatePassword(value),
        validateConfirmPassword: (value) =>
            value == passwordController.text ? null : 'Passwords do not match',
        onTapEmail: () {
          cubit.transitionToInitial();
          onTappedTextField(scrollToEmail);
        },
        onTapPassword: () {
          cubit.transitionToInitial();
          onTappedTextField(scrollToPassword);
        },
        onTapConfirmPassword: () {
          cubit.transitionToInitial();
          onTappedTextField(scrollToConfirmPassword);
        },
        emailFocus: emailFocus,
        passwordFocus: passwordFocus,
        confirmPasswordFocus: confirmPasswordFocus,
        onPressedNext: () {
          if (formKey.currentState!.validate()) {
            Navigator.of(context).push(
              NoAnimationMaterialPageRoute(
                builder: (context) => RequestLocationProvider(
                  onFoundNearestGym: (context, gym) async {
                    memoryCacheRepo.myGym = gym;
                    Navigator.push(
                      context,
                      NoAnimationMaterialPageRoute(
                        builder: (context) => PhotoInstructionProvider(
                          email: emailController.text,
                          password: passwordController.text,
                          firstName: firstName,
                          lastName: lastName,
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          } else {
            cubit.enableAutovalidateMode();
          }
        },
        onPressedBack: () => Navigator.of(context)
          ..pop()
          ..pop()
          ..push(
            NoAnimationMaterialPageRoute(
              builder: (context) => RegisterPageOneProvider(
                initialFirstName: firstName,
                initialLastName: lastName,
                email: emailController.text,
                password: passwordController.text,
              ),
            ),
          ),
        initialErrorMessage: state is ErrorState ? state.errorMessage : null,
      );

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    confirmPasswordFocus.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
