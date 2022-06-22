import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../textStyles/text_styles.dart';
import 'text_form_decoration.dart';

/// This is a text form field widget
class DobInputFormField extends StatefulWidget {
  final String hint;
  final TextStyle? hintStyle;
  final Function(String? text)? onSaved;
  final Function(String text)? onSubmit;
  final String? Function(String? text) validator;
  final TextEditingController? controller;
  final bool hide;
  final EdgeInsets padding;
  final TextInputType? inputType;
  final bool? child;

  const DobInputFormField({
    required Key key,
    required this.hint,
    required this.validator,
    this.hintStyle,
    this.onSaved,
    this.controller,
    this.inputType,
    this.padding = const EdgeInsets.symmetric(vertical: 8),
    this.hide = false,
    this.onSubmit,
    this.child = false,
  }) : super();

  @override
  State<DobInputFormField> createState() => _DobInputFormFieldState();
}

class _DobInputFormFieldState extends State<DobInputFormField> {
  DateTime? _dateTime;
  @override
  Widget build(BuildContext context) => Container(
        constraints: const BoxConstraints(minWidth: double.infinity),
        padding: widget.padding,
        child: Stack(
          children: [
            TextFormField(
              key: widget.key,
              textAlignVertical: TextAlignVertical.center,
              textInputAction: widget.onSubmit == null
                  ? TextInputAction.next
                  : TextInputAction.done,
              onFieldSubmitted: widget.onSubmit,
              obscureText: widget.hide,
              keyboardType: widget.inputType,
              validator: widget.validator,
              onSaved: widget.onSaved,
              controller: _dateTime == null
                  ? widget.controller ?? TextEditingController()
                  : TextEditingController(
                      text: DateFormat('yyyy-MM-dd', 'en_US')
                          .format(_dateTime!)
                          .toString()),
              style: BodyTextStyle(size: TextSize.LARGE),
              cursorColor: Colors.black,
              decoration: TextFormStyleDecoration(
                  hint: widget.hint, hintStyle: widget.hintStyle),
            ),
            this.widget.child == true
                ? Positioned(
                    right: 8.0,
                    child: IconButton(
                      onPressed: () {
                        showDatePicker(
                                context: context,
                                initialDate: _dateTime == null
                                    ? DateTime.now()
                                    : _dateTime!,
                                firstDate: DateTime.now()
                                    .subtract(const Duration(days: 36500)),
                                lastDate: DateTime.now())
                            .then((date) => setState(() {
                                  _dateTime = date!;
                                }));
                      },
                      icon: Icon(Icons.calendar_month),
                    ),
                  )
                : Container(),
          ],
        ),
      );
}
