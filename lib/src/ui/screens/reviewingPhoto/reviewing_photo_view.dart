import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme.dart';
import '../../widgets/widgets.dart';
import '../view.dart';

class ReviewingPhotoView extends ScreenView {
  final String name;
  final VoidCallback onPressedFinish;

  const ReviewingPhotoView({
    required this.name,
    required this.onPressedFinish,
  }) : super();

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          body: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                double.infinity.horizontalSpace,
                90.verticalSpace,
                Text(
                  "Thank You",
                  style: theme.textTheme.headlineLarge,
                ),
                40.verticalSpace,
                RichText(
                  text: TextSpan(
                    text:
                        'Dear $name,\n\nWe are reviewing your photo.\n\nIt may take up to 48 hours to review\nyour photo. Please make sure\n',
                    style: theme.textTheme.labelMedium!
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
                140.verticalSpace,
                StyledButton(
                  onPressed: onPressedFinish,
                  child: Text(
                    'FINISH',
                  ),
                )
              ],
            ),
          ),
        ),
      );
}
