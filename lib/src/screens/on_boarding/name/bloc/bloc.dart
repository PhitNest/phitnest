part of '../name.dart';

extension _OnBoardingNameBlocGetter on BuildContext {
  OnBoardingNameBloc get onBoardingNameBloc => BlocProvider.of(this);
}

class OnBoardingNameBloc
    extends Bloc<OnBoardingNameRejectedEvent, OnBoardingNameState> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  OnBoardingNameBloc()
      : super(
          const OnBoardingNameState(
            autovalidateMode: AutovalidateMode.disabled,
          ),
        ) {
    on<OnBoardingNameRejectedEvent>(
      (event, emit) => emit(
        const OnBoardingNameState(
          autovalidateMode: AutovalidateMode.always,
        ),
      ),
    );
  }

  @override
  Future<void> close() {
    firstNameController.dispose();
    lastNameController.dispose();
    return super.close();
  }
}
