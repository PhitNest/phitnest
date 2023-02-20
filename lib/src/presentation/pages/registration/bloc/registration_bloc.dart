part of registration_page;

const pageAnimation = const Duration(milliseconds: 400);

class _RegistrationBloc extends Bloc<_IRegistrationEvent, _IRegistrationState> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final pageController = PageController();
  final pageOneFormKey = GlobalKey<FormState>();
  final pageTwoFormKey = GlobalKey<FormState>();
  final firstNameFocusNode = FocusNode();
  final lastNameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();

  _RegistrationBloc()
      : super(
          _InitialState(
            firstNameConfirmed: false,
            loadGymsOp:
                CancelableOperation.fromFuture(UseCases.getNearbyGyms()),
            currentPage: 0,
            takenEmails: {},
            autovalidateMode: AutovalidateMode.disabled,
          ),
        ) {
    if (state is _InitialState) {
      (state as _InitialState).loadGymsOp.then(
            (either) => either.fold(
              (success) =>
                  add(_IGymsLoadedStateEvent(success.value1, success.value2)),
              (failure) => add(_GymsLoadingErrorEvent(failure)),
            ),
          );
    }
    on<_RetryLoadGymsEvent>(onRetryLoadGyms);
    on<_EditFirstNameEvent>(onEditFirstName);
    on<_IGymsLoadedStateEvent>(onGymsLoaded);
    on<_GymsLoadingErrorEvent>(onGymsLoadingError);
    on<_IGymSelectedStateEvent>(onGymSelected);
    on<_SwipeEvent>(onSwipe);
    on<_SubmitPageOneEvent>(onSubmitPageOne);
    on<_SubmitPageTwoEvent>(onSubmitPageTwo);
    on<_RegisterEvent>(onRegister);
    on<_RegisterErrorEvent>(onRegisterError);
    on<_SuccessEvent>(onSuccess);
  }

  @override
  Future<void> close() async {
    if (state is _RegisterLoadingState) {
      final state = this.state as _RegisterLoadingState;
      await state.registerOp.cancel();
    }
    if (state is _InitialState) {
      final state = this.state as _InitialState;
      await state.loadGymsOp.cancel();
    }
    if (state is _RegisterErrorState) {
      final state = this.state as _RegisterErrorState;
      state.banner.dismiss();
    }
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    pageController.dispose();
    firstNameFocusNode.dispose();
    lastNameFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    return super.close();
  }
}
