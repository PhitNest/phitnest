part of '../inviter.dart';

extension _OnBoardingInviterBlocGetter on BuildContext {
  OnBoardingInviterBloc get onBoardingInviterBloc => BlocProvider.of(this);
}

class OnBoardingInviterBloc
    extends Bloc<OnBoardingInviterRejectedEvent, OnBoardingInviterState> {
  final TextEditingController inviterController;
  final formKey = GlobalKey<FormState>();

  OnBoardingInviterBloc({
    required String? initialInviter,
  })  : inviterController = TextEditingController(text: initialInviter),
        super(
          const OnBoardingInviterState(
            autovalidateMode: AutovalidateMode.disabled,
          ),
        ) {
    on<OnBoardingInviterRejectedEvent>(
      (event, emit) => emit(
        const OnBoardingInviterState(
          autovalidateMode: AutovalidateMode.always,
        ),
      ),
    );
  }

  @override
  Future<void> close() {
    inviterController.dispose();
    return super.close();
  }
}
