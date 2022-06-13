import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phitnest/ui/screens/forgotPassword/forgotPassword_model.dart';
import 'package:phitnest/ui/screens/forgotPassword/forgotPassword_view.dart';
import 'package:phitnest/ui/screens/providers.dart';
import 'package:progress_widgets/progress_widgets.dart';
import 'package:validation/validation.dart';

// ignore: must_be_immutable
class ForgotPasswordProvider
    extends PreAuthenticationProvider<ForgotPasswordModel, ForgotPasswordView> {
  ForgotPasswordProvider({Key? key}) : super(key: key);
  bool checkResult = false;
  @override
  ForgotPasswordView build(BuildContext context, ForgotPasswordModel model) =>
      ForgotPasswordView(
          emailController: model.emailController,
          validateEmail: validateEmail,
          onClickSendPasswordResetEmail: (String email) => showProgressUntil(
              context: context,
              message: 'Sending email...please wait',
              showUntil: () async => await sendEmail(model),
              onDone: (result) async {
                // Call the corresponding showDialog based on the value of result from sendEmail.
                // re-initialize the screen if checkResult is true, indicating that redirectRoute will be called.
                notifyIfEmailWasSent(context, model, result).then((_) {
                  checkResult ? init(context, model) : {};
                });
              }));

  String get redirectRoute => '/signIn';

  // checkResult true => screen goes to redirectRoute. Else stays on current screen
  @override
  Future<bool> get shouldRedirect async => checkResult;

// Sends email to Firebase to check if in the database or that the email entered is in a valid format.
// If not, returns an error.
  Future<String?> sendEmail(ForgotPasswordModel model) async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: model.emailController.text);
    } on FirebaseAuthException catch (except) {
      /// There are many different codes(hover over sendPasswordResetEmail or look up documentation for methods)
      // e.g. for auth/invalid-email the print statement will print: invalid-email
      return except.code;
    }
    //If password sucessfully sent, a redirect should happen in OnDone
    return null;
  }

// If sendEmail returns an error, this method will the except.code sent by firebase and
// push the corresponding AlertDialog to the user. If sendEmail is sucessful(returns null), then
// an AlertDialog is also displayed.
  Future<void> notifyIfEmailWasSent(
      BuildContext context, ForgotPasswordModel model, String? result) async {
    // If email sucessfully sent, checkResult is set to true. This ensures that the redirectRoute is called.
    if (result == null) {
      checkResult = true;

      await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Email Sucessfully Sent"),
              content: Text("Check your email to reset password"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, 'Ok'),
                    child: const Text('Ok'))
              ],
            );
          });

      // If email enter is in an invalid format or no text was entered into field(unknown).
    } else if (result == "invalid-email" || result == "unknown") {
      await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Invalid Email"),
              content: Text("Enter a valid email"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, 'Ok'),
                    child: const Text('Ok'))
              ],
            );
          });

      // If email was not matched with a user
    } else if (result == "user-not-found") {
      await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("User Not Found"),
              content: Text("Email entered is not associated with a user"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, 'Ok'),
                    child: const Text('Ok'))
              ],
            );
          });
    }
    // If some other error. Likely caused by the database server
    else {
      await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Internal Server Error"),
              content: Text("Issue with Server"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, 'Ok'),
                    child: const Text('Ok'))
              ],
            );
          });
    }
  }
}
