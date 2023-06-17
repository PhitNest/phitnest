part of '../account_info.dart';

extension _OnBoardingAccountInfoBlocGetter on BuildContext {
  OnBoardingAccountInfoBloc get onBoardingAccountInfoBloc =>
      BlocProvider.of(this);
}

class OnBoardingAccountInfoBloc extends Bloc<OnBoardingAccountInfoRejectedEvent,
    OnBoardingAccountInfoState> {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  OnBoardingAccountInfoBloc({
    required String? initialEmail,
    required String? initialPassword,
  })  : emailController = TextEditingController(text: initialEmail),
        passwordController = TextEditingController(text: initialPassword),
        super(
          const OnBoardingAccountInfoState(
            autovalidateMode: AutovalidateMode.disabled,
          ),
        ) {
    on<OnBoardingAccountInfoRejectedEvent>(
      (event, emit) => emit(
        const OnBoardingAccountInfoState(
          autovalidateMode: AutovalidateMode.always,
        ),
      ),
    );
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    return super.close();
  }
}
