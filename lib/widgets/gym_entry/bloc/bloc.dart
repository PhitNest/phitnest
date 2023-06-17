import 'package:async/async.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phitnest_core/core.dart';

import '../response.dart';

part 'event.dart';
part 'state.dart';

extension GymEntryFormBlocGetter on BuildContext {
  GymEntryFormBloc get gymEntryFormBloc => BlocProvider.of(this);
}

Future<HttpResponse<GymEntryFormSuccess>> addGym({
  required String name,
  required String street,
  required String city,
  required String state,
  required String zipCode,
  required String authorization,
}) =>
    request(
      route: '/gym',
      method: HttpMethod.post,
      parser: GymEntryFormSuccess.fromJson,
      data: {
        'name': name,
        'street': street,
        'city': city,
        'state': state,
        'zipCode': zipCode,
      },
      authorization: authorization,
    );

class GymEntryFormBloc extends Bloc<GymEntryFormEvent, GymEntryFormState> {
  final nameController = TextEditingController();
  final streetController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final zipCodeController = TextEditingController();
  final String authorization;

  GymEntryFormBloc(this.authorization)
      : super(const GymEntryFormInitialState()) {
    on<GymEntryFormSubmitEvent>(
      (event, emit) {
        switch (state) {
          case GymEntryFormInitialState() ||
                GymEntryFormFailureState() ||
                GymEntryFormSuccessState():
            emit(
              GymEntryFormLoadingState(
                CancelableOperation.fromFuture(
                  addGym(
                    name: nameController.text,
                    street: streetController.text,
                    city: cityController.text,
                    state: stateController.text,
                    zipCode: zipCodeController.text,
                    authorization: authorization,
                  ),
                )..then((res) => add(GymEntryFormResponseEvent(res))),
              ),
            );
          case GymEntryFormLoadingState():
            throw StateException(state, event);
        }
      },
    );

    on<GymEntryFormResetEvent>(
      (event, emit) async {
        switch (state) {
          case GymEntryFormInitialState() ||
                GymEntryFormFailureState() ||
                GymEntryFormSuccessState():
            emit(const GymEntryFormInitialState());
          case GymEntryFormLoadingState(
              loadingOperation: final loadingOperation
            ):
            await loadingOperation.cancel();
            emit(const GymEntryFormInitialState());
        }
      },
    );

    on<GymEntryFormResponseEvent>(
      (event, emit) {
        switch (state) {
          case GymEntryFormInitialState() ||
                GymEntryFormSuccessState() ||
                GymEntryFormFailureState():
            throw StateException(state, event);
          case GymEntryFormLoadingState():
            emit(
              switch (event.response) {
                HttpResponseOk(data: final data) =>
                  GymEntryFormSuccessState(data),
                HttpResponseFailure(failure: final failure) =>
                  GymEntryFormFailureState(failure),
              },
            );
        }
      },
    );
  }

  @override
  Future<void> close() {
    nameController.dispose();
    streetController.dispose();
    cityController.dispose();
    stateController.dispose();
    zipCodeController.dispose();
    return super.close();
  }
}
