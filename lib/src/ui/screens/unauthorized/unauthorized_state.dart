import '../screen_state.dart';

class UnauthorizedState extends ScreenState {
  const UnauthorizedState() : super();
}

class UnauthorizedCubit extends ScreenCubit<UnauthorizedState> {
  UnauthorizedCubit() : super(const UnauthorizedState());
}
