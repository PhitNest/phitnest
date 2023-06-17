part of '../inviter.dart';

class OnBoardingInviterState extends Equatable {
  final AutovalidateMode autovalidateMode;

  const OnBoardingInviterState({
    required this.autovalidateMode,
  }) : super();

  @override
  List<Object> get props => [autovalidateMode];
}
