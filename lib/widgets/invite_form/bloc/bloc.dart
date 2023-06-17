import 'package:async/async.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phitnest_core/core.dart';

part 'event.dart';
part 'state.dart';

extension InviteFormBlocGetter on BuildContext {
  InviteFormBloc get inviteFormBloc => BlocProvider.of(this);
}

Future<HttpResponse<void>> invite(
  String email,
  String gymId,
  String authorization,
) =>
    request(
      route: '/invite',
      method: HttpMethod.post,
      parser: (_) {},
      data: {
        'receiverEmail': email,
        'gymId': gymId,
      },
      authorization: authorization,
    );

class InviteFormBloc extends Bloc<InviteFormEvent, InviteFormState> {
  final emailController = TextEditingController();
  final gymIdController = TextEditingController();
  final String authorization;

  InviteFormBloc(this.authorization) : super(const InviteFormInitialState()) {
    on<InviteFormSubmitEvent>(
      (event, emit) {
        switch (state) {
          case InviteFormInitialState() ||
                InviteFormFailureState() ||
                InviteFormSuccessState():
            emit(
              InviteFormLoadingState(
                CancelableOperation.fromFuture(
                  invite(
                    emailController.text,
                    gymIdController.text,
                    authorization,
                  ),
                )..then((res) => add(InviteFormResponseEvent(res))),
              ),
            );
          case InviteFormLoadingState():
            throw StateException(state, event);
        }
      },
    );

    on<InviteFormResetEvent>(
      (event, emit) async {
        switch (state) {
          case InviteFormInitialState() ||
                InviteFormFailureState() ||
                InviteFormSuccessState():
            emit(const InviteFormInitialState());
          case InviteFormLoadingState(loadingOperation: final loadingOperation):
            await loadingOperation.cancel();
            emit(const InviteFormInitialState());
        }
      },
    );

    on<InviteFormResponseEvent>(
      (event, emit) {
        switch (state) {
          case InviteFormInitialState() ||
                InviteFormSuccessState() ||
                InviteFormFailureState():
            throw StateException(state, event);
          case InviteFormLoadingState():
            emit(
              switch (event.response) {
                HttpResponseOk() => const InviteFormSuccessState(),
                HttpResponseFailure(failure: final failure) =>
                  InviteFormFailureState(failure),
              },
            );
        }
      },
    );
  }

  @override
  Future<void> close() {
    emailController.dispose();
    gymIdController.dispose();
    return super.close();
  }
}
