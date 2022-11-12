import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/widgets.dart';
import '../view.dart';

class RegisterPageTwoView extends ScreenView {

  RegisterPageTwoView()
      : super();

  @override
  Widget buildView(BuildContext context) => Column(
        children: [
          28.verticalSpace,
          Text(
            'Register',
            style: Theme.of(context).textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          35.verticalSpace,
          SizedBox(
            width: 291.w,
            child: Form(
              child: Column(
                children: [
                  SizedBox(
                    height: 34.h,
                    child: TextInputField(
                      hint: 'First Name',
                      inputAction: TextInputAction.next,
                    ),
                  ),
                  16.verticalSpace,
                  SizedBox(
                    height: 34.h,
                    child: TextInputField(
                      hint: 'Last Name',
                    ),
                  ),
                ],
              ),
            ),
          ),
          StyledButton(
            onPressed: (() {
              
            }),
            child: Text('NEXT'),
          ),
        ],
      );
}