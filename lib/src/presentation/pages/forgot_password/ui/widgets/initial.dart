import '../../../../widgets/widgets.dart';
import 'base.dart';

class ForgotPasswordInitialPage extends ForgotPasswordBasePage {
  ForgotPasswordInitialPage(
      {required super.emailController,
      required super.passwordController,
      required super.confirmPassController,
      required super.emailFocusNode,
      required super.passwordFocusNode,
      required super.confirmPassFocusNode,
      required super.onSubmit})
      : super(
          child: StyledButton(
            text: 'Submit',
            onPressed: onSubmit,
          ),
        );
}
