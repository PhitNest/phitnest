import '../../../entities/entities.dart';
import '../screen_state.dart';

abstract class RequestLocationState extends ScreenState {
  const RequestLocationState() : super();
}

class FetchingLocationState extends RequestLocationState {
  const FetchingLocationState() : super();
}

class FetchingGymState extends FetchingLocationState {
  final LocationEntity location;

  const FetchingGymState({required this.location}) : super();

  @override
  List<Object> get props => [location];
}

class ErrorState extends RequestLocationState {
  final String message;

  const ErrorState({required this.message}) : super();

  @override
  List<Object> get props => [message];
}

class RequestLocationCubit extends ScreenCubit<RequestLocationState> {
  RequestLocationCubit() : super(const FetchingLocationState());

  void transitionToFetchingGym(LocationEntity location) =>
      setState(FetchingGymState(location: location));

  void transitionToError(String message) =>
      setState(ErrorState(message: message));

  void transitionToFetchingLocation() =>
      setState(const FetchingLocationState());
}
