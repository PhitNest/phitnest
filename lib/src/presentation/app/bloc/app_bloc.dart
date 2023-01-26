import 'package:flutter_bloc/flutter_bloc.dart';

import '../events/app_event.dart';
import '../states/app_state.dart';
import '../states/initial.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(const AppInitial());
}
