import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/utils.dart';
import '../../../common/validators.dart';
import '../../widgets/widgets.dart';
import '../screen_provider.dart';
import '../screens.dart';
import 'register_page_one_state.dart';
import 'register_page_one_view.dart';

class RegisterPageOneProvider
    extends ScreenProvider<RegisterPageOneCubit, RegisterPageOneState> {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final formKey = GlobalKey<FormState>();
  final scrollController = ScrollController();
  final String? initialFirstName;
  final String? initialLastName;
  final String? email;
  final String? password;
  late final FocusNode firstNameFocus = FocusNode()
    ..addListener(
      () {
        if (firstNameFocus.hasFocus) {
          scrollToFirstName();
        }
      },
    );
  late final FocusNode lastNameFocus = FocusNode()
    ..addListener(
      () {
        if (lastNameFocus.hasFocus) {
          scrollToLastName();
        }
      },
    );

  void scrollToFirstName() => scroll(scrollController, 10.h);

  void scrollToLastName() => scroll(scrollController, 20.h);

  RegisterPageOneProvider({
    this.initialFirstName,
    this.initialLastName,
    this.email,
    this.password,
  })  : firstNameController = TextEditingController(text: initialFirstName),
        lastNameController = TextEditingController(text: initialLastName),
        super();

  @override
  RegisterPageOneCubit buildCubit() => RegisterPageOneCubit();

  @override
  Widget builder(
    BuildContext context,
    RegisterPageOneCubit cubit,
    RegisterPageOneState state,
  ) =>
      RegisterPageOneView(
        onPressedNext: () {
          if (formKey.currentState!.validate()) {
            Navigator.push(
              context,
              NoAnimationMaterialPageRoute(
                builder: (context) => RegisterPageTwoProvider(
                  firstName: firstNameController.text,
                  lastName: lastNameController.text,
                  initialEmail: email,
                  initialPassword: password,
                ),
              ),
            );
          } else {
            cubit.enableAutovalidateMode();
          }
        },
        firstNameController: firstNameController,
        lastNameController: lastNameController,
        firstNameFocus: firstNameFocus,
        lastNameFocus: lastNameFocus,
        formKey: formKey,
        scrollController: scrollController,
        validateFirstName: (value) => validateName(value),
        validateLastName: (value) => validateName(value),
        onTappedFirstName: () => onTappedTextField(scrollToFirstName),
        onTappedLastName: () => onTappedTextField(scrollToLastName),
        autovalidateMode: state.autovalidateMode,
      );

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    firstNameFocus.dispose();
    lastNameFocus.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
