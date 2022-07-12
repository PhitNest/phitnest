import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../constants/constants.dart';
import '../../textStyles/text_styles.dart';
import 'text_form_decoration.dart';

/// This is a DOB form field widget
class DateInputFormField extends StatefulWidget {
  final String hint;
  final TextStyle? hintStyle;
  final Function(String? text)? onSaved;
  final Function(String text)? onSubmit;
  final String? Function(String? text) validator;
  final TextEditingController controller;
  final TextInputAction? inputAction;
  final EdgeInsets padding;

  const DateInputFormField({
    required Key key,
    required this.hint,
    required this.validator,
    required this.controller,
    this.hintStyle,
    this.onSaved,
    this.inputAction,
    this.padding = const EdgeInsets.symmetric(vertical: 8),
    this.onSubmit,
  }) : super();

  @override
  State<DateInputFormField> createState() => _DateInputFormFieldState();
}

class _DateInputFormFieldState extends State<DateInputFormField> {
  @override
  Widget build(BuildContext context) => Container(
        constraints: const BoxConstraints(minWidth: double.infinity),
        padding: widget.padding,
        child: Stack(
          children: [
            TextFormField(
              key: widget.key,
              textAlignVertical: TextAlignVertical.center,
              textInputAction: widget.inputAction ??
                  (widget.onSubmit == null
                      ? TextInputAction.next
                      : TextInputAction.done),
              onFieldSubmitted: widget.onSubmit,
              keyboardType: TextInputType.datetime,
              onTap: () => openDatePicker(context),
              validator: widget.validator,
              onSaved: widget.onSaved,
              controller: widget.controller,
              style: BodyTextStyle(size: TextSize.LARGE),
              cursorColor: Colors.black,
              decoration: TextFormStyleDecoration(
                  hint: widget.hint, hintStyle: widget.hintStyle),
            ),
            Positioned(
              right: 8.0,
              child: IconButton(
                onPressed: () => openDatePicker(context),
                icon: Icon(Icons.calendar_month),
              ),
            )
          ],
        ),
      );

  openDatePicker(BuildContext context) => showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 73000)),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
          data: ThemeData().copyWith(
            colorScheme:
                Theme.of(context).colorScheme.copyWith(primary: kColorPrimary),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!)).then((date) => setState(() => widget.controller.text =
      DateFormat('yyyy-MM-dd', 'en_US').format(date!).toString()));
}
