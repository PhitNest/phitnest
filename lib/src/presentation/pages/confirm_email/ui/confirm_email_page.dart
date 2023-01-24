import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/confirm_email_bloc.dart';
import '../state/confirm_email_state.dart';
import 'widgets/initial.dart';

class ConfirmEmailPage extends StatelessWidget {
  final String email;
  final String password;

  const ConfirmEmailPage({
    Key? key,
    required this.email,
    required this.password,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => ConfirmEmailBloc(),
        child: BlocConsumer<ConfirmEmailBloc, ConfirmEmailState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is InitialState) {
              return ConfirmEmailInitial(
                codeController: state.codeController,
                codeFocusNode: state.codeFocusNode,
                email: email,
                onChanged: (code) {},
                onCompleted: (code) {},
                onPressedResend: () {},
              );
            } else {
              throw Exception('Invalid state: $state');
            }
          },
        ),
      );
}
