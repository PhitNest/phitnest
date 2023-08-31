import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final class NavBarPageButton extends StatelessWidget {
  final String text;
  final bool selected;
  final bool reversed;
  final void Function() onPressed;

  const NavBarPageButton({
    Key? key,
    required this.text,
    required this.selected,
    required this.reversed,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => TextButton(
        style: ButtonStyle(
          maximumSize: MaterialStateProperty.all(Size.fromWidth(78.w)),
          minimumSize: MaterialStateProperty.all(Size.fromWidth(78.w)),
          overlayColor: MaterialStateProperty.all(Colors.transparent),
        ),
        onPressed: !selected ? onPressed : null,
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontWeight: FontWeight.bold,
                color: reversed
                    ? selected
                        ? Colors.white
                        : Color.fromARGB((0.7 * 255).round(), 255, 255, 255)
                    : selected
                        ? Colors.black
                        : Color.fromARGB((0.4 * 255).round(), 0, 0, 0),
              ),
        ),
      );
}
