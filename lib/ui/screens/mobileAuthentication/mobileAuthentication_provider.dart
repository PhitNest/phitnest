import 'package:flutter/widgets.dart';
import 'package:phitnest/ui/screens/mobileAuthentication/mobileAuthentication_model.dart';
import 'package:phitnest/ui/screens/mobileAuthentication/mobileAuthentication_view.dart';
import 'package:phitnest/ui/screens/providers.dart';
import 'package:progress_widgets/progress_widgets.dart';
import 'package:validation/validation.dart';

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
}
