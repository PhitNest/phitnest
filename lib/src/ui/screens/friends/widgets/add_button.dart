import 'package:flutter/material.dart';

class AddButton extends Container {
  final BuildContext context;

  AddButton(this.context)
      : super(
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Color(0xFFFFE3E3),
          ),
          child: Text(
            'ADD',
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Colors.black),
          ),
        );
}
