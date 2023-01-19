import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/registration_bloc.dart';

class RegistrationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => RegistrationBloc(),
      );
}
