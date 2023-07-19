import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phitnest_core/core.dart';

final class Location extends Equatable {
  final double latitude;
  final double longitude;

  const Location({
    required this.latitude,
    required this.longitude,
  }) : super();

  @override
  List<Object?> get props => [latitude, longitude];

  factory Location.fromJson(dynamic json) => switch (json) {
        {
          'latitude': final double latitude,
          'longitude': final double longitude,
        } =>
          Location(
            latitude: latitude,
            longitude: longitude,
          ),
        _ => throw FormatException('Invalid JSON for Location', json),
      };
}

final class GymEntryFormSuccess extends Equatable {
  final String gymId;
  final Location location;

  const GymEntryFormSuccess({
    required this.gymId,
    required this.location,
  }) : super();

  @override
  List<Object?> get props => [gymId, location];

  factory GymEntryFormSuccess.fromJson(dynamic json) => switch (json) {
        {
          'gymId': final String gymId,
          'location': final location,
        } =>
          GymEntryFormSuccess(
            gymId: gymId,
            location: Location.fromJson(location),
          ),
        _ =>
          throw FormatException('Invalid JSON for GymEntryFormSuccess', json),
      };
}

final class GymEntryParams extends Equatable {
  final String name;
  final String street;
  final String city;
  final String state;
  final String zipCode;

  const GymEntryParams({
    required this.name,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
  }) : super();

  @override
  List<Object?> get props => [name, street, city, state, zipCode];

  Map<String, dynamic> toJson() => {
        'name': name,
        'street': street,
        'city': city,
        'state': state,
        'zipCode': zipCode,
      };
}

Future<HttpResponse<GymEntryFormSuccess>> submitGym({
  required GymEntryParams params,
  required Session session,
}) =>
    request(
      route: '/gym',
      method: HttpMethod.post,
      parser: GymEntryFormSuccess.fromJson,
      idToken: session.cognitoSession.idToken.jwtToken,
      data: params.toJson(),
    );

final class GymEntryFormControllers extends FormControllers {
  final nameController = TextEditingController();
  final streetController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final zipCodeController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    streetController.dispose();
    cityController.dispose();
    stateController.dispose();
    zipCodeController.dispose();
  }
}

typedef GymEntryFormBloc = FormBloc<GymEntryFormControllers>;
typedef GymEntryFormConsumer = FormConsumer<GymEntryFormControllers>;
typedef GymEntryFormLoaderBloc
    = LoaderBloc<GymEntryParams, HttpResponse<GymEntryFormSuccess>?>;
typedef GymEntryFormLoaderConsumer
    = LoaderConsumer<GymEntryParams, HttpResponse<GymEntryFormSuccess>?>;

extension on BuildContext {
  GymEntryFormBloc get gymEntryFormBloc => BlocProvider.of(this);
  GymEntryFormLoaderBloc get gymEntryFormLoaderBloc => loader();
}

final class GymEntryForm extends StatelessWidget {
  final void Function(BuildContext) onSessionLost;

  const GymEntryForm({
    super.key,
    required this.onSessionLost,
  }) : super();

  @override
  Widget build(BuildContext context) => SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        child: BlocProvider(
          create: (_) => GymEntryFormBloc(GymEntryFormControllers()),
          child: GymEntryFormConsumer(
            listener: (context, formState) {},
            builder: (context, formState) => Form(
              key: context.gymEntryFormBloc.formKey,
              autovalidateMode: formState.autovalidateMode,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Gym Entry'),
                  StyledUnderlinedTextField(
                    hint: 'Name',
                    controller:
                        context.gymEntryFormBloc.controllers.nameController,
                  ),
                  StyledUnderlinedTextField(
                    hint: 'Street',
                    controller:
                        context.gymEntryFormBloc.controllers.streetController,
                  ),
                  StyledUnderlinedTextField(
                    hint: 'City',
                    controller:
                        context.gymEntryFormBloc.controllers.cityController,
                  ),
                  StyledUnderlinedTextField(
                    hint: 'State',
                    controller:
                        context.gymEntryFormBloc.controllers.stateController,
                  ),
                  StyledUnderlinedTextField(
                    hint: 'ZipCode',
                    controller:
                        context.gymEntryFormBloc.controllers.zipCodeController,
                  ),
                  BlocProvider(
                    create: (context) => GymEntryFormLoaderBloc(
                      load: (params) => context.sessionLoader.session.then(
                        (session) {
                          if (session != null) {
                            return submitGym(
                              params: params,
                              session: session,
                            );
                          }
                          return null;
                        },
                      ),
                    ),
                    child: GymEntryFormLoaderConsumer(
                      listener: (context, gymSubmitState) {
                        switch (gymSubmitState) {
                          case LoaderLoadedState(data: final response):
                            if (response != null) {
                              switch (response) {
                                case HttpResponseSuccess(data: final data):
                                  StyledBanner.show(
                                    message: 'New gym: ${data.gymId}',
                                    error: false,
                                  );
                                case HttpResponseFailure(
                                    failure: final failure
                                  ):
                                  StyledBanner.show(
                                    message: failure.message,
                                    error: true,
                                  );
                              }
                              final gymEntryFormBloc = context.gymEntryFormBloc;
                              gymEntryFormBloc.controllers.nameController
                                  .clear();
                              gymEntryFormBloc.controllers.streetController
                                  .clear();
                              gymEntryFormBloc.controllers.cityController
                                  .clear();
                              gymEntryFormBloc.controllers.stateController
                                  .clear();
                              gymEntryFormBloc.controllers.zipCodeController
                                  .clear();
                            } else {
                              onSessionLost(context);
                            }
                          default:
                        }
                      },
                      builder: (context, gymSubmitState) =>
                          switch (gymSubmitState) {
                        LoaderLoadedState() ||
                        LoaderInitialState() =>
                          TextButton(
                            onPressed: () {
                              final gymEntryFormBloc = context.gymEntryFormBloc;
                              gymEntryFormBloc.submit(
                                onAccept: () =>
                                    context.gymEntryFormLoaderBloc.add(
                                  LoaderLoadEvent(
                                    GymEntryParams(
                                      name: gymEntryFormBloc
                                          .controllers.nameController.text,
                                      street: gymEntryFormBloc
                                          .controllers.streetController.text,
                                      city: gymEntryFormBloc
                                          .controllers.cityController.text,
                                      state: gymEntryFormBloc
                                          .controllers.stateController.text,
                                      zipCode: gymEntryFormBloc
                                          .controllers.zipCodeController.text,
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: const Text('Submit'),
                          ),
                        LoaderLoadingState() =>
                          const CircularProgressIndicator(),
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
