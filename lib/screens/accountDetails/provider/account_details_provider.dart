import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/models.dart';
import 'src/account_details_functions.dart';
import 'src/account_details_model.dart';

class AccountDetailsProvider extends StatelessWidget {
  final Widget Function(
      BuildContext context,
      UserModel user,
      AccountDetailsModel model,
      AccountDetailsFunctions functions,
      Widget? child) builder;

  AccountDetailsProvider({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => AccountDetailsModel(),
        child: Consumer<AccountDetailsModel>(builder: ((context, model, child) {
          UserModel? user = UserModel.fromContext(context);
          return builder(
              context,
              user!,
              model,
              AccountDetailsFunctions(
                  context: context, user: user, model: model),
              child);
        })));
  }
}
