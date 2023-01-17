import 'package:equatable/equatable.dart';

abstract class RegistrationEvent extends Equatable {
  const RegistrationEvent() : super();

  @override
  List<Object> get props => [];
}

class SwipeEvent extends RegistrationEvent {
  final int pageIndex;

  const SwipeEvent({
    required this.pageIndex,
  }) : super();

  @override
  List<Object> get props => [...super.props, pageIndex];
}

class PageOneTextEdited extends RegistrationEvent {
  const PageOneTextEdited() : super();
}

class SubmitPageOne extends RegistrationEvent {
  const SubmitPageOne() : super();
}

class SubmitPageTwo extends RegistrationEvent {
  const SubmitPageTwo() : super();
}
