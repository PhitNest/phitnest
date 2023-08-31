import 'package:flutter/material.dart';
import 'package:phitnest_core/core.dart';

import '../../../../entities/entities.dart';
import '../../../../repositories/repositories.dart';

part 'bloc.dart';

final class GymEntryForm extends StatelessWidget {
  final ApiInfo apiInfo;
  final void Function(BuildContext) onSessionLost;

  void handleStateChanged(
    BuildContext context,
    GymEntryFormControllers controllers,
    LoaderState<AuthResOrLost<HttpResponse<CreateGymSuccess>>> loaderState,
  ) {
    switch (loaderState) {
      case LoaderLoadedState(data: final response):
        switch (response) {
          case AuthRes(data: final data):
            switch (data) {
              case HttpResponseSuccess(data: final data):
                StyledBanner.show(
                  message: 'Created gym with ID: ${data.gymId}',
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
          case AuthLost():
            onSessionLost(context);
        }
      default:
    }
  }

  const GymEntryForm({
    super.key,
    required this.apiInfo,
    required this.onSessionLost,
  }) : super();

  @override
  Widget build(BuildContext context) => SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        child: gymEntryForm(
          apiInfo,
          (context, controllers, submit) => AuthLoaderConsumer(
            listener: (context, loaderState) =>
                handleStateChanged(context, controllers, loaderState),
            builder: (context, loaderState) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Create Gym'),
                StyledUnderlinedTextField(
                  hint: 'Name',
                  validator: validateNonEmpty,
                  controller: controllers.nameController,
                  textInputAction: TextInputAction.next,
                ),
                StyledUnderlinedTextField(
                  hint: 'Street',
                  controller: controllers.streetController,
                  validator: validateNonEmpty,
                  textInputAction: TextInputAction.next,
                ),
                StyledUnderlinedTextField(
                  hint: 'City',
                  controller: controllers.cityController,
                  validator: validateNonEmpty,
                  textInputAction: TextInputAction.next,
                ),
                StyledUnderlinedTextField(
                  hint: 'State',
                  controller: controllers.stateController,
                  validator: validateNonEmpty,
                  textInputAction: TextInputAction.next,
                ),
                StyledUnderlinedTextField(
                  hint: 'Zip Code',
                  controller: controllers.zipCodeController,
                  validator: validateNonEmpty,
                  textInputAction: TextInputAction.done,
                ),
                switch (loaderState) {
                  LoaderLoadingState() => const Loader(),
                  _ => TextButton(
                      onPressed: () => submit(
                        (
                          sessionLoader: context.sessionLoader,
                          data: CreateGymParams.populated(
                            name: controllers.nameController.text,
                            street: controllers.streetController.text,
                            city: controllers.cityController.text,
                            state: controllers.stateController.text,
                            zipCode: controllers.zipCodeController.text,
                          )
                        ),
                        loaderState,
                      ),
                      child: const Text('Submit'),
                    ),
                },
              ],
            ),
          ),
        ),
      );
}
