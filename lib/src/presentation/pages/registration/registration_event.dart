import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

import '../../../common/failure.dart';
import '../../../domain/entities/entities.dart';

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

class CancelLoading extends RegistrationEvent {
  const CancelLoading() : super();
}

class GymLoadedErrorEvent extends RegistrationEvent {
  final Failure failure;

  const GymLoadedErrorEvent({
    required this.failure,
  }) : super();

  @override
  List<Object> get props => [...super.props, failure];
}

class GymsLoadedEvent extends RegistrationEvent {
  final List<GymEntity> gyms;
  final LocationEntity location;

  const GymsLoadedEvent({
    required this.gyms,
    required this.location,
  }) : super();

  @override
  List<Object> get props => [...super.props, gyms, location];
}

class RefreshGymsEvent extends RegistrationEvent {
  const RefreshGymsEvent() : super();
}

class SetGymEvent extends RegistrationEvent {
  final GymEntity? gym;

  const SetGymEvent({
    required this.gym,
  }) : super();

  @override
  List<Object> get props => [
        ...super.props,
        ...(gym != null ? [gym!] : [])
      ];
}

class SubmitPageThree extends RegistrationEvent {
  const SubmitPageThree() : super();
}

class SubmitPageFour extends RegistrationEvent {
  const SubmitPageFour() : super();
}

class SubmitPageFive extends RegistrationEvent {
  final XFile? image;

  const SubmitPageFive(this.image) : super();

  @override
  List<Object> get props => [
        ...super.props,
        ...(image != null ? [image!] : [])
      ];
}
