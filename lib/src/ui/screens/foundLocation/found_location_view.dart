import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../models/models.dart';
import '../../common/widgets.dart';
import '../explore/explore_provider.dart';
import '../view.dart';

class FoundLocationView extends ScreenView {
  final Function() onPressedNo;
  final Function() onPressedYes;
  final Address address;

  const FoundLocationView({
    required this.onPressedNo,
    required this.address,
    required this.onPressedYes,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              200.verticalSpace,
              SizedBox(
                width: 321.w,
                child: Text(
                  'Is this your fitness club?',
                  style: Theme.of(context).textTheme.headlineLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              42.verticalSpace,
              SizedBox(
                width: 291.w,
                child: Text(
                  address.toString(),
                  style: Theme.of(context).textTheme.labelLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              40.verticalSpace,
              StyledButton(
                onPressed: onPressedYes,
                child: Text('YES'),
              ),
              Expanded(child: Container()),
              TextButton(
                onPressed: onPressedNo,
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.transparent),
                ),
                child: Text(
                  'NO, IT\'S NOT',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.black,
                      fontStyle: FontStyle.italic,
                      decoration: TextDecoration.underline),
                ),
              ),
              37.verticalSpace,
            ],
          ),
        ),

        /// This floating action button is for debugging purpose only
        floatingActionButton: StyledButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ExploreProvider(),
            ),
          ),
          child: Text('SKIP TUTORIAL'),
        ),
      );
}
