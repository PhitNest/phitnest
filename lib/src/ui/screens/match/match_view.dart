import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widgets/widgets.dart';
import '../view.dart';

class MatchView extends NavBarScreenView {
  final Function() onPressedSayHello;
  final Function() onPressedMeetMore;

  const MatchView(
      {required this.onPressedSayHello, required this.onPressedMeetMore})
      : super();

  @override
  Widget buildView(BuildContext context) => Container(
      color: Colors.black,
      child: Column(
        children: [
          240.verticalSpace,
          Text("Erin-Michelle J.\nwants to meet you too!",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
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
              backgroundColor: MaterialStateProperty.all(Colors.transparent),
            ),
            child: Text(
              'MEET MORE FRIENDS',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                  decorationColor: Colors.white,
                  decorationThickness: 2,
                  decoration: TextDecoration.underline),
            ),
          ),
          28.verticalSpace,
        ],
      ));

  @override
  int get navbarIndex => 1;

  @override
  bool get systemOverlayDark => false;

  @override
  StyledNavBar navBar(BuildContext context) =>
      super.navBar(context).copyWith(reversed: true);
}
