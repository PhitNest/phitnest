import '../../../../widgets/widgets.dart';
import 'base.dart';

class ForgotPasswordInitialPage extends ForgotPasswordBasePage {
  ForgotPasswordInitialPage({
    required super.emailController,
    required super.passwordController,
    required super.confirmPassController,
    required super.emailFocusNode,
    required super.passwordFocusNode,
    required super.confirmPassFocusNode,
    required super.onSubmit,
    required super.autovalidateMode,
    required super.formKey,
  }) : super(
          child: StyledButton(
            text: 'SUBMIT',
            onPressed: onSubmit,
          ),
        );
}
