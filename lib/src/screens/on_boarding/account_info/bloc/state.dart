part of '../account_info.dart';

class OnBoardingAccountInfoState extends Equatable {
  final AutovalidateMode autovalidateMode;

  const OnBoardingAccountInfoState({
    required this.autovalidateMode,
  }) : super();

  @override
  List<Object> get props => [autovalidateMode];
}
