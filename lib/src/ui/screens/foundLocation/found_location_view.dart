import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../entities/entities.dart';
import '../../theme.dart';
import '../../widgets/widgets.dart';
import '../view.dart';

class FoundLocationView extends ScreenView {
  final VoidCallback onPressedNo;
  final VoidCallback onPressedYes;
  final AddressEntity address;
  final VoidCallback onPressedBack;

  const FoundLocationView({
    required this.onPressedNo,
    required this.address,
    required this.onPressedYes,
    required this.onPressedBack,
  });

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          body: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: SizedBox(
              height: 1.sh,
              child: Column(
                children: [
                  40.verticalSpace,
                  BackArrowButton(
                    onPressed: onPressedBack,
                  ),
                  120.verticalSpace,
                  SizedBox(
                    width: 321.w,
                    child: Text(
                      'Is this your\nfitness club?',
                      style:
                          theme.textTheme.headlineLarge!.copyWith(height: 1.2),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  42.verticalSpace,
                  SizedBox(
                    width: 291.w,
                    child: Text(
                      address.toString(),
                      style: theme.textTheme.labelLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  40.verticalSpace,
                  StyledButton(
                    onPressed: onPressedYes,
                    child: Text('YES'),
                  ),
                  Expanded(child: Container()),
                  TextButtonWidget(
                    text: 'NO, IT\S NOT',
                    onPressed: onPressedNo,
                  ),
                  37.verticalSpace,
                ],
              ),
            ),
          ),
        ),
      );
}
