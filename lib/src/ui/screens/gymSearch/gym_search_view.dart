import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../entities/entities.dart';
import '../../theme.dart';
import '../../widgets/widgets.dart';
import '../../../common/utils.dart';

class LoadedView extends _GymSearchWidget {
  final VoidCallback onPressedConfirm;

  const LoadedView({
    required this.onPressedConfirm,
    required super.gymsAndDistances,
    required super.isSelected,
    required super.onPressedGymCard,
    required super.onTapSearch,
    required super.searchController,
    required super.searchBoxKey,
  }) : super();

  @override
  Widget build(BuildContext context) => BetterScaffold(
        useBackButton: true,
        body: Column(
          children: [
            super.build(context),
            Spacer(),
            StyledButton(
              child: Text('CONFIRM'),
              onPressed: onPressedConfirm,
            ),
            40.verticalSpace,
          ],
        ),
      );
}

class TypingView extends _GymSearchWidget {
  const TypingView({
    required super.gymsAndDistances,
    required super.isSelected,
    required super.onEditSearch,
    required super.onPressedGymCard,
    required super.searchController,
    required super.onSubmitSearch,
    required super.searchBoxKey,
  }) : super();

  @override
  Widget build(BuildContext context) =>
      BetterScaffold(body: super.build(context));
}

class _GymSearchWidget extends StatelessWidget {
  final TextEditingController searchController;
  final List<Tuple2<GymEntity, double>> gymsAndDistances;
  final void Function(GymEntity gym) onPressedGymCard;
  final bool Function(GymEntity gym) isSelected;
  final VoidCallback? onEditSearch;
  final VoidCallback? onTapSearch;
  final VoidCallback? onSubmitSearch;
  final GlobalKey searchBoxKey;

  const _GymSearchWidget({
    required this.searchBoxKey,
    required this.searchController,
    required this.gymsAndDistances,
    required this.onPressedGymCard,
    required this.isSelected,
    this.onEditSearch,
    this.onTapSearch,
    this.onSubmitSearch,
  }) : super();

  @override
  Widget build(BuildContext context) => Column(
        children: [
          SearchBox(
            textFieldKey: searchBoxKey,
            onTap: onTapSearch,
            hintText: 'Search',
            controller: searchController,
            keyboardType: TextInputType.streetAddress,
            onChanged: onEditSearch != null ? (_) => onEditSearch!() : null,
            onSubmitted:
                onSubmitSearch != null ? (_) => onSubmitSearch!() : null,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: ShaderMask(
                shaderCallback: (Rect bounds) => LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0.05),
                    Colors.white,
                    Colors.white,
                    Colors.white.withOpacity(0.05)
                  ],
                  stops: [0, 0.02, 0.95, 1],
                  tileMode: TileMode.mirror,
                ).createShader(bounds),
                child: ListView.builder(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  itemCount: gymsAndDistances.length,
                  itemBuilder: (context, index) => _GymCard(
                    onPressed: () =>
                        onPressedGymCard(gymsAndDistances[index].value1),
                    selected: isSelected(gymsAndDistances[index].value1),
                    gym: gymsAndDistances[index].value1,
                    distance: gymsAndDistances[index].value2,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
}

class LoadingView extends StatelessWidget {
  const LoadingView() : super();

  @override
  Widget build(BuildContext context) => BetterScaffold(
        useBackButton: true,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
}

class ErrorView extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onPressedRetry;

  const ErrorView({
    required this.errorMessage,
    required this.onPressedRetry,
  }) : super();

  @override
  Widget build(BuildContext context) => BetterScaffold(
        useBackButton: true,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              errorMessage,
              style: theme.textTheme.labelLarge!.copyWith(
                color: theme.errorColor,
              ),
              textAlign: TextAlign.center,
            ),
            30.verticalSpace,
            StyledButton(
              child: Text('RETRY'),
              onPressed: onPressedRetry,
            ),
          ],
        ),
      );
}

class _GymCard extends StatelessWidget {
  final bool selected;
  final GymEntity gym;
  final double distance;
  final VoidCallback onPressed;

  _GymCard({
    required this.onPressed,
    required this.selected,
    required this.gym,
    required this.distance,
  }) : super();

  @override
  build(BuildContext context) => Container(
        width: 343.w,
        child: OutlinedButton(
          style: ButtonStyle(
            side: MaterialStateProperty.all(
                BorderSide(color: Colors.transparent)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            )),
            backgroundColor: MaterialStateProperty.all(
                selected ? Color(0xFFFFE3E3) : Colors.transparent),
          ),
          onPressed: onPressed,
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${gym.name} (${distance.formatQuantity("mile")})',
                  style: theme.textTheme.labelMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 250.w,
                  child: Text(gym.address.toString(),
                      style: theme.textTheme.labelMedium),
                )
              ],
            ),
          ),
        ),
      );
}
