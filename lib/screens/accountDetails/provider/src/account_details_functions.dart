import 'package:flutter/material.dart';
import 'package:phitnest/models/models.dart';
import 'package:phitnest/screens/accountDetails/provider/src/account_details_model.dart';

import '../../../../services/services.dart';

class AccountDetailsFunctions {
  final BuildContext context;
  final UserModel user;
  final AccountDetailsModel model;

  AccountDetailsFunctions(
      {required this.context, required this.user, required this.model});

  validateAndSave() async {
    if (model.key.currentState?.validate() ?? false) {
      model.key.currentState!.save();
      BackEndModel.getBackEnd(context).updateUserDetails(context, model.mobile!,
          model.email!, () async => await _updateUser());
    } else {
      model.validate = AutovalidateMode.onUserInteraction;
    }
  }

  _updateUser() async {
    user.firstName = model.firstName!;
    user.lastName = model.lastName!;
    user.age = model.age!;
    user.bio = model.bio!;
    user.school = model.school!;
    user.email = model.email!;
    user.phoneNumber = model.mobile!;
    await BackEndModel.getBackEnd(context).updateCurrentUser(user: user);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Details saved successfully',
          style: TextStyle(fontSize: 17),
        ),
      ),
    );
  }
}
