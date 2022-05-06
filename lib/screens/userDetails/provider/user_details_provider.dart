import 'package:flutter/material.dart';
import 'package:phitnest/screens/userDetails/provider/src/user_details_functions.dart';
import 'package:provider/provider.dart';

import '../../../models/models.dart';
import 'src/user_details_functions.dart';
import 'src/user_details_model.dart';

class UserDetailsProvider extends StatelessWidget {
  final UserModel viewingUser;

  final Widget Function(BuildContext context, UserDetailsModel model,
      UserDetailsFunctions functions, Widget? child) builder;

  UserDetailsProvider(
      {Key? key, required this.viewingUser, required this.builder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => UserDetailsModel(viewingUser: viewingUser),
        child: Consumer<UserDetailsModel>(builder: ((context, model, child) {
          return builder(context, model,
              UserDetailsFunctions(context: context, model: model), child);
        })));
  }
}
