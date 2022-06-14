import 'package:flutter/material.dart';
import 'package:phitnest/ui/screens/base/base_view.dart';

import '../../common/widgets/widgets.dart';

class MobileAuthenticationView extends BaseView {
  final TextEditingController phoneNumberController;
  final String? Function(String? email) validatePhoneNumber;
  final Function() onClickTextVerficationCode;
  final GlobalKey<FormState> formKey;
  final AutovalidateMode validate;

  const MobileAuthenticationView(
      {Key? key,
      required this.phoneNumberController,
      required this.formKey,
      required this.validate,
      required this.validatePhoneNumber,
      required this.onClickTextVerficationCode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackButtonAppBar(),
      body: Form(
        key: formKey,
        autovalidateMode: validate,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MobileInputFormField(
              key: Key("mobileAuth_phoneNumber"),
              onChanged: (phoneNumber) {},
              controller: phoneNumberController,
              validator: validatePhoneNumber,
            ),
            ElevatedButton(
                child: Text("Submit"), onPressed: onClickTextVerficationCode),
            Text("Standard rates apply for sending SMS messages")
          ],
        ),
      ),
    );
  }
}
