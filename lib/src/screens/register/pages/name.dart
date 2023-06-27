part of '../ui.dart';

String? validateName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Required';
  }
  return null;
}

class RegisterNamePage extends StatelessWidget {
  const RegisterNamePage({super.key}) : super();

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          120.verticalSpace,
          Text(
            'Let\'s get started! \nWhat\'s is your name?',
            style: AppTheme.instance.theme.textTheme.bodyLarge,
          ),
          42.verticalSpace,
          StyledTextFormField(
            labelText: 'First name',
            textController: context.registerBloc.firstNameController,
            validator: validateName,
          ),
          24.verticalSpace,
          StyledTextFormField(
            labelText: 'Last name',
            textController: context.registerBloc.lastNameController,
            validator: validateName,
          ),
          147.verticalSpace,
          ElevatedButton(
            onPressed: () {
              if (context.registerBloc.formKey.currentState!.validate()) {
                _nextPage(context);
              } else {
                context.registerBloc.add(const RegisterFormRejectedEvent());
              }
            },
            child: Text(
              'NEXT',
              style: AppTheme.instance.theme.textTheme.bodySmall,
            ),
          )
        ],
      );
}
