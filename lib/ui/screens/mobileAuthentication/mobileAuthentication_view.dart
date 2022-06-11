import 'package:flutter/material.dart';
import 'package:phitnest/ui/screens/base/base_view.dart';

import '../../common/widgets/widgets.dart';

class MobileAuthenticationView extends BaseView {
  final TextEditingController phoneNumberController;
  final String? Function(String? email) validatePhoneNumber;
  final Function(String email) onClickTextVerficationCode;

  const MobileAuthenticationView(
      {Key? key,
      required this.phoneNumberController,
      required this.validatePhoneNumber,
      required this.onClickTextVerficationCode})
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
                hintText: 'Enter your Phone Number',
              ),
              validator: validatePhoneNumber,
              controller: phoneNumberController,
              keyboardType: TextInputType.number,
              maxLength: 10,
            ),
            ElevatedButton(
                child: Text("Submit"),
                // May be 'phoneNumber' instead of phoneNumberController.text
                onPressed: () =>
                    onClickTextVerficationCode(phoneNumberController.text)),
            Text("Standard rates apply for sending SMS messages")
          ],
        ),
      ),
    );
  }
}
