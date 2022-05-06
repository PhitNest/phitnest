import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/sign_up_functions.dart';
import 'src/sign_up_model.dart';

class SignUpScreenProvider extends StatelessWidget {
  final Widget Function(BuildContext context, SignUpModel model,
      SignUpFunctions functions, Widget? child) builder;

  SignUpScreenProvider({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => SignUpModel(),
        child: Consumer<SignUpModel>(builder: ((context, model, child) {
          return builder(context, model,
              SignUpFunctions(context: context, model: model), child);
        })));
  }
}
