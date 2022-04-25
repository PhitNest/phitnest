import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class ScreenState extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode _validate = AutovalidateMode.disabled;
  Position? currentLocation;
  String? email, password;

  AutovalidateMode get validate => _validate;

  set validate(AutovalidateMode validate) {
    _validate = validate;
    notifyListeners();
  }
}

class LoginScreenProvider extends StatelessWidget {
  final Widget Function(BuildContext context, ScreenState state, Widget? child)
      builder;

  const LoginScreenProvider({Key? key, required this.builder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ScreenState(),
      child: Consumer<ScreenState>(builder: builder),
    );
  }
}
