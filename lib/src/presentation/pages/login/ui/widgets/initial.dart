import '../../../../widgets/styled/styled.dart';
import 'base.dart';

class LoginInitialPage extends LoginPageBase {
  LoginInitialPage({
    required super.emailController,
    required super.passwordController,
    required super.emailFocusNode,
    required super.passwordFocusNode,
    required super.formKey,
    required super.keyboardHeight,
    required super.autovalidateMode,
    required super.onSubmit,
    required super.onPressedForgotPassword,
    required super.onPressedRegister,
    required super.invalidCredentials,
  }) : super(
          child: StyledButton(
            text: 'SIGN IN',
            onPressed: onSubmit,
          ),
        );
}
