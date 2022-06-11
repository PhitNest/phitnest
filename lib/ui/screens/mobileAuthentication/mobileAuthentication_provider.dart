import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:phitnest/ui/screens/mobileAuthentication/mobileAuthentication_model.dart';
import 'package:phitnest/ui/screens/mobileAuthentication/mobileAuthentication_view.dart';
import 'package:phitnest/ui/screens/providers.dart';
import 'package:progress_widgets/progress_widgets.dart';
import 'package:validation/validation.dart';

class MobileAuthenticationProvider extends RedirectedProvider<
    MobileAuthenticationModel, MobileAuthenticationView> {
  MobileAuthenticationProvider({Key? key}) : super(key: key);

  @override
  MobileAuthenticationView build(
          BuildContext context, MobileAuthenticationModel model) =>
      MobileAuthenticationView(
          phoneNumberController: model.phoneNumberController,
          validatePhoneNumber: validateMobile,
          onClickTextVerficationCode: (String number) => showProgressUntil(
              context: context,
              message: 'Sending verification code...please wait',
              showUntil: () async => await sendText(model),
              onDone: (result) {}));

  @override
  String get redirectRoute => '/login';

  // Method seems to be called before going to this page? Setting to false seems to work properly. I guess
  // true means the page should redirect somewhere else
  @override
  Future<bool> get shouldRedirect async => false;
}

Future<String> sendText(MobileAuthenticationModel model) async {
  try {
    //phoneNumber string has to look different
    // https://firebase.google.com/docs/auth/flutter/phone-auth
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: model.phoneNumberController.text,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {},
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  } on FirebaseAuthException catch (except) {
    /// There are many different codes(hover over sendPasswordResetEmail or look up documentation for methods)
    /// For now the code is printed to the console and returned false(back to screen to type in email for forgot password).
    // e.g. for auth/invalid-email the print statement will print: invalid-email in debug console(VS-Code)
    // print(except.code);
    return except.code;
  }
  //If password sucessfully sent, a redirect should happen in OnDone
  return "password sent";
}
