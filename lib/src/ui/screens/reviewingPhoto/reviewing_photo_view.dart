import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widgets/widgets.dart';
import '../view.dart';

class ReviewingPhotoView extends ScreenView {
  final String userName;
  const ReviewingPhotoView({this.userName = "[Name]"}) : super();

  @override
  String? get appBarText => "Thank You";

  @override
  Widget buildView(BuildContext context) => Container(
        margin: EdgeInsets.symmetric(horizontal: 48.w, vertical: 48.h),
        child: Column(
          children: [
            RichText(
              text: TextSpan(
                text:
                    'Dear $userName,\n\nWe are reviewing your photo.\n\nIt may take up to 48 hours to review\nyour photo. Please make sure\n',
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(fontStyle: FontStyle.italic),
                children: const <TextSpan>[
                  TextSpan(
                      text: 'notification ',
                      style: TextStyle(color: Color(0xFFC11C1C))),
                  TextSpan(
                      text:
                          'are activated on your device.\n\nPlease visit back soon!\n\nThank you for your patience.\n\nSincerely,\n\nMe'),
                ],
              ),
            ),
            96.verticalSpace,
            StyledButton(
                onPressed: () {},
                child: Text(
                  'FINISH',
                ))
          ],
        ),
      );
}
