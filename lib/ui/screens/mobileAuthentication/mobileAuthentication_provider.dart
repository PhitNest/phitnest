import 'package:flutter/widgets.dart';
import 'package:progress_widgets/progress_widgets.dart';
import 'package:validation/validation.dart';

import '../../../services/services.dart';
import '../../common/widgets/widgets.dart';
import '../screens.dart';
import 'mobileAuthentication_model.dart';
import 'mobileAuthentication_view.dart';

class MobileAuthenticationProvider extends PreAuthenticationProvider<
    MobileAuthenticationModel, MobileAuthenticationView> {
  const MobileAuthenticationProvider({Key? key}) : super(key: key);

  @override
  MobileAuthenticationView build(
          BuildContext context, MobileAuthenticationModel model) =>
      MobileAuthenticationView(
          formKey: model.formKey,
          validate: model.validate,
          phoneNumberController: model.phoneNumberController,
          validatePhoneNumber: validateMobile,
          onClickTextVerficationCode: () => showProgressUntil(
              context: context,
              message: 'Sending verification code...',
              spinner: LoadingWheel(
                scale: 0.5,
                padding: EdgeInsets.zero,
              ),
              showUntil: () async => await sendText(model),
              onDone: (result) {
                if (result != null) {
                  showAlertDialog(context, 'Mobile Auth Failed', result);
                } else {
                  model.sent = true;
                }
              }));

  Future<String?> sendText(MobileAuthenticationModel model) async {
    if (model.formKey.currentState?.validate() ?? false) {
      model.formKey.currentState!.save();
      return await authService
          .sendMobileAuthRequest(model.phoneNumberController.text.trim());
    }
    model.validate = AutovalidateMode.onUserInteraction;
    return "Invalid Input";
  }

  @override
  MobileAuthenticationModel createModel() => MobileAuthenticationModel();
}
