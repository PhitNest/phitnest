part of '../submit.dart';

extension _OnBoardingSubmitBlocGetter on BuildContext {
  OnBoardingSubmitBloc get onBoardingSubmitBloc => BlocProvider.of(this);
}

class OnBoardingSubmitBloc
    extends Bloc<OnBoardingSubmitEvent, OnBoardingSubmitState> {
  final firstSubmitController = TextEditingController();
  final lastSubmitController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  OnBoardingSubmitBloc()
      : super(
          const OnBoardingSubmitState(
            autovalidateMode: AutovalidateMode.disabled,
          ),
        ) {
    on<OnBoardingSubmitEvent>(
      (event, emit) => emit(
        const OnBoardingSubmitState(
          autovalidateMode: AutovalidateMode.always,
        ),
      ),
    );
  }

  @override
  Future<void> close() {
    firstSubmitController.dispose();
    lastSubmitController.dispose();
    return super.close();
  }
}
