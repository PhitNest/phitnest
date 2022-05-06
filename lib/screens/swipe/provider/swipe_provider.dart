import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/models.dart';
import 'src/swipe_functions.dart';
import 'src/swipe_model.dart';

class SwipeProvider extends StatelessWidget {
  final Widget Function(BuildContext context, SwipeModel model,
      SwipeFunctions functions, Widget? child) builder;

  SwipeProvider({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => SwipeModel(),
        child: Consumer<SwipeModel>(builder: ((context, model, child) {
          UserModel? user = UserModel.fromContext(context);
          return builder(context, model,
              SwipeFunctions(context: context, model: model), child);
        })));
  }
}
