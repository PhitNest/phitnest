import 'package:flutter/material.dart';
import 'package:phitnest/ui/common/widgetStyles/buttonStyles/button_styles.dart';
import 'package:phitnest/ui/screens/base/base_view.dart';

import '../../common/widgets/widgets.dart';

class ForgotPasswordView extends BaseView {
  final TextEditingController emailController;
  final String? Function(String? email) validateEmail;
  final Function(String email) onClickSendPasswordResetEmail;

  const ForgotPasswordView(
      {Key? key,
      required this.emailController,
      required this.validateEmail,
      required this.onClickSendPasswordResetEmail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackButtonAppBar(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextInputFormField(
              key: Key("forgotPasswordEmail"),
              hint: "Enter your Email Address",
              validator: validateEmail,
              controller: emailController,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 1 / 50),
            // ElevatedButton(
            //   child: (Text('Submit')),
            //   // May be 'email' instead of emailController.text
            //   onPressed: () =>
            //       onClickSendPasswordResetEmail(emailController.text),
            // ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 1 / 30),
              child: StyledButton(
                key: Key("signUp_submit"),
                text: 'Submit',
                onClick: () =>
                    onClickSendPasswordResetEmail(emailController.text),
                textColor: Colors.black,
                buttonColor: Button_Styles.LIGHTCYAN,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
