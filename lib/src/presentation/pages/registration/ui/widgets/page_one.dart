part of registration_page;

class _PageOne extends StatelessWidget {
  final double keyboardPadding;
  final GlobalKey<FormState> formKey;
  final AutovalidateMode autovalidateMode;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final FormFieldSetter<String> onFirstNameEdited;
  final FocusNode firstNameFocusNode;
  final FocusNode lastNameFocusNode;
  final VoidCallback onSubmit;

  const _PageOne({
    Key? key,
    required this.keyboardPadding,
    required this.formKey,
    required this.autovalidateMode,
    required this.firstNameController,
    required this.lastNameController,
    required this.onFirstNameEdited,
    required this.firstNameFocusNode,
    required this.lastNameFocusNode,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          40.verticalSpace,
          StyledBackButton(),
          (32 - keyboardPadding / 10).verticalSpace,
          Text(
            "Let's get started!\nWhat can we call you?",
            style: theme.textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          36.verticalSpace,
          SizedBox(
            width: 291.w,
            child: Form(
              key: formKey,
              autovalidateMode: autovalidateMode,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StyledUnderlinedTextField(
                    errorMaxLines: 1,
                    hint: 'First name',
                    controller: firstNameController,
                    validator: (value) => validateName(value),
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    onChanged: onFirstNameEdited,
                    focusNode: firstNameFocusNode,
                  ),
                  8.verticalSpace,
                  StyledUnderlinedTextField(
                    errorMaxLines: 1,
                    hint: 'Last name',
                    controller: lastNameController,
                    validator: (value) => validateName(value),
                    textCapitalization: TextCapitalization.words,
                    onFieldSubmitted: (val) => onSubmit(),
                    focusNode: lastNameFocusNode,
                  ),
                ],
              ),
            ),
          ),
          (105 - keyboardPadding / 4).verticalSpace,
          StyledButton(
            onPressed: onSubmit,
            text: "NEXT",
          ),
        ],
      );
}
