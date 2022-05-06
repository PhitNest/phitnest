import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/login_functions.dart';
import 'src/login_model.dart';

class LoginScreenProvider extends StatelessWidget {
  final Widget Function(BuildContext context, LoginModel model,
      LoginFunctions functions, Widget? child) builder;

  LoginScreenProvider({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => LoginModel(),
        child: Consumer<LoginModel>(builder: ((context, model, child) {
          return builder(context, model,
              LoginFunctions(context: context, model: model), child);
        })));
  }
}
