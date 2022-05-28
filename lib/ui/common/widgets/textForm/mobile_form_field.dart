import 'package:device/device.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import 'text_form_decoration.dart';

class MobileInputFormField extends StatelessWidget {
  final TextEditingController? controller;
  final AutovalidateMode validate;
  final String? Function(String? input)? validator;
  final Function(String? mobile) onChanged;
  final EdgeInsets padding;

  const MobileInputFormField(
      {required Key key,
      required this.onChanged,
      this.padding = const EdgeInsets.only(top: 16, left: 8, right: 8),
      this.controller,
      this.validate = AutovalidateMode.disabled,
      this.validator})
      : super();

  @override
  build(BuildContext context) => Container(
        constraints: const BoxConstraints(minWidth: double.infinity),
        padding: padding,
        child: InternationalPhoneNumberInput(
            key: key,
            spaceBetweenSelectorAndTextField: 0,
            keyboardType: TextInputType.phone,
            textFieldController: controller,
            selectorConfig: SelectorConfig(
                leadingPadding: 8,
                useEmoji: true,
                trailingSpace: false,
                selectorType: PhoneInputSelectorType.BOTTOM_SHEET),
            initialValue: PhoneNumber(isoCode: 'US'),
            keyboardAction: TextInputAction.next,
            autoValidateMode: validate,
            searchBoxDecoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8, horizontal: 8)),
            inputDecoration: TextFormStyleDecoration(hint: 'Mobile'),
            textAlignVertical: TextAlignVertical.center,
            cursorColor: primaryColor,
            validator: validator,
            onInputChanged: (PhoneNumber number) =>
                onChanged(number.phoneNumber)),
      );
}
