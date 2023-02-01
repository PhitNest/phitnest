part of options_page;

class _OptionsBloc extends Bloc<_OptionsEvent, _OptionsState> {
  _OptionsBloc() : super(_InitialState()) {
    on<_SignOutEvent>(onSignOut);
    on<_ErrorEvent>(onOptionsError);
    on<_SuccessEvent>(onSuccess);
  }
}
