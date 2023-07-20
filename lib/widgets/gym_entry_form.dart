import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
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
      session: session,
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

final class GymEntryForm extends StatelessWidget {
  final void Function(BuildContext) onSessionLost;

  const GymEntryForm({
    super.key,
    required this.onSessionLost,
  }) : super();

  @override
  Widget build(BuildContext context) => SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        child: FormProvider<GymEntryFormControllers, GymEntryParams,
            HttpResponse<GymEntryFormSuccess>?>(
          createControllers: (_) => GymEntryFormControllers(),
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
          formBuilder: (context, controllers, consumer) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Gym Entry'),
              StyledUnderlinedTextField(
                hint: 'Name',
                controller: controllers.nameController,
              ),
              StyledUnderlinedTextField(
                hint: 'Street',
                controller: controllers.streetController,
              ),
              StyledUnderlinedTextField(
                hint: 'City',
                controller: controllers.cityController,
              ),
              StyledUnderlinedTextField(
                hint: 'State',
                controller: controllers.stateController,
              ),
              StyledUnderlinedTextField(
                hint: 'ZipCode',
                controller: controllers.zipCodeController,
              ),
              consumer(
                listener: (context, state, _) {
                  switch (state) {
                    case LoaderLoadedState(data: final response):
                      if (response != null) {
                        switch (response) {
                          case HttpResponseSuccess(data: final data):
                            StyledBanner.show(
                              message: 'New gym: ${data.gymId}',
                              error: false,
                            );
                            controllers.nameController.clear();
                            controllers.streetController.clear();
                            controllers.cityController.clear();
                            controllers.stateController.clear();
                            controllers.zipCodeController.clear();
                          case HttpResponseFailure(failure: final failure):
                            StyledBanner.show(
                              message: failure.message,
                              error: true,
                            );
                        }
                      } else {
                        onSessionLost(context);
                      }
                    default:
                  }
                },
                builder: (context, state, submit) => switch (state) {
                  LoaderLoadedState() || LoaderInitialState() => TextButton(
                      onPressed: () => submit(
                        GymEntryParams(
                          name: controllers.nameController.text,
                          street: controllers.streetController.text,
                          city: controllers.cityController.text,
                          state: controllers.stateController.text,
                          zipCode: controllers.zipCodeController.text,
                        ),
                      ),
                      child: const Text('Submit'),
                    ),
                  LoaderLoadingState() => const CircularProgressIndicator(),
                },
              ),
            ],
          ),
        ),
      );
}
