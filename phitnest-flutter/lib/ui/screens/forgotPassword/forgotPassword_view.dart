import 'package:flutter/material.dart';

import '../../common/widgets/widgets.dart';
import '../screen_view.dart';

class ForgotPasswordView extends ScreenView {
  static const Duration transitionDuration = Duration(milliseconds: 500);

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final String? Function(String? email) validateEmail;
  final bool sent;
  final Function() onClickSendPasswordResetEmail;
  final AutovalidateMode validate;

  const ForgotPasswordView(
      {Key? key,
      required this.formKey,
      required this.emailController,
      required this.sent,
      required this.validateEmail,
      required this.validate,
      required this.onClickSendPasswordResetEmail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BackButtonAppBar(),
        body: Center(
          child: AnimatedSwitcher(
              duration: transitionDuration,
              transitionBuilder: (Widget child, Animation<double> animation) =>
                  FadeTransition(opacity: animation, child: child),
              child: sent
                  ? Text(
                      "A password reset email has been sent to ${emailController.text}")
                  : Form(
                      key: formKey,
                      autovalidateMode: validate,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          TextInputFormField(
                            key: Key("forgotPasswordEmail"),
                            hint: "Enter your Email Address",
                            validator: validateEmail,
                            controller: emailController,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 1 / 50,
                            child: StyledButton(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width *
                                          1 /
                                          30),
                              key: Key("signUp_submit"),
                              text: 'Submit',
                              onClick: onClickSendPasswordResetEmail,
                            ),
                          )
                        ],
                      ),
                    )),
        ));
  }
}
