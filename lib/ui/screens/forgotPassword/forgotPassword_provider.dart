import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:phitnest/ui/screens/forgotPassword/forgotPassword_model.dart';
import 'package:phitnest/ui/screens/forgotPassword/forgotPassword_view.dart';
import 'package:phitnest/ui/screens/providers.dart';
import 'package:progress_widgets/progress_widgets.dart';
import 'package:validation/validation.dart';

class ForgotPasswordProvider
    extends RedirectedProvider<ForgotPasswordModel, ForgotPasswordView> {
  ForgotPasswordProvider({Key? key}) : super(key: key);

  @override
  ForgotPasswordView build(BuildContext context, ForgotPasswordModel model) =>
      ForgotPasswordView(
          emailController: model.emailController,
          validateEmail: validateEmail,
          onClickSendPasswordResetEmail: (String email) => showProgressUntil(
              context: context,
              message: 'Sending email...please wait',
              showUntil: () async => await sendEmail(model),
              onDone: (result) {
                // If email was matched with a user
                if (result == "password sent") {
                  showAlertDialog(context, "Email Sucessfully Sent",
                      "Check your email to rest password");
                  // Navigator.pushNamed(context, redirectRoute);
                  // If email enter is in an invalid format or no text was entered into field(unknown). Should be before
                  // the user-not-found clause
                } else if (result == "invalid-email" || result == "unknown") {
                  showAlertDialog(
                      context, "Invalid Email", "Enter a valid email");
                  // If email was not matched with a user
                } else if (result == "user-not-found") {
                  showAlertDialog(context, "User Not Found",
                      "Email entered is not associated with a user");
                }
                // If some other error likely caused by the database server
                else {
                  showAlertDialog(
                      context, "Internal Server Error", "Issue with Server");
                }
              }));

  @override
  String get redirectRoute => '/login';

  // Method seems to be called before going to this page? Setting to false seems to work properly. I guess
  // true means the page should redirect somewhere else
  @override
  Future<bool> get shouldRedirect async => false;
}

Future<String> sendEmail(ForgotPasswordModel model) async {
  try {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: model.emailController.text);
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
