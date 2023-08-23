import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/form/form.dart';
import '../bloc/loader/loader.dart';

final class FormProvider<Controllers extends FormControllers, ReqType, ResType>
    extends StatelessWidget {
  final Widget Function(
      BuildContext context,
      Controllers controllers,
      Widget Function(
        Widget Function(BuildContext, LoaderState<ResType>,
                void Function(ReqType) submit)
            formBuilder,
        void Function(BuildContext, LoaderState<ResType>,
                void Function(ReqType) submit)
            formListener,
      )) formConsumer;

  final Controllers Function(BuildContext context) createControllers;
  final Future<ResType> Function(ReqType req) load;
  final ResType? initialData;

  void submit(BuildContext context, ReqType request) =>
      context.formBloc<Controllers>().submit(
            onAccept: () => context.loader<ReqType, ResType>().add(
                  LoaderLoadEvent(request),
                ),
          );

  const FormProvider({
    required this.load,
    required this.formConsumer,
    required this.createControllers,
    this.initialData,
  }) : super();

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => FormBloc(createControllers(context)),
          ),
          BlocProvider(
            create: (_) => LoaderBloc(load: load),
          ),
        ],
        child: FormConsumer<Controllers>(
          listener: (context, formState) {},
          builder: (context, formState) {
            handleSubmit(ReqType req, LoaderState<ResType> loaderState) =>
                switch (loaderState) {
                  LoaderLoadingState() => null,
                  _ => submit(context, req),
                };
            final FormBloc<Controllers> formBloc = context.formBloc();
            return Form(
              key: formBloc.formKey,
              child: formConsumer(
                context,
                formBloc.controllers,
                (formBuilder, formListener) => LoaderConsumer<ReqType, ResType>(
                  builder: (context, loaderState) => formBuilder(context,
                      loaderState, (req) => handleSubmit(req, loaderState)),
                  listener: (context, loaderState) => formListener(context,
                      loaderState, (req) => handleSubmit(req, loaderState)),
                ),
              ),
            );
          },
        ),
      );
}
