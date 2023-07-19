part of '../ui.dart';

String? validateName(dynamic value) {
  if (value == null || (value is String && value.isEmpty)) {
    return 'Required';
  }
  return null;
}

final class RegisterNamePage extends StatelessWidget {
  const RegisterNamePage({super.key}) : super();

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          120.verticalSpace,
          Text(
            'Let\'s get started! \nWhat\'s is your name?',
            style: theme.textTheme.bodyLarge,
          ),
          42.verticalSpace,
          StyledUnderlinedTextField(
            hint: 'First name',
            controller:
                context.registerFormBloc.controllers.firstNameController,
            validator: validateName,
          ),
          24.verticalSpace,
          StyledUnderlinedTextField(
            hint: 'Last name',
            controller: context.registerFormBloc.controllers.lastNameController,
            validator: validateName,
          ),
          147.verticalSpace,
          ElevatedButton(
            onPressed: () => context.registerFormBloc.submit(
              onAccept: () => _nextPage(context),
            ),
            child: Text(
              'NEXT',
              style: theme.textTheme.bodySmall,
            ),
          )
        ],
      );
}
