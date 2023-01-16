import 'package:equatable/equatable.dart';

abstract class OnBoardingEvent extends Equatable {
  const OnBoardingEvent() : super();

  @override
  List<Object> get props => [];
}

class OnBoardingCompleteIntro extends OnBoardingEvent {
  const OnBoardingCompleteIntro() : super();
}

class OnBoardingCompletePageOneEvent extends OnBoardingEvent {
  const OnBoardingCompletePageOneEvent() : super();
}

class OnBoardingCompletePageTwoEvent extends OnBoardingEvent {
  const OnBoardingCompletePageTwoEvent() : super();
}

class OnBoardingSwipeEvent extends OnBoardingEvent {
  final int pageIndex;

  const OnBoardingSwipeEvent({
    required this.pageIndex,
  }) : super();

  @override
  List<Object> get props => [
        ...super.props,
        pageIndex,
      ];
}

class OnBoardingEditPageOneEvent extends OnBoardingEvent {
  const OnBoardingEditPageOneEvent() : super();
}
