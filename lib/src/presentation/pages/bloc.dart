import 'package:flutter_bloc/flutter_bloc.dart' as FlutterBloc;

import 'bloc_state.dart';

abstract class PageBloc<Event, State extends BlocState>
    extends FlutterBloc.Bloc<Event, State> {
  PageBloc(State initialState) : super(initialState);

  @override
  Future<void> close() async {
    await state.dispose();
    await super.close();
  }
}
