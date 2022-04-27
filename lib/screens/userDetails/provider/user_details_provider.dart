import 'package:flutter/material.dart';
import 'package:phitnest/screens/userDetails/provider/src/user_details_functions.dart';
import 'package:provider/provider.dart';

import '../../../models/models.dart';
import 'src/user_details_functions.dart';
import 'src/user_details_model.dart';

class UserDetailsProvider extends StatelessWidget {
  final Widget Function(
      BuildContext context,
      UserModel user,
      UserDetailsModel model,
      UserDetailsFunctions functions,
      Widget? child) builder;

  UserDetailsProvider({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => UserDetailsModel(),
        child: Consumer<UserDetailsModel>(builder: ((context, model, child) {
          UserModel? user = UserModel.fromContext(context);
          return builder(
              context,
              user!,
              model,
              UserDetailsFunctions(context: context, user: user, model: model),
              child);
        })));
  }
}
