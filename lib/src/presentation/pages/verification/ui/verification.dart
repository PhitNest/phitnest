import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/failure.dart';
import '../bloc/verification.dart';
import '../state/verification.dart';
import 'widgets/initial.dart';

class VerificationPage extends StatelessWidget {
  final String headerText;
  final Future<Failure?> Function(String code) confirm;
  final Future<Failure?> Function() resend;
  final VoidCallback onConfirmed;

  const VerificationPage({
    Key? key,
    required this.headerText,
    required this.confirm,
    required this.resend,
    required this.onConfirmed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => VerificationBloc(),
        child: BlocConsumer(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is InitialState) {
              return VerificationInitial(
                codeController: state.codeController,
                codeFocusNode: state.codeFocusNode,
                onChanged: () {},
                onCompleted: () {},
                onPressedResend: () {},
                headerText: headerText,
              );
            } else {
              throw Exception('Invalid state: $state');
            }
          },
        ),
      );
}
