part of '../name.dart';

class OnBoardingNameState extends Equatable {
  final AutovalidateMode autovalidateMode;

  const OnBoardingNameState({
    required this.autovalidateMode,
  }) : super();

  @override
  List<Object> get props => [autovalidateMode];
}
