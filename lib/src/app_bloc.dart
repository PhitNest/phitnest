import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_event.dart';
import 'app_state.dart';
import 'domain/entities/entities.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(const AppInitial()) {
    on<RegisteredEvent>(
      (event, emit) => emit(
        AppRegistered(
          user: event.user,
          password: event.password,
        ),
      ),
    );
  }

  void setRegistered({
    required UserEntity user,
    required String password,
  }) =>
      add(
        RegisteredEvent(
          user: user,
          password: password,
        ),
      );
}
