import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phitnest_core/core.dart';

import '../../common/util.dart';
import '../../theme.dart';
import '../../widgets/widgets.dart';
import '../home/ui.dart';
import 'bloc/bloc.dart';

class ConfirmEmailScreen extends StatelessWidget {
  final String password;

  const ConfirmEmailScreen({
    super.key,
    required this.password,
  }) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: BlocProvider(
          create: (_) => ConfirmEmailBloc(),
          child: BlocConsumer<CognitoBloc, CognitoState>(
            listener: (context, cognitoState) {
              switch (cognitoState) {
                case CognitoLoggedInState():
                  Navigator.of(context).pushAndRemoveUntil(
                    CupertinoPageRoute<void>(
                      builder: (context) => const HomeScreen(),
                    ),
                    (route) => false,
                  );
                case CognitoConfirmEmailFailedState():
                  StyledBanner.show(
                    message: 'Invalid confirmation code',
                    error: true,
                  );
                case CognitoResendConfirmEmailResponseEvent(
                    resent: final resent
                  ):
                  StyledBanner.show(
                    message: resent ? 'Code resent.' : 'Code failed to send.',
                    error: resent,
                  );
                default:
              }
            },
            builder: (context, cognitoState) =>
                BlocConsumer<ConfirmEmailBloc, ConfirmEmailState>(
              listener: (context, screenState) {},
              builder: (context, screenState) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    120.verticalSpace,
                    Text(
                      'Verify your email',
                      style: AppTheme.instance.theme.textTheme.bodyLarge,
                    ),
                    52.verticalSpace,
                    StyledVerificationField(
                      controller: context.confirmEmailBloc.codeController,
                      focusNode: context.confirmEmailBloc.focusNode,
                      onChanged: (value) {},
                      onCompleted: (value) {
                        context.cognitoBloc.add(
                          CognitoConfirmEmailEvent(confirmationCode: value),
                        );
                      },
                    ),
                    16.verticalSpace,
                    Center(
                      child: switch (cognitoState) {
                        CognitoResendConfirmEmailLoadingState() ||
                        CognitoConfirmEmailLoadingState() =>
                          const CircularProgressIndicator(),
                        _ => ElevatedButton(
                            onPressed: () => context.cognitoBloc.add(
                              const CognitoResendConfirmEmailEvent(),
                            ),
                            child: Text(
                              'RESEND CODE',
                              style:
                                  AppTheme.instance.theme.textTheme.bodySmall,
                            ),
                          ),
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
