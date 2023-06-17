part of '../submit.dart';

class OnBoardingSubmitState extends Equatable {
  final AutovalidateMode autovalidateMode;

  const OnBoardingSubmitState({
    required this.autovalidateMode,
  }) : super();

  @override
  List<Object> get props => [autovalidateMode];
}
