import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/theme.dart';
import '../../../common/validators.dart';
import '../../widgets/widgets.dart';

class OnBoardingPageOne extends StatelessWidget {
  final VoidCallback onPressedButton;
  final GlobalKey<FormState> formKey;
  final AutovalidateMode autovalidateMode;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final FocusNode firstNameFocusNode;
  final FocusNode lastNameFocusNode;
  final VoidCallback onEditText;
  final Widget topSpacer;
  final Widget bottomSpacer;

  const OnBoardingPageOne({
    Key? key,
    required this.onPressedButton,
    required this.formKey,
    required this.autovalidateMode,
    required this.firstNameController,
    required this.lastNameController,
    required this.firstNameFocusNode,
    required this.lastNameFocusNode,
    required this.onEditText,
    required this.topSpacer,
    required this.bottomSpacer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        double.infinity.horizontalSpace,
        topSpacer,
        Text(
          "Let's get started!\nWhat can we call you?",
          style: theme.textTheme.headlineLarge,
          textAlign: TextAlign.center,
        ),
        40.verticalSpace,
        Form(
          key: formKey,
          autovalidateMode: autovalidateMode,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StyledUnderlinedTextField(
                width: 291.w,
                hint: 'First name',
                controller: firstNameController,
                validator: (value) => validateName(value),
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                onChanged: (value) => onEditText(),
                focusNode: firstNameFocusNode,
              ),
              12.verticalSpace,
              StyledUnderlinedTextField(
                width: 291.w,
                hint: 'Last name',
                controller: lastNameController,
                validator: (value) => validateName(value),
                textCapitalization: TextCapitalization.words,
                onFieldSubmitted: (val) => onPressedButton(),
                onChanged: (value) => onEditText(),
                focusNode: lastNameFocusNode,
              ),
            ],
          ),
        ),
        bottomSpacer,
        StyledButton(
          onPressed: onPressedButton,
          text: "NEXT",
        ),
      ],
    );
  }
}
