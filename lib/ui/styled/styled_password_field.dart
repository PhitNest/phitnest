import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'styled_underline_text_field.dart';

final class _State extends ChangeNotifier {
  bool _obscureText = true;
  final FocusNode iconButtonNode = FocusNode()..skipTraversal = true;

  bool get obscureText => _obscureText;

  set obscureText(bool value) {
    _obscureText = value;
    notifyListeners();
  }
}

final class StyledPasswordField extends StatelessWidget {
  final String? hint;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onChanged;
  final String? Function(dynamic)? validator;
  final ValueChanged<String>? onFieldSubmitted;

  const StyledPasswordField({
    super.key,
    this.hint,
    this.controller,
    this.textInputAction,
    this.focusNode,
    this.onEditingComplete,
    this.onChanged,
    this.onFieldSubmitted,
    this.validator,
  }) : super();

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider<_State>(
        create: (_) => _State(),
        child: Consumer<_State>(
          builder: (context, state, child) => StyledUnderlinedTextField(
            onFieldSubmitted: onFieldSubmitted,
            hint: hint,
            autofillHints: const [AutofillHints.password],
            errorMaxLines: 2,
            controller: controller,
            obscureText: state.obscureText,
            textInputAction: textInputAction,
            focusNode: focusNode,
            keyboardType: TextInputType.visiblePassword,
            onEditingComplete: onEditingComplete,
            onChanged: onChanged,
            validator: validator,
            suffix: IconButton(
              focusNode: state.iconButtonNode,
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.visibility,
                color: state._obscureText ? Colors.grey : Colors.black,
              ),
              onPressed: () => state.obscureText = !state.obscureText,
            ),
          ),
        ),
      );
}
