part of '../ui.dart';

class RegisterInviterEmailPage extends StatelessWidget {
  const RegisterInviterEmailPage({super.key}) : super();

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: context.registerBloc.inviterEmailController,
            validator: EmailValidator.validateEmail,
          ),
          TextButton(
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
            child: const Text('Submit'),
          )
        ],
      );
}
