import 'package:flutter/material.dart';
import 'package:progress_widgets/progress_widgets.dart';
import 'package:validation/validation.dart';

import '../../../apis/api.dart';
import '../../common/widgets/widgets.dart';
import '../screens.dart';
import 'forgotPassword_model.dart';
import 'forgotPassword_view.dart';

class ForgotPasswordProvider
    extends PreAuthenticationProvider<ForgotPasswordModel, ForgotPasswordView> {
  const ForgotPasswordProvider({Key? key}) : super(key: key);

  @override
  ForgotPasswordView build(BuildContext context, ForgotPasswordModel model) =>
      ForgotPasswordView(
          formKey: model.formKey,
          validate: model.validate,
          emailController: model.emailController,
          sent: model.sent,
          validateEmail: validateEmail,
          onClickSendPasswordResetEmail: () => showProgressUntil(
              context: context,
              message: 'Sending a password reset link to your email...',
              showUntil: () async => await sendEmail(model),
              spinner: LoadingWheel(
                scale: 0.5,
                padding: EdgeInsets.zero,
              ),
              onDone: (result) async {
                if (result != null) {
                  showAlertDialog(context, 'Email Failed', result);
                } else {
                  model.sent = true;
                }
              }));

  /// Sends a password reset email, return an error code if unsuccessful.
  /// Otherwise, return null
  Future<String?> sendEmail(ForgotPasswordModel model) async {
    if (model.formKey.currentState?.validate() ?? false) {
      model.formKey.currentState!.save();
      return await api<AuthenticationApi>()
          .sendResetPasswordEmail(model.emailController.text.trim());
    }
    model.validate = AutovalidateMode.onUserInteraction;
    return 'Invalid Input';
  }

  @override
  ForgotPasswordModel createModel() => ForgotPasswordModel();
}
