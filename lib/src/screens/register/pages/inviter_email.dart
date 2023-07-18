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
            style: AppTheme.instance.theme.textTheme.bodyLarge,
          ),
          42.verticalSpace,
          StyledTextFormField(
            labelText: 'Inviter email',
            textController: context.registerBloc.inviterEmailController,
            validator: EmailValidator.validateEmail,
          ),
          28.verticalSpace,
          Center(
            child: ElevatedButton(
              onPressed: () {
                if (context.registerBloc.formKey.currentState!.validate()) {
                  context.cognitoBloc.add(
                    CognitoRegisterEvent(
                      email: context.registerBloc.emailController.text,
                      password: context.registerBloc.passwordController.text,
                      firstName: context.registerBloc.firstNameController.text,
                      lastName: context.registerBloc.lastNameController.text,
                      inviterEmail:
                          context.registerBloc.inviterEmailController.text,
                    ),
                  );
                } else {
                  context.registerBloc.add(const RegisterFormRejectedEvent());
                }
              },
              child: Text(
                'SUBMIT',
                style: AppTheme.instance.theme.textTheme.bodySmall,
              ),
            ),
          )
        ],
      );
}
