import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/failure.dart';
import '../../../../data/data_sources/backend/backend.dart';
import '../../../../domain/use_cases/use_cases.dart';
import '../bloc/verification_bloc.dart';
import '../event/verification_event.dart';
import '../state/verification_state.dart';
import 'widgets/error.dart';
import 'widgets/initial.dart';
import 'widgets/loading.dart';

VerificationBloc _bloc(BuildContext context) => context.read();

class VerificationPage extends StatelessWidget {
  final String headerText;
  final String email;
  final Future<Failure?> Function(String code) confirm;
  final Future<Failure?> Function() resend;
  final String? password;
  final bool shouldLogin;

  void _onCompleted(BuildContext context) => _bloc(context).add(
        SubmitEvent(
          confirmation: (code) => confirm(code).then(
            (failure) async => failure != null
                ? Right(failure)
                : shouldLogin
                    ? (await login(
                        email,
                        password!,
                      )) as Either<LoginResponse?, Failure>
                    : Left(null),
          ),
        ),
      );

  void _onPressedResend(BuildContext context) =>
      _bloc(context).add(ResendEvent(resend));

  const VerificationPage({
    Key? key,
    required this.headerText,
    required this.email,
    required this.confirm,
    required this.resend,
    required this.password,
    this.shouldLogin = true,
  })  : assert(password != null && shouldLogin ||
            password == null && !shouldLogin),
        super(key: key);

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => VerificationBloc(),
        child: BlocConsumer<VerificationBloc, VerificationState>(
          listener: (context, state) {
            print(state);
            if (state is ConfirmSuccessState) {
              Navigator.pop(context, state.response);
            }
          },
          builder: (context, state) {
            if (state is ConfirmingState) {
              return VerificationLoading(
                codeController: state.codeController,
                codeFocusNode: state.codeFocusNode,
                headerText: headerText,
                email: email,
              );
            } else if (state is ResendingState) {
              return VerificationLoading(
                codeController: state.codeController,
                codeFocusNode: state.codeFocusNode,
                headerText: headerText,
                email: email,
              );
            } else if (state is ConfirmErrorState) {
              return VerificationError(
                codeController: state.codeController,
                codeFocusNode: state.codeFocusNode,
                onCompleted: () => _onCompleted(context),
                onPressedResend: () => _onPressedResend(context),
                headerText: headerText,
                error: state.failure,
                email: email,
              );
            } else if (state is ResendErrorState) {
              return VerificationError(
                codeController: state.codeController,
                codeFocusNode: state.codeFocusNode,
                onCompleted: () => _onCompleted(context),
                onPressedResend: () => _onPressedResend(context),
                headerText: headerText,
                error: state.failure,
                email: email,
              );
            } else if (state is InitialState) {
              return VerificationInitial(
                codeController: state.codeController,
                codeFocusNode: state.codeFocusNode,
                onCompleted: () => _onCompleted(context),
                onPressedResend: () => _onPressedResend(context),
                headerText: headerText,
                email: email,
              );
            } else {
              throw Exception('Invalid state: $state');
            }
          },
        ),
      );
}
