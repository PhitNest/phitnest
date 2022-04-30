import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/models.dart';
import 'src/upgrade_account_functions.dart';
import 'src/upgrade_account_model.dart';

class UpgradeAccountProvider extends StatelessWidget {
  final Widget Function(
      BuildContext context,
      UserModel user,
      UpgradeAccountModel model,
      UpgradeAccountFunctions functions,
      Widget? child) builder;

  UpgradeAccountProvider({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => UpgradeAccountModel(),
        child: Consumer<UpgradeAccountModel>(builder: ((context, model, child) {
          UserModel? user = UserModel.fromContext(context);
          return builder(
              context,
              user!,
              model,
              UpgradeAccountFunctions(
                  context: context, user: user, model: model),
              child);
        })));
  }
}
