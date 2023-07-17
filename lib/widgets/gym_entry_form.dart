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
      authorization: session,
      data: params.toJson(),
    );

extension GetGymEntryFormBloc on BuildContext {
  GymEntryFormBloc get gymEntryFormBloc => BlocProvider.of(this);
}

final class GymEntryFormState extends Equatable {
  final AutovalidateMode autovalidateMode;

  const GymEntryFormState(this.autovalidateMode);

  @override
  List<Object?> get props => [autovalidateMode];
}

final class GymEntryFormRejectedEvent extends Equatable {
  const GymEntryFormRejectedEvent();

  @override
  List<Object?> get props => [];
}

final class GymEntryFormBloc
    extends Bloc<GymEntryFormRejectedEvent, GymEntryFormState> {
  final nameController = TextEditingController();
  final streetController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final zipCodeController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  GymEntryFormBloc()
      : super(
          const GymEntryFormState(AutovalidateMode.disabled),
        ) {
    on<GymEntryFormRejectedEvent>(
      (event, emit) => emit(
        const GymEntryFormState(AutovalidateMode.always),
      ),
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

final class GymEntryForm extends StatelessWidget {
  final Session session;

  const GymEntryForm({
    super.key,
    required this.session,
  }) : super();

  void submit(BuildContext context) {
    final gymEntryFormBloc = context.gymEntryFormBloc;
    if (gymEntryFormBloc.formKey.currentState!.validate()) {
      context.loader<GymEntryParams, HttpResponse<GymEntryFormSuccess>>().add(
            LoaderLoadEvent(
              GymEntryParams(
                name: context.gymEntryFormBloc.nameController.text,
                street: context.gymEntryFormBloc.streetController.text,
                city: context.gymEntryFormBloc.cityController.text,
                state: context.gymEntryFormBloc.stateController.text,
                zipCode: context.gymEntryFormBloc.zipCodeController.text,
              ),
            ),
          );
    } else {
      gymEntryFormBloc.add(const GymEntryFormRejectedEvent());
    }
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) =>
                  LoaderBloc<GymEntryParams, HttpResponse<GymEntryFormSuccess>>(
                load: (params) => submitGym(
                  params: params,
                  session: session,
                ),
              ),
            ),
            BlocProvider(
              create: (_) => GymEntryFormBloc(),
            ),
          ],
          child: BlocConsumer<GymEntryFormBloc, GymEntryFormState>(
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
                    controller: context.gymEntryFormBloc.nameController,
                  ),
                  StyledUnderlinedTextField(
                    hint: 'Street',
                    controller: context.gymEntryFormBloc.streetController,
                  ),
                  StyledUnderlinedTextField(
                    hint: 'City',
                    controller: context.gymEntryFormBloc.cityController,
                  ),
                  StyledUnderlinedTextField(
                    hint: 'State',
                    controller: context.gymEntryFormBloc.stateController,
                  ),
                  StyledUnderlinedTextField(
                    hint: 'ZipCode',
                    controller: context.gymEntryFormBloc.zipCodeController,
                  ),
                  LoaderConsumer<GymEntryParams,
                      HttpResponse<GymEntryFormSuccess>>(
                    listener: (context, gymSubmitState) {
                      switch (gymSubmitState) {
                        case LoaderLoadedState(data: final response):
                          switch (response) {
                            case HttpResponseSuccess(data: final data):
                              StyledBanner.show(
                                message: 'New gym: ${data.gymId}',
                                error: false,
                              );
                            case HttpResponseFailure(failure: final failure):
                              StyledBanner.show(
                                message: failure.message,
                                error: true,
                              );
                          }
                          context.gymEntryFormBloc.nameController.clear();
                          context.gymEntryFormBloc.streetController.clear();
                          context.gymEntryFormBloc.cityController.clear();
                          context.gymEntryFormBloc.stateController.clear();
                          context.gymEntryFormBloc.zipCodeController.clear();
                        default:
                      }
                    },
                    builder: (context, gymSubmitState) =>
                        switch (gymSubmitState) {
                      LoaderLoadedState() || LoaderInitialState() => TextButton(
                          onPressed: () => submit(context),
                          child: const Text('Submit'),
                        ),
                      LoaderLoadingState() => const CircularProgressIndicator(),
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
