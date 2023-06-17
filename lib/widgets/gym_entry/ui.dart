import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets.dart';
import 'bloc/bloc.dart';

class GymEntryForm extends StatelessWidget {
  final String authorization;

  const GymEntryForm({
    super.key,
    required this.authorization,
  }) : super();

  @override
  Widget build(BuildContext context) => BlocProvider<GymEntryFormBloc>(
        create: (_) => GymEntryFormBloc(authorization),
        child: BlocConsumer<GymEntryFormBloc, GymEntryFormState>(
          listener: (context, state) {
            switch (state) {
              case GymEntryFormFailureState(failure: final failure):
                StyledBanner.show(
                  message: failure.message,
                  error: true,
                );
              case GymEntryFormSuccessState(response: final response):
                StyledBanner.show(
                  message: 'New gym: ${response.gymId}',
                  error: false,
                );
                context.gymEntryFormBloc.nameController.clear();
                context.gymEntryFormBloc.streetController.clear();
                context.gymEntryFormBloc.cityController.clear();
                context.gymEntryFormBloc.stateController.clear();
                context.gymEntryFormBloc.zipCodeController.clear();
              default:
            }
          },
          builder: (context, state) => SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
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
                switch (state) {
                  GymEntryFormInitialState() ||
                  GymEntryFormFailureState() ||
                  GymEntryFormSuccessState() =>
                    TextButton(
                      onPressed: () => context.gymEntryFormBloc
                          .add(const GymEntryFormSubmitEvent()),
                      child: const Text('Submit'),
                    ),
                  GymEntryFormLoadingState() =>
                    const CircularProgressIndicator(),
                },
              ],
            ),
          ),
        ),
      );
}
