import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:phitnest/screens/swipe/provider/swipe_provider.dart';

import '../../models/models.dart';
import '../screen_utils.dart';

class SwipeScreen extends StatefulWidget {
  SwipeScreen({Key? key}) : super(key: key);
  @override
  _SwipeScreenState createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  @override
  Widget build(BuildContext context) {
    return SwipeProvider(
        builder: ((context, model, functions, child) =>
            StreamBuilder<List<UserModel>>(
              stream: model.tinderUsers,
              initialData: [],
              builder: (context, snapshot) {
                if (snapshot.hasError)
                  return Text('Error: ${snapshot.error}'.tr());
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator.adaptive(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(COLOR_ACCENT)),
                      ),
                    );
                  case ConnectionState.active:
                    return functions.asyncCards(context, snapshot.data);
                  case ConnectionState.done:
                }
                return Container(); // unreachable
              },
            )));
  }
}
