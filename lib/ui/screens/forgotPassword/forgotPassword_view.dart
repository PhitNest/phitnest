import 'package:flutter/material.dart';
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
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your Email Address',
              ),
              validator: validateEmail,
              controller: emailController,
            ),
            ElevatedButton(
              child: (Text('Submit')),
              // May be 'email' instead of emailController.text
              onPressed: () =>
                  onClickSendPasswordResetEmail(emailController.text),
            )
          ],
        ),
      ),
    );
  }
}
