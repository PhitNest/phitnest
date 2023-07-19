part of '../ui.dart';

final class RegisterInviterEmailPage extends StatelessWidget {
  const RegisterInviterEmailPage({super.key}) : super();

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          120.verticalSpace,
          Text(
            'Inviter email',
            style: theme.textTheme.bodyLarge,
          ),
          42.verticalSpace,
          StyledUnderlinedTextField(
            hint: 'Inviter Email',
            controller:
                context.registerFormBloc.controllers.inviterEmailController,
            validator: EmailValidator.validateEmail,
          ),
          28.verticalSpace,
          Center(
            child: ElevatedButton(
              onPressed: () => context.registerFormBloc.submit(
                onAccept: () => context.registerLoaderBloc.add(
                  LoaderLoadEvent(
                    RegisterParams(
                      email: context
                          .registerFormBloc.controllers.emailController.text,
                      password: context
                          .registerFormBloc.controllers.passwordController.text,
                      firstName: context.registerFormBloc.controllers
                          .firstNameController.text,
                      lastName: context
                          .registerFormBloc.controllers.lastNameController.text,
                      inviterEmail: context.registerFormBloc.controllers
                          .inviterEmailController.text,
                    ),
                  ),
                ),
              ),
              child: Text(
                'SUBMIT',
                style: theme.textTheme.bodySmall,
              ),
            ),
          )
        ],
      );
}
