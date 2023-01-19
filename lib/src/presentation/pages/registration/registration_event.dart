import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phitnest_mobile/src/data/data_sources/backend/auth.data.dart';

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

class GymLoadedErrorEvent extends RegistrationEvent {
  final Failure failure;

  const GymLoadedErrorEvent({
    required this.failure,
  }) : super();

  @override
  List<Object> get props => [...super.props, failure];
}

class UploadingPicture extends RegistrationEvent {
  const UploadingPicture() : super();
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

class SetProfilePictureEvent extends RegistrationEvent {
  final XFile? image;

  const SetProfilePictureEvent(this.image) : super();

  @override
  List<Object> get props => [
        ...super.props,
        ...(image != null ? [image!] : [])
      ];
}

class SubmitPageSix extends RegistrationEvent {
  const SubmitPageSix() : super();
}

class RegistrationRequestErrorEvent extends RegistrationEvent {
  final Failure failure;

  const RegistrationRequestErrorEvent({
    required this.failure,
  }) : super();

  @override
  List<Object> get props => [...super.props, failure];
}

class RegistrationRequestSuccessEvent extends RegistrationEvent {
  const RegistrationRequestSuccessEvent() : super();
}

class UserTakenEvent extends RegistrationEvent {
  const UserTakenEvent() : super();
}
