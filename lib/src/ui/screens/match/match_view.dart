import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme.dart';
import '../../widgets/widgets.dart';
import '../view.dart';

class MatchView extends ScreenView {
  final VoidCallback onPressedSayHello;
  final VoidCallback onPressedMeetMore;
  final String fullName;

  const MatchView({
    required this.onPressedSayHello,
    required this.onPressedMeetMore,
    required this.fullName,
  }) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          color: Colors.black,
          child: Column(
            children: [
              240.verticalSpace,
              Text("$fullName\nwants to meet you too!",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium!
                      .copyWith(color: Colors.white)),
              40.verticalSpace,
              StyledButton(
                  onPressed: onPressedSayHello,
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  child: Text("SAY HELLO")),
              Expanded(
                child: Container(),
              ),
              TextButton(
                onPressed: onPressedMeetMore,
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.transparent),
                ),
                child: Text(
                  'MEET MORE FRIENDS',
                  style: theme.textTheme.bodyMedium!.copyWith(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                      decorationColor: Colors.white,
                      decorationThickness: 2,
                      decoration: TextDecoration.underline),
                ),
              ),
              28.verticalSpace,
            ],
          ),
        ),
      );
}
