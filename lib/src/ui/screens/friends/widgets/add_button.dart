import 'package:flutter/material.dart';

import '../../../theme.dart';

class AddButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Color(0xFFFFE3E3),
        ),
        child: Text(
          'ADD',
          style: theme.textTheme.bodySmall!.copyWith(color: Colors.black),
        ),
      );
}
