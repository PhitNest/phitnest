import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets.dart';

class _State extends ChangeNotifier {
  bool _obscureText = true;
  final FocusNode iconButtonNode = FocusNode()..skipTraversal = true;

  bool get obscureText => _obscureText;

  set obscureText(bool value) {
    _obscureText = value;
    notifyListeners();
  }
}

class StyledPasswordField extends StatelessWidget {
  final String? hint;
  final String? error;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator? validator;
  final ValueChanged<String>? onFieldSubmitted;

  const StyledPasswordField({
    Key? key,
    this.hint,
    this.error,
    this.controller,
    this.textInputAction,
    this.focusNode,
    this.onEditingComplete,
    this.onChanged,
    this.onFieldSubmitted,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider<_State>(
        create: (_) => _State(),
        child: Consumer<_State>(
          builder: (context, state, child) => StyledUnderlinedTextField(
            onFieldSubmitted: onFieldSubmitted,
            hint: hint,
            errorMaxLines: 2,
            error: error,
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
              constraints: BoxConstraints(),
              icon: Icon(
                Icons.visibility,
                color: Colors.black,
              ),
              onPressed: () => state.obscureText = !state.obscureText,
            ),
          ),
        ),
      );
}
